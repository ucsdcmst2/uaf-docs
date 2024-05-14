# Old vs. New UAFs (WIP)

UAF-1, 7, 8 and 10 are older machines with processors launched in 2010.
UAF-2, 3 and 4 are newer machines commissioned in 2023 with the latest CPUs, a large amount of memory and NVMe storage.

They all have Ceph mounted on them and run the condor scheduler which allows you to submit condor jobs.


# Running your slc7 workflows on RHEL8

There are two ways of doing this,
1) Switch to using el8 distribution of el8, if newer versions of cmssw are compatible with your code, all you need to do it run cmsenv for cmssw compatible with el8. for example.

    ```
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    cmsrel CMSSW_11_3_4
    cd CMSSW_11_3_4/src
    cmsenv
    ```

2) Run you existing code with the same cmssw in an slc7 singularity container,
    ```
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    cmssw-el7
    cd <YOUR_CMSSW_PATH>/src
    cmsenv
    ```

