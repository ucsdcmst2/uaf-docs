# Using the HTCondor Batch Submission System

This guide is taken from the [CERN batch submission documentation](https://batchdocs.web.cern.ch/local/index.html).

## Prerequisites

Login to a machine that is configured to submit jobs to the HTCondor batch system. That means logging into one of the UAF machines or CERN lxplus.

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

- **executable**: The script or command you want HTCondor to run.
- **arguments**: Any arguments passed to the command. We're using interpolated values here. `ClusterId` will normally be unique to each submit file. `ProcId` is incremented by one for each job in each cluster.
- **output**: Specifies where the `STDOUT` of the command or script should be written. HTCondor won’t create the directory, so ensure it exists.
- **error**: Specifies where the `STDERR` of the command or script is written.
- **log**: Contains HTCondor’s logs for your jobs (e.g., submission times, execution host, etc.).
- **queue**: Schedules the job. It becomes important when scheduling multiple jobs using interpolation.

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

-- Schedd: bigbird01.cern.ch : <128.142.194.108:9618?...  
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