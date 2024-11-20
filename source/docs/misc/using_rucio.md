# Using Rucio at a CMS T2 Site

To use the Rucio client at a CMS site, you need to set up the CMS environment and initialize your VOMS proxy. Follow the steps below:

Alternatively you can use the much more user friendly web-ui at [https://cms-rucio-webui.cern.ch](https://cms-rucio-webui.cern.ch)

## Prerequisites

Before you begin, ensure you have the following:

- A valid CERN account.
- A valid grid certificate installed.
- Access to the CMS software environment via CVMFS.


## Setup Instructions

### Step 1: Source the CMS Environment

First, you need to load the CMS and Rucio environments. This can be done by sourcing the `cmsset_default.sh` and `setup-py3.sh` scripts:

```bash
source /cvmfs/cms.cern.ch/cmsset_default.sh
source /cvmfs/cms.cern.ch/rucio/setup-py3.sh
```

### Step 2: (Optional) Setup Rucio account

In case your username on your local machine doesn't match your CERN computing account username, please run
```bash
export RUCIO_ACCOUNT="YOUR_CERN_USERNAME"
```

### Step 3: Initialize VOMS Proxy

Finally, initialize your VOMS proxy with the following command to ensure you have the necessary authentication for CMS operations:
```bash
voms-proxy-init -bits 2048 -voms cms --valid 120:00 -rfc -cert=$HOME/.globus/usercred.p12 -key=$HOME/.globus/usercred.p12
```

This command creates a proxy that is valid for 192 hours (8 days).


## Using Rucio

In Rucio, the location of file replicas on RSEs (Rucio storage elements, i.e. CMS site storage) is controlled via rules. Please take some time to familiarize yourself with the rule concept as introduced in the aforementioned link before continuing. In short, if you want to ensure some data is available at a specific location, make a rule.

### Copying a sample to your site can be achieved by running
```bash
rucio add-rule --ask-approval cms:/CMS/DATA/SET/NAME 1 T2_MY_SITE
```

### Listing your rules
```
rucio list-rules --account $RUCIO_ACCOUNT
```

For more detailed usage and advanced operations, refer to the Rucio Documentation and CMS Data Management Documentation.

## Troubleshooting

### Authentication Issues:
Ensure your grid certificate is valid and properly installed. Check the paths in your environment variables.

### Configuration Errors:
Double-check your configuration for typos and ensure all paths are correct.

### Permission Denied:
Make sure your Rucio account has the necessary permissions for the operations you are attempting.

If you encounter specific issues, refer to the Rucio documentation or contact your t2support@physics.ucsd.edu for further assistance.