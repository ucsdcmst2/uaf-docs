# Accessing the UCSD CMS T2 User Analysis Facility

## SSH Access to UAF Machines

After your account has been created and your SSH key has been authorized, you can access the UCSD UAF machines securely via SSH:

### Basic SSH Connection

Connect to any of the UAF login nodes using your username:

```bash
ssh username@uaf-2.t2.ucsd.edu
```

*Replace `username` with your assigned UAF username.*

### First Login Authentication

*   On your first connection, verify the host fingerprint and type `yes`.
*   If your SSH key is passphrase-protected, enter it when prompted.

### Session Management

*   **Persistence**: Your home directory is mounted on all UAF nodes (NFS).
*   **Long-running tasks**: Use `tmux` or `screen` to keep sessions active after disconnecting.

### Advanced SSH Configuration

To simplify access (`ssh uaf2`), add the following to your local `~/.ssh/config`:
   ```
   # UCSD CMS T2 UAF Cluster Configuration
   Host uaf-*
       HostName %h.t2.ucsd.edu
       User your_username
       IdentityFile ~/.ssh/id_ed25519
       ServerAliveInterval 120
       
   # Shorthand aliases
   Host uaf2
       HostName uaf-2.t2.ucsd.edu
       User your_username
       IdentityFile ~/.ssh/id_ed25519
   ```

3. Now you can connect with simpler commands:
   ```bash
   ssh uaf2
   # or
   ssh uaf-3
   ```

## Currently Available Machines

The following machines are currently available for use:

- **uaf-2.t2.ucsd.edu** (AlmaLinux 8)
- **uaf-3.t2.ucsd.edu** (AlmaLinux 8)
- **uaf-4.t2.ucsd.edu** (AlmaLinux 8)

## Available Computing Resources

### Current Production UAF Machines

The UCSD CMS T2 cluster provides high-performance computing resources through its User Analysis Facility (UAF) machines:

| Hostname | Operating System | Status | Access Method |
|----------|------------------|--------|---------------|
| uaf-2.t2.ucsd.edu | AlmaLinux 8 | **ONLINE** | SSH |
| uaf-3.t2.ucsd.edu | AlmaLinux 8 | **ONLINE** | SSH |
| uaf-4.t2.ucsd.edu | AlmaLinux 8 | **ONLINE** | SSH |
| uaf-10.t2.ucsd.edu | AlmaLinux 8 | **ONLINE** | SSH |

> **Note**: Legacy machines UAF-1, UAF-7 and UAF-8 have been decommissioned and are no longer available.

### Hardware Specifications

UAF-2, UAF-3, and UAF-4 are high-performance computing nodes commissioned in 2023, designed specifically for data-intensive physics analysis:

| Component | Specification |
|-----------|---------------|
| **CPU** | 2 × AMD EPYC 7662 (128 cores total) |
| **Memory** | 512 GB DDR4 |
| **Local Storage** | 7.0 TB NVMe SSD |
| **Network** | 10 Gbps connection |

### Integrated Resources

All UAF hosts are equipped with:

- **CEPH Distributed Storage**: Mounted at `/ceph` for seamless access to petabyte-scale data
- **HTCondor Scheduler**: For submitting jobs to the broader compute cluster
- **CVMFS**: Access to CMS software repositories via `/cvmfs/cms.cern.ch`
- **XRootD**: Data access protocols for remote file access
- **Software Environment**: Pre-configured with scientific computing tools and libraries

### Resource Selection Guidelines

- **Interactive Work**: Use any available UAF machine
- **Heavy Analysis**: Distribute intensive workloads across the cluster using HTCondor

If you have any further questions or need assistance, please feel free to reach out via email to the T2 Support team at **t2support@physics.ucsd.edu**.
