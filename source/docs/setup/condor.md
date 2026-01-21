# Using the HTCondor Batch System

HTCondor is a specialized workload management system designed for compute-intensive tasks. At UCSD's CMS T2 facility, HTCondor enables efficient distribution of computational workloads across our high-performance clusters. This guide will help you effectively leverage HTCondor for your data analysis workflows.

> This guide is adapted from the [CERN batch submission documentation](https://batchdocs.web.cern.ch/local/index.html) with specific enhancements for the UCSD T2 environment.

## Prerequisites

Submit jobs from one of the UAF submission nodes:
*   `uaf-2.t2.ucsd.edu`
*   `uaf-3.t2.ucsd.edu`
*   `uaf-4.t2.ucsd.edu`

## Submit File

Here’s an example submit file:

```bash
executable            = hello_world.sh
arguments             = $(ClusterId) $(ProcId)
output                = output/hello.$(ClusterId).$(ProcId).out
error                 = error/hello.$(ClusterId).$(ProcId).err
log                   = log/hello.$(ClusterId).log
queue
```

### Explanation of Submit File

- **executable**: The script or command you want HTCondor to run. This can be a shell script (`.sh`), Python script (`.py`), or any other executable file.
- **arguments**: Parameters passed to your executable. The `$(ClusterId)` and `$(ProcId)` are HTCondor variables:
  - `$(ClusterId)`: A unique identifier assigned to your job batch when submitted
  - `$(ProcId)`: Process ID that increments for each job in a cluster (starts at 0)
- **output**: Specifies where standard output (STDOUT) should be saved. **Important:** HTCondor won't automatically create directories, so you must create output directories before submission:
  ```bash
  mkdir -p output error log
  ```
- **error**: Specifies where standard error (STDERR) should be saved.
- **log**: Contains HTCondor's internal logs for your jobs, including submission times, execution host, completion status, and resource usage.
- **queue**: Tells HTCondor to submit the job to the scheduling queue. This directive can take parameters to submit multiple jobs (see "Advanced Job Submission" section below).

## Submitting the Job

On any configured submit host, run the following:

```bash
$ condor_submit hello.sub

Submitting job(s).
1 job(s) submitted to cluster 70.
```

This output shows the `ClusterId` referred to in the submit file.

## Monitoring the Job

You can check the job status using `condor_q`:

```bash
$ condor_q

-- Schedd: uaf-2.t2.ucsd.edu : <132.239.27.11:9618?...>
 ID      OWNER            SUBMITTED     RUN_TIME ST PRI SIZE CMD               
 70.0   username        5/10 14:22   0+00:00:00 I  0   0.0  hello_world.sh 70 0
```

Common job states include:
- **I**: Idle (waiting to be matched with a resource)
- **R**: Running
- **H**: Held (job has encountered an error)
- **C**: Completed

To see only your jobs, use:
```bash
$ condor_q -submitter $USER
```

To see detailed information about a specific job:
```bash
$ condor_q -l 70.0
```

## Managing Jobs

### Removing Jobs
If you need to cancel a job:
```bash
# Remove a specific job
$ condor_rm 70.0

# Remove all your jobs
$ condor_rm $USER
```

### Analyzing Completed Jobs
To see information about completed jobs (useful for debugging):
```bash
$ condor_history $USER
```

## Advanced Job Submission

### Resource Requirements
You can specify CPU, memory, and disk requirements:

```bash
executable            = my_analysis.sh
arguments             = $(ClusterId) $(ProcId)
output                = output/analysis.$(ClusterId).$(ProcId).out
error                 = error/analysis.$(ClusterId).$(ProcId).err
log                   = log/analysis.$(ClusterId).log

# Resource specifications
request_cpus          = 2         # Request 2 CPU cores
request_memory        = 4096MB    # Request 4GB of memory
request_disk          = 10GB      # Request 10GB of disk space

queue
```

### Submitting Multiple Jobs
To submit multiple similar jobs with different parameters:

```bash
executable            = process_data.sh
arguments             = $(dataset)
output                = output/data.$(ClusterId).$(dataset).out
error                 = error/data.$(ClusterId).$(dataset).err
log                   = log/data.$(ClusterId).log

# Queue with different dataset parameters
queue dataset in (dataset1 dataset2 dataset3)
```

Alternatively, you can read job parameters from a file:
```bash
queue dataset from datasets.txt
```

### Accessing CMSSW in HTCondor Jobs
For CMS analysis jobs using CMSSW, include these commands in your executable script:

```bash
#!/bin/bash
# Setup CMSSW environment
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
cd /path/to/your/CMSSW_X_Y_Z/src
eval `scramv1 runtime -sh`

# Your analysis commands here
cmsRun yourConfig_cfg.py
```

This ensures your job runs with the correct CMSSW environment.  
OWNER   BATCH_NAME       SUBMITTED   DONE   RUN    IDLE  TOTAL JOB_IDS  
bejones CMD: hello.sh  10/3  14:08      _      _      1      _ 70.0  

1 jobs; 0 completed, 0 removed, 1 idle, 0 running, 0 held, 0 suspended
```

You can see the job ID "70.0", which includes the cluster ID (70) and process ID (0).

### Using `condor_wait`

You can monitor job status with `condor_wait`:

```bash
$ condor_wait -status log/hello.70.log
70.0.0 submitted  
70.0.0 executing on host <188.185.180.233:9618?...>  
70.0.0 completed  
All jobs done.
```

## Additional Parameters

## Job Site

To specify a T2 site for the job:

```bash
+DESIRED_Sites = "T2_US_UCSD,T2_US_Caltech,T2_US_MIT"
```

## Using your X509 Proxy

To use your X509 Proxy in a job to, for example, pull a file from another CMS site / global redirector:

```bash
x509userproxy=/tmp/x509up_u31749
use_x509userproxy = True
```

## Universe

HTCondor supports various platforms or architectures using "universes." You can define it in the submit file:

```bash
universe = vanilla
```

`vanilla` is the default, but you can also use others like the `docker` universe.

## Operating System Requirements

The default OS at CERN is AlmaLinux 9. To specify a different OS:

```bash
requirements = (OpSysAndVer =?= "el8")
```

To see available OS versions:

```bash
$ condor_status -compact -af OpSysAndVer | sort | uniq -c
```

### OS Selection via Containers

To manage the OS via containers:

```bash
MY.WantOS = "el9"
```

Available choices: `el7`, `el8`, `el9`.

## CPU Architecture Requirements

To run a job on an ARM worker node (e.g., from an x86_64 node):

```bash
requirements = (Arch =?= "aarch64")
```

## Job Flavours

Job runtime is defined using flavours or by specifying a maximum runtime. The flavours are:

- **espresso**: 20 minutes  
- **microcentury**: 1 hour  
- **longlunch**: 2 hours  
- **workday**: 8 hours  
- **tomorrow**: 1 day  
- **testmatch**: 3 days  
- **nextweek**: 1 week

To set a job flavour in the submit file:

```bash
+JobFlavour = "longlunch"
```

## Resources and Limits

By default, jobs are allocated 1 CPU core, 2GB memory, and 20GB disk space. To request more CPUs:

```bash
RequestCpus = 4
```

This will allocate 4 CPUs, 8GB memory, and 20GB disk space.

## Submitting Multiple Jobs

To submit multiple jobs, use the `queue` directive with an integer value:

```bash
executable = runmore.sh  
input      = input/mydata.$(ProcId)  
arguments  = $(ClusterId) $(ProcId)  
output     = output/hello.$(ClusterId).$(ProcId).out  
error      = error/hello.$(ClusterId).$(ProcId).err  
log        = log/hello.$(ClusterId).log  
queue 150
```

This will submit 150 jobs, each with an incremented `ProcId`.