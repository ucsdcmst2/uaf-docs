# Running RHEL7 Workflows on RHEL8 (or RHEL9)

There are two main ways to run your RHEL7 workflows on RHEL8 or RHEL9:

### 1. **Switch to the EL8/EL9 Distribution**  
To run your workflows on RHEL8 or RHEL9, you can switch to a newer version of CMSSW built for these distributions if they are compatible with your code. CMSSW provides several versions compatible with EL8 or EL9.

#### How to Check Available CMSSW Versions:
1. **Use `scram` to list available CMSSW versions:**
   You can easily check available CMSSW versions using the `scram` command-line tool. This will list all versions compatible with your environment:
   
   ```sh
   source /cvmfs/cms.cern.ch/cmsset_default.sh
   scram list CMSSW
   ```

   This command will return a list of available CMSSW versions, showing their compatibility with different OS distributions.

2. **Selecting a Compatible Version for EL8/EL9:**
   Once you have the list of available CMSSW versions, choose one that is compatible with EL8 or EL9. Newer versions such as the CMSSW_12 series are typically compatible with these distributions.

3. **Setting up CMSSW for EL8/EL9:**
   After identifying a compatible version, set up the environment by running:
   ```sh
   source /cvmfs/cms.cern.ch/cmsset_default.sh
   cmsrel CMSSW_X_Y_Z
   cd CMSSW_X_Y_Z/src
   cmsenv
   ```

#### Recommended CMSSW Versions for EL8/EL9:
Some of the newer CMSSW releases known to be compatible with EL8 and EL9 include:
- **CMSSW_12_X_Y** series for EL8/EL9
- **CMSSW_11_3_4** (recommended for EL8)
- **CMSSW_12_0_X** (for recent developments and EL9 compatibility)

It's important to test your workflows with the selected version, as newer versions may include updates that affect compatibility with your code.

---

### 2. **Run Existing Code with Current CMSSW Version in a Singularity Container**  
If switching to a newer CMSSW version is not possible, you can run your current version in a Singularity container. 
CMS distributes helper scripts (`cmssw-el{5,6,7,8,9}`) under `/cvmfs/cms.cern.ch/common` to set up CMS OS environments. 

Available images include: 

   + `cmssw/el9:x86_64`
   + `cmssw/el8:x86_64`
   + `cmssw/el7:x86_64`
   + `cmssw/el6:x86_64`
   + `cmssw/el5:x86_64`

   **Note: Before performing any tasks, you must first launch the Singularity container and then run cmsenv to configure your working environment.**

## Setting Up SLC5/SLC6/SLC7/EL8/EL9 CMS Environment

**Run `cmssw-elN` to set up the environment** (e.g., `cmssw-el5`, `cmssw-el6`, etc.). depending on which RHEL release your CMSSW version works with.
   Ensure the CMS default setup script is sourced beforehand, otherwise do it using:
   ```sh
   source /cvmfs/cms.cern.ch/cmsset_default.sh
   ```
**Examples for different environments:**

- **SLC5 Environment**:
   ```sh
   $ cmssw-el5
   $ cat /etc/redhat-release 
   Scientific Linux CERN SLC release 5.11 (Boron)
   $ exit
   ```

- **SLC6/CentOS6 Environment**:
   ```sh
   $ cmssw-el6
   $ cat /etc/redhat-release 
   CentOS release 6.10 (Final)
   $ exit
   ```

- **SLC7/CentOS7 Environment**:
   ```sh
   $ cmssw-el7
   $ cat /etc/redhat-release 
   CentOS Linux release 7.8.2003 (Core)
   $ exit
   ```

- **EL8/EL9 Environment**:
   ```sh
   $ cmssw-el8  # OR cmssw-el9
   $ cat /etc/redhat-release
   AlmaLinux release 8.5 (Arctic Sphynx)
   $ exit
   ```

- **To run a single command**:
   ```sh
   $ cmssw-el9 -- cat /etc/redhat-release
   AlmaLinux release 9.0 Beta (Emerald Puma)
   ```

After this, you should be able to run `cmsenv` and things should work as usual.