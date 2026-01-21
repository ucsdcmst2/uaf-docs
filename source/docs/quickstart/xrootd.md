# Accessing CMS Data via XRootD at UCSD T2

XRootD is a scalable, high-performance data access protocol widely used in high-energy physics for remote file access. The UCSD CMS T2 facility provides XRootD access to both local storage and the CMS global data federation.

## XRootD Capabilities

XRootD at UCSD T2 enables:

- **Remote data access** without copying files locally
- **Streaming** of partial file contents for efficient reads
- **Seamless integration** with ROOT and CMS software
- **Federation access** to files stored at any CMS site worldwide
- **Write access** to your personal storage areas

## XRootD Access Configuration

### For UAF Users

If you have a UAF account, you already have access to XRootD through your Grid certificate proxy. To set up your access:

1. **Initialize your proxy** (valid for 7 days):
   ```bash
   voms-proxy-init --voms cms --valid 168:00
   ```

2. **Verify proxy status**:
   ```bash
   voms-proxy-info
   ```

3. **Access files** using standard XRootD syntax:
   ```bash
   xrdcp root://redirector.t2.ucsd.edu:1094//store/user/yourname/file.root ./local_copy.root
   ```

### For External Users

External collaborators need special access to the UCSD XRootD services:

1. **Eligibility**: You must be part of a CMS research group or have a formal collaboration with UCSD
2. **Request Access**: Email t2support@physics.ucsd.edu with:
   - Your full name and institution
   - CMS role (if applicable)
   - DN of your Grid certificate
   - Justification for UCSD T2 access
   - Estimated data volume and duration

## XRootD Redirectors and Performance Optimization

XRootD uses a hierarchical system of "redirectors" that help locate files across distributed storage systems. Understanding how to use these redirectors effectively can significantly improve your data access performance.

### Primary UCSD Redirector

For accessing files at UCSD:

```
root://redirector.t2.ucsd.edu:1094//store/...
```

This redirector provides the fastest access to data stored on UCSD CEPH systems.

### Regional and Global Redirectors

CMS provides regional and global redirectors based on your location:

| Region | Redirector | Usage |
|--------|------------|-------|
| USA | `root://cmsxrootd.fnal.gov:1094//store/...` | Best for users in North America |
| Europe | `root://xrootd-cms.infn.it:1094//store/...` | Best for users in Europe |
| Global | `root://cms-xrd-global.cern.ch:1094//store/...` | Fallback option, works worldwide |

When accessing data, the regional redirectors will search for files in your region first before looking elsewhere, minimizing latency and maximizing throughput. Use the redirector that corresponds to your geographic location for optimal performance.

## Using XRootD in Practice

### Command Line Tools

XRootD provides several command-line utilities for file operations:

#### 1. File Transfers with `xrdcp`

```bash
# Copy a remote file to local storage
xrdcp root://redirector.t2.ucsd.edu:1094//store/user/username/myfile.root /tmp/myfile.root

# Copy a local file to remote storage
xrdcp analysis_result.root root://redirector.t2.ucsd.edu:1094//store/user/username/analysis_result.root

# Copy with progress bar and checksum verification
xrdcp --progress --cksum adler32 source_file.root root://redirector.t2.ucsd.edu:1094//store/user/username/dest_file.root
```

#### 2. Directory Operations with `xrdfs`

```bash
# List directory contents
xrdfs redirector.t2.ucsd.edu:1094 ls /store/user/username/

# Create a new directory
xrdfs redirector.t2.ucsd.edu:1094 mkdir /store/user/username/new_directory

# Check if a file exists
xrdfs redirector.t2.ucsd.edu:1094 stat /store/user/username/myfile.root

# Remove a file
xrdfs redirector.t2.ucsd.edu:1094 rm /store/user/username/old_file.root
```

### Using XRootD in ROOT Analysis

```cpp
// Opening a remote ROOT file
TFile *f = TFile::Open("root://redirector.t2.ucsd.edu:1094//store/user/username/histograms.root");

// Using TChain with XRootD
TChain *chain = new TChain("Events");
chain->Add("root://redirector.t2.ucsd.edu:1094//store/user/username/dataset/*.root");
```

### Using XRootD in Python with uproot

