#!/bin/bash

export SCRAM_ARCH=slc6_amd64_gcc530
#cd /afs/cern.ch/user/y/yohay/CMSSW_8_0_3_patch2/src
cd JOBDIR
eval `scramv1 runtime -sh`
cd -
source /afs/cern.ch/cms/caf/setup.sh
mv JOBDIR/DIRNAME/CFGNAME_JOBNUM.py .
cmsRun CFGNAME_JOBNUM.py
source /afs/cern.ch/project/eos/installation/cms/etc/setup.sh
/afs/cern.ch/project/eos/installation/0.3.84-aquamarine/bin/eos.select cp HHMASS_aAMASS_2mu2tau_DATATIER_NEVENTSEvts_JOBNUM.root /eos/cms/store/user/yohay/DIRNAME/
rm *.py *.root

exit 0
