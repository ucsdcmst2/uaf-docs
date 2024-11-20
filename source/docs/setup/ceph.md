# Using CEPH at UCSD

CEPH offers a network accessible filesystem, mountable from several clients at once, for supported Linux operating systems.

It is a distributed storage system integrated into the UCSD T2 cluster, providing scalable storage. 

CEPH is pre-mounted and ready to use on all the UAF machines, making it simple to store and manage data. Additionally, files stored in user directories can be accessed via the UCSD XRootD redirector, making data retrieval more flexible. However, there are some important usage policies to follow, including restrictions on the types of files that can be stored efficiently.

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

Follow these steps to set up your personal user directory:

1. **Log in** to the UCSD CMS T2 cluster.
   
2. **Navigate to the user storage directory**:
   ```bash
   cd /ceph/cms/store/user/
   ```

3. **Create your personal user directory**:
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

### 4. Important Storage Policies

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