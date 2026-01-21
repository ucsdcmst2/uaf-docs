# Using CEPH at UCSD CMS T2

CEPH is a robust, high-performance distributed storage system integrated into the UCSD T2 computing infrastructure. It provides petabyte-scale storage capacity specifically designed for the data-intensive needs of high-energy physics analysis workflows.

## What is CEPH and Why Use It?

CEPH offers several key advantages for CMS data analysis:

- **Scalable Storage**: Designed to handle the multi-petabyte storage requirements of modern physics analysis
- **High Availability**: Distributed architecture ensures data remains accessible even if individual storage nodes fail
- **Data Accessibility**: Pre-mounted on all UAF machines and accessible via the UCSD XRootD redirector
- **Performance**: Optimized for scientific computing workloads with high read/write throughput
- **Integration**: Seamlessly works with CMS data management tools and HTCondor jobs

CEPH is already configured and ready to use on all UAF machines, providing a centralized location to store your research data, analysis code, and results.

### 1. CEPH Overview

CEPH at UCSD CMS Tier 2 is already configured and mounted at `/ceph`, offering high-performance storage optimized for large datasets. Users do not need to mount anything manually, and all operations are done directly in the provided directories.

### 2. Accessing CEPH

The CEPH storage system is mounted at `/ceph`. For CMS users, the relevant directory for storing your data is:

```
/ceph/cms/store/user/
```

Each user is responsible for creating their own directory under this path.

---

### 3. Setting Up Your User Directory

1. **Navigate to the user storage directory**:
   ```bash
   cd /ceph/cms/store/user/
   ```

2. **Create your personal user directory**:
   Replace `username` with your UCSD CMS username.
   ```bash
   mkdir username
   ```

4. **Set the correct permissions**:
   Ensure your directory is accessible only to you.
   ```bash
   chmod 700 username
   ```

---

### 4. Important Storage Policies and Best Practices

CEPH storage at UCSD T2 is a shared resource optimized for high-energy physics workflows. To ensure efficient operation for all users, please adhere to these guidelines:

#### File Types and Optimization

- **Recommended for CEPH storage**:
  - Large data files (ROOT files, HDF5, etc.)
  - Analysis outputs and results
  - Data that needs to be accessed from multiple jobs or machines

- **Not recommended for CEPH storage**:
  - Thousands of small files (< 10MB each)
  - Source code repositories (consider using GitHub instead)
  - Operating system or software installation files
  - Temporary or intermediate files

#### Data Management Guidelines

1. **Regular Cleanup**: Periodically review and remove unneeded files
2. **Compression**: Consider compressing large text files or logs before storage
3. **Organization**: Use a clear directory structure with descriptive naming
4. **Data Lifecycle**: Move completed analysis data to long-term storage when appropriate

#### Quota and Usage Monitoring

Users are allocated storage quotas based on their research needs. To check your current usage:

```bash
ceph_quota_check
```

If you need additional storage space, please email t2support@physics.ucsd.edu with your request and justification.

### 5. Accessing CEPH via XRootD

Files stored in your CEPH user directory can also be accessed via the UCSD XRootD redirector, which is particularly useful for distributed computing jobs:

```bash
# XRootD path format
root://redirector.t2.ucsd.edu:1094//store/user/username/your_file.root
```

For more information on XRootD, see the [XRootD Access Guide](../quickstart/xrootd.md).

#### **Do Not Store Small Files (Under 100 MB)**

**IMPORTANT**: CEPH storage is optimized for large files, and **small files (less than 100 MB) should not be stored** in the system. Storing many small files in CEPH can degrade system performance and lead to inefficiencies, both for your own workflows and for others using the storage.

To manage small files:

- **Aggregate small files** into larger archives (e.g., using `tar` or `zip`).
- **Avoid frequent uploads of individual small files**. Instead, collect your data into larger datasets before transferring.

Violating this policy could result in storage performance issues, and excessive small file storage may lead to restrictions for everybody.

---

### 5. Accessing Files via Xrootd

Files stored in your user directory can be accessed remotely through the UCSD Xrootd redirector. The Xrootd protocol allows for efficient, remote access to large datasets commonly used in high energy physics workflows.

To access files stored under `/ceph/cms/store/user/`, use the following Xrootd redirector URL:

```
davs://redirector.t2.ucsd.edu:1095//store/user/<your_username>
```

Please refer to the [UCSD XRootD Cluster](../quickstart/xrootd.md) page for more details.