# Accessing UCSD's T2 XRootD Cluster

## Requesting Access

To request access to UCSD's T2 XRootD cluster for reading and writing files, follow these steps:

1. **Eligibility**: Ensure you are a part of a research group that collaborates with UCSD or has an official agreement for resource sharing.
2. **Access**: Please email t2support@physics.ucsd.edu stating that you need access to the cluster.

## XRootD Caches and Redirectors

When you attempt to open a file, your application must query a redirector to find the file. You must specify the redirector to the application. Which redirector you use depends on your region, to minimize the distance over which the data must travel and thus minimize the reading latency. These "regional" redirectors will try file locations in your region first before trying to go overseas.

## Accessing a File from a Specific Site

In certain cases, when there are multiple replicas available, you may need to bypass the redirectors and directly access a file from a specific site. Here's an example of how to do that:

1. Locate the file replicas using the `dasgoclient` command:
  ```
  dasgoclient -query="site file=/store/data/Run2018A/EGamma/MINIAOD/UL2018_MiniAODv2-v1/50000/8D399CEC-A51E-004C-B4F5-D74B70706892.root"
  ```
  This will return a list of sites where the file replicas are located.

2. Prepend `/store/test/xrootd/SITENAME` to the logical filename. For example, if the site is `T3_US_FNALLPC`, the modified filename would be:
  ```
  /store/test/xrootd/T3_US_FNALLPC/store/data/Run2018A/EGamma/MINIAOD/UL2018_MiniAODv2-v1/50000/8D399CEC-A51E-004C-B4F5-D74B70706892.root
  ```
  This forces the xrootd redirector to only look at the specified site.

  Note: This approach may not work for some T3 sites. Sites with `_TAPE` in the name cannot be read from, and for sites with `_DISK` in the name, remove `_DISK`.

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