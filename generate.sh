#!/bin/bash

#parse arguments
if [ $# -ne 7 ]
    then
    echo "Usage: ./generate.sh data_tier number_of_events_per_job H_mass a_mass start_job num_jobs queue"
    exit 0
fi
data_tier=$1
number_of_events_per_job=$2
H_mass=$3
a_mass=$4
start=$5
num_jobs=$6
queue=$7
cfg_name=H${H_mass}_a${a_mass}_2mu2tau_${data_tier}_${number_of_events_per_job}Evts
dir_name=H${H_mass}_a${a_mass}_2mu2tau_${number_of_events_per_job}EvtsPerJob_${num_jobs}Jobs
job_dir=`pwd`
username=`whoami`

#check for directory with GEN-SIM files on EOS
GEN_SIM_EOS_dir_query=`eos ls /store/user/yohay/${dir_name}`
GEN_SIM_EOS_dir_query=`echo $GEN_SIM_EOS_dir_query | grep directory`
if [ "$GEN_SIM_EOS_dir_query" != "" ]
    then
    echo "Directory /store/user/yohay/${dir_name} not found.  Please create GEN-SIM files before DIGI-HLT, RECO, or re-HLT."
    exit 0
fi

#check for user's EOS directory for holding DIGI-HLT, RECO, and reHLT files
EOS_dir_query=`eos ls /store/user/$username/${dir_name}`
EOS_dir_query=`echo $EOS_dir_query | grep directory`
if [ "$EOS_dir_query" != "" ]
    then
    if [ $data_tier = "DIGI-HLT" ]
	then
	eos mkdir /eos/cms/store/user/$username/$dir_name
    elif [ $data_tier = "RECO" ] || [ $data_tier = "reHLT" ]
	then
	echo "Directory /store/user/$username/${dir_name} not found.  Please create DIGI-HLT files before RECO or reHLT."
	exit 0
    fi
fi

#check for directory for holding all generated scripts and LSF output directories
if [ ! -d $dir_name ]
    then
    if [ $data_tier = "DIGI-HLT" ] || [ $data_tier = "reHLT" ]
	then
	mkdir $dir_name
    elif [ $data_tier = "RECO" ]
	then
	echo "Directory `pwd`/${dir_name} not found.  Please create DIGI-HLT files before RECO."
	exit 0
    fi
fi
cd $dir_name

#generate cfg and sh files for each job
for i in `seq $start $num_jobs`
  do
  sed -e "s%USERNAME%$username%g" -e "s%NEVENTS%$number_of_events_per_job%g" -e "s%HMASS%$H_mass%g" -e "s%AMASS%$a_mass%g" -e "s%JOBNUM%$i%g" -e "s%DIRNAME%$dir_name%g" ../2mu2tau_${data_tier}.py > ${cfg_name}_${i}.py
  sed -e "s%USERNAME%$username%g" -e "s%JOBDIR%$job_dir%g" -e "s%NEVENTS%$number_of_events_per_job%g" -e "s%HMASS%$H_mass%g" -e "s%AMASS%$a_mass%g" -e "s%JOBNUM%$i%g" -e "s%DIRNAME%$dir_name%g" -e "s%CFGNAME%$cfg_name%g" -e "s%DATATIER%$data_tier%g" ../2mu2tau.sh > ${cfg_name}_${i}.sh
  chmod a+x ${cfg_name}_${i}.sh
  bsub -q $queue -J ${cfg_name}_${i} < ${cfg_name}_${i}.sh
  rm ${cfg_name}_${i}.sh
done

exit 0