```python
import uproot

# Reading a remote file
file = uproot.open("root://redirector.t2.ucsd.edu:1094//store/user/username/histograms.root")
hist = file["myHistogram"]

# Creating a DataFrame from remote data
import awkward as ak
import numpy as np
import uproot

events = uproot.open("root://cmsxrootd.fnal.gov:1094//store/data/Run2018A/EGamma/MINIAOD/UL2018_MiniAODv2-v1/50000/8D399CEC-A51E-004C-B4F5-D74B70706892.root:Events")
electrons_pt = events["Electron_pt"].array()
```

## Accessing Files from Specific Sites

For targeted access to files at particular storage locations:

1. **Find file replicas** using DAS:
   ```bash
   # Initialize your CERN credentials if not on UAF
   source /cvmfs/cms.cern.ch/cmsset_default.sh
   
   # Find replicas
   dasgoclient -query="site file=/store/data/Run2018A/EGamma/MINIAOD/UL2018_MiniAODv2-v1/50000/8D399CEC-A51E-004C-B4F5-D74B70706892.root"
   ```

2. **Access from a specific site** by prepending the site name:
   ```bash
   xrdcp root://xrootd-cms.infn.it:1094//store/test/xrootd/T2_IT_Pisa/store/data/Run2018A/EGamma/MINIAOD/UL2018_MiniAODv2-v1/50000/8D399CEC-A51E-004C-B4F5-D74B70706892.root ./local_copy.root
   ```

   > **Notes**: 
   > - This approach may not work for all T3 sites
   > - Sites with `_TAPE` in the name cannot be directly read
   > - For sites with `_DISK` in the name, remove `_DISK` from the path

3. Test the access using the `xrdfs` command:
  ```
  xrdfs root://cmsxrootd.fnal.gov/ ls -l /store/test/xrootd/T3_US_FNALLPC/store/data/Run2018A/EGamma/MINIAOD/UL2018_MiniAODv2-v1/50000/8D399CEC-A51E-004C-B4F5-D74B70706892.root
  ```
  This will return information about the file, such as its size and timestamp.

Please note that the commands and filenames provided in this example are specific to the given scenario and may need to be adjusted based on your requirements.

### List of Redirectors

Here is a list of XRootD redirectors and caches:

- Local (UCSD) redirector: `davs://redirector.t2.ucsd.edu:1095`
- Global redirector: `root://cmsxrootd.fnal.gov:1094`

Please note that these addresses are subject to change. It is recommended to refer to the UCSD UAF documentation for the most up-to-date information.

## Reading Files over XRootD

### Using `xrdcp`

The `xrdcp` command allows you to copy files from the XRootD cluster to your local machine or another remote location.

- **Syntax**: `xrdcp [options] source destination`
- **Example**: To copy a file from the cluster to your local machine:
  ```sh
  xrdcp root://redirector.t2.ucsd.edu:1095//path/to/remote/file /path/to/local/destination
  ```
- **Options**: Use `-f` for force overwrite and `-P` for parallel copying to improve transfer speed.

### Using `gfal-copy`

The `gfal-copy` command is another tool for file transfers, particularly useful for grid environments.

- **Syntax**: `gfal-copy [options] source destination`
- **Example**: To copy a file from the cluster to your local machine (Make sure you have a valid VOMS proxy):
  ```sh
  gfal-copy davs://redirector.t2.ucsd.edu:1095//path/to/remote/file file:///path/to/local/destination
  ```
  Or to copy a file from a remote server to UCSD CEPH:
  ```sh
  gfal-copy file:///path/to/local/destination davs://redirector.t2.ucsd.edu:1095//store/user/<YOUR_USERNAME>/
  ```
- **Options**: Use `-f` to force overwrite and `-v` for verbose output to get detailed transfer information.

## Reading Files from Inside ROOT

ROOT is a data analysis framework widely used in high energy physics. You can read files from the XRootD cluster directly within a ROOT session.

- **Example**: To open a file from the cluster:
  ```cpp
  TFile *file = TFile::Open("root://redirector.t2.ucsd.edu:1095//path/to/remote/file");
  // Proceed with your analysis
  ```
- Ensure you have the necessary ROOT version installed that supports XRootD.

## Additional Tips

- **Documentation**: Refer to the UCSD UAF documentation for detailed instructions and best practices.
- **Support**: If you encounter any issues, contact the support team at [t2support@physics.ucsd.edu](mailto:support@t2.ucsd.edu).