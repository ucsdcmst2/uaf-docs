# Accessing the UAFs via SSH

Once you have been granted access, follow these steps to login:

1. **Open a Terminal**: On your local machine, open a terminal or command prompt.
2. **SSH Command**: Use the `ssh` command followed by your username and the cluster's hostname. For example:
   ```sh
   ssh your_username@uaf-2.t2.ucsd.edu
   ```
3. **Authentication**: When prompted, enter your password. If you have set up SSH keys, ensure your public key is added to the cluster's authorized keys.
4. **Session Management**: Once logged in, you can navigate the cluster's file system, run commands, and manage your files. Use `exit` to end your SSH session.

Currently available machines (All on AlmaLinux 8)

>
```
your_username@uaf-2.t2.ucsd.edu
your_username@uaf-3.t2.ucsd.edu
your_username@uaf-4.t2.ucsd.edu
```

# Machine Specifications

UAF-2, UAF-3, and UAF-4 are state-of-the-art machines commissioned in 2023. These machines are equipped with the latest CPUs, a generous amount of memory, and high-speed NVMe storage. Here are the detailed specifications for each machine:

- UAF-2,3,4:
    - CPU: 2 x AMD EPYC 7662 64-Core Processor
    - Memory: 512 GB
    - Storage: 7.0 TB of NVMe

Please note that UAF-1, UAF-7, UAF-8, and UAF-10 are older machines that are currently offline.

All hosts have CEPH mounted on them and run the condor scheduler which allows you to submit condor jobs.

If you have any further questions or need assistance, please feel free to reach via email to the T2 Support team at **t2support@physics.ucsd.edu**