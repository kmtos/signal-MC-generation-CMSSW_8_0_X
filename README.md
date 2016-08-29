# signal-MC-generation-CMSSW_8_0_X

## Setup

Go to https://github.com/rpyohay/signal-MC-generation-CMSSW_8_0_X and click "Fork" in the upper right-hand corner, then execute:

```
cd ~
cmsrel CMSSW_8_0_3_patch2
cd CMSSW_8_0_3_patch2/src
cmsenv
git clone https://github.com/YOUR-GITHUB-USERNAME/signal-MC-generation-CMSSW_8_0_X.git .
git remote add upstream https://github.com/rpyohay/signal-MC-generation-CMSSW_8_0_X.git
git fetch upstream
git checkout master
git merge upstream/master
```

Make changes and resolve conflicts as usual.  Then, execute:

```
git commit -m "YOUR COMMIT MESSAGE"
git push origin master
scram b
```

## Running the DIGI-HLT step

Note that this step runs the old, non-upgrade trigger emulation that is incompatible with 2016 data.  It is just a necessary first step.  The HLT information will be re-run later.  For the H(125) sample, run

```
./generate.sh DIGI-HLT 100 125 9 1 10 8nh
```

where DIGI-HLT is the data tier to produce (only possible values are DIGI-HLT, RECO, or reHLT), 100 is the number of events per job, 125 is the H mass, 9 is the a mass, "1 10" means submit 10 jobs total, numbered 1 through 10, and 8nh is the LSF queue.  This is the only command that will work right now (meaning don't try to change the number of jobs or events) because the GEN-SIM samples it is running over are only 10 jobs of 100 events each.

A directory will be created locally called H125_a9_2mu2tau_100EvtsPerJob_10Jobs/ that contains your generated Python files and the LSF output directories.  The created ROOT files will be stored on EOS in /store/user/YOUR-EOS-USERNAME/H125_a9_2mu2tau_100EvtsPerJob_10Jobs/.

For the H(750) sample, run

```
./generate.sh DIGI-HLT 100 750 9 1 10 8nh
```

Again, this is the only command that will work right now.  The directory structure is similar to that described above for H(125).

## Running the RECO step

Once the DIGI-HLT jobs are done, you can run

```
cd ~/CMSSW_8_0_3_patch2/src
cmsenv
./generate.sh RECO 100 125 9 1 10 8nh
./generate.sh RECO 100 750 9 1 10 8nh
```

Again, these are the only commands that will work right now.  The Python files will go into the local directory from before, and the  output files will go into the EOS directory from before.

## Running the reHLT step

You need to run the re-HLT in a different CMSSW release area:

```
cd ~
cmsrel CMSSW_8_0_11
cd CMSSW_8_0_11/src
cmsenv
git clone https://github.com/YOUR-GITHUB-USERNAME/signal-MC-generation-CMSSW_8_0_X.git .
git remote add upstream https://github.com/rpyohay/signal-MC-generation-CMSSW_8_0_X.git
git fetch upstream
git checkout master
git merge upstream/master
```

Make changes and resolve conflicts as usual.  Then, execute:

```
git commit -m "YOUR COMMIT MESSAGE"
git push origin master
scram b
```

Once the RECO jobs are done, you can run

```
cd ~/CMSSW_8_0_11/src
cmsenv
./generate.sh reHLT 100 125 9 1 10 8nh
./generate.sh reHLT 100 750 9 1 10 8nh
```

Again, these are the only commands that will work right now.  The Python files will go into a newly created local directory , and the  output files will go into the EOS directory from before.
