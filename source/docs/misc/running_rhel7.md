# Running Legacy Workflows (RHEL7/SLC6)

The UAF nodes currently run **AlmaLinux 8 (EL8)**. If your analysis code depends on older operating systems/environments like RHEL7 (EL7) or SLC6, you cannot run it directly on the host.

You have two primary options to run these legacy workflows:

## Option 1: Use a Compatible CMSSW Version (Recommended)

The easiest solution is to migrate your workflow to a CMSSW release that supports EL8.

1.  **Check Available Versions**:
    Use `scram` to find valid releases for your architecture (usually `slc7_amd64_...` or `el8_amd64_...`):
    ```bash
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    scram list CMSSW
    ```

2.  **Select an EL8-Compatible Release**:
    *   **CMSSW_12_X and newer**: Fully support EL8.
    *   **CMSSW_10_6_X**: Some patch releases are compatible with EL8.

3.  **Setup Environment**:
    ```bash
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    export SCRAM_ARCH=el8_amd64_gcc10 # Example architecture
    cmsrel CMSSW_12_4_0
    cd CMSSW_12_4_0/src
    cmsenv
    ```

## Option 2: Use Singularity Containers

If you strictly require an older environment (e.g., for reproducing old results or using legacy `SCRAM_ARCH` builds), you can launch a **Singularity container**. This creates a lightweight shell environment that mimics the older OS.

CMS provides helper scripts to launch these containers instantly.

### Available Environments

*   **EL7 (CentOS 7)**: Use `cmssw-el7`
*   **EL6 (SLC 6)**: Use `cmssw-el6`
*   **EL9 (AlmaLinux 9)**: Use `cmssw-el9`

### How to Use

1.  **Launch the container**:
    Simply run the command corresponding to the OS you need:
    ```bash
    [user@uaf-2 ~]$ cmssw-el7
    ```

2.  **Verify the environment**:
    Inside the container, checking the release file will show the legacy OS:
    ```bash
    [user@uaf-2 ~]$ cat /etc/redhat-release
    CentOS Linux release 7.9.2009 (Core)
    ```

3.  **Run your analysis**:
    Now you can proceed with your standard CMS setup (sourcing `cmsset_default.sh`, `cmsenv`, etc.) as if you were on a native EL7 machine.

    ```bash
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    export SCRAM_ARCH=slc7_amd64_gcc700
    cmsrel CMSSW_10_2_0
    cd CMSSW_10_2_0/src
    cmsenv
    # Run your code...
    ```

4.  **Exit**:
    Type `exit` to return to the native EL8 host shell.
    ```bash
    exit
    ```

### Single Command Execution

You can also run a single command inside the container without entering an interactive shell:

```bash
cmssw-el7 -- command_to_run
```

*Example:*
```bash
cmssw-el7 -- cmsRun my_config.py
```

After this, you should be able to run `cmsenv` and things should work as usual.