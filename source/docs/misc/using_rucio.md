# Managing Data with Rucio

Rucio is the Distributed Data Management system for the CMS experiment. As a user of the UCSD User Analysis Facility (UAF), you will use Rucio primarily to request the replication of CMS datasets to the UCSD Tier-2 site (`T2_US_UCSD`) for local high-performance processing.

While XRootD allows streaming data from remote sites, having frequently accessed datasets replicated locally to UCSD's storage/CEPH system significantly improves job performance and reliability.

## Prerequisites

Before using Rucio, ensure you have:
1.  **A valid CMS Grid Certificate** installed in `~/.globus/`.
2.  **CMS VO Membership** (registered in VOMS).
3.  **A CERN computing account**.

## Environment Setup

The Rucio client is distributed via CVMFS. To set up your environment on the UAF:

1.  **Source the CMS Environment**:
    ```bash
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    ```

2.  **Setup Rucio Client**:
    ```bash
    source /cvmfs/cms.cern.ch/rucio/setup-py3.sh
    ```

3.  **Set Rucio Account (Optional)**:
    If your UAF username differs from your CERN username, export your CERN account name:
    ```bash
    export RUCIO_ACCOUNT="your_cern_username"
    ```

## Authentication

Rucio requires a valid VOMS proxy for authentication. Initialize your proxy before running Rucio commands:

```bash
voms-proxy-init -voms cms -rfc -valid 192:00
```
*Note: The `-valid 192:00` flag creates a proxy valid for 8 days, useful for long-running transfers.*

## Common Operations

### 1. Requesting Data Replication (Creating Rules)

To bring a dataset to UCSD, you create a replication "rule". This tells Rucio to ensure one copy exists at `T2_US_UCSD`.

**Syntax:**
```bash
rucio add-rule <did> <copies> <rse_expression>
```
*   `did`: Data Identifier (CMS dataset name, e.g., `/Dataset/Name/TIER`)
*   `copies`: Number of copies (usually 1)
*   `rse_expression`: Destination site (`T2_US_UCSD` for UCSD)

**Example:**
```bash
rucio add-rule /DyJets/Run2016-v1/MINIAOD 1 T2_US_UCSD
```
*Output will provide a Rule ID which you can use to track status.*

### 2. Monitoring Rules

To check the status of your replication requests:

```bash
# List all rules for your account
rucio list-rules --account $RUCIO_ACCOUNT

# Check details of a specific rule
rucio rule-info <rule_id>
```

Status meanings:
*   `REPLICATING`: Transfer is in progress.
*   `OK`: Dataset is fully available at UCSD.
*   `STUCK`: Transfer encountered errors (contact support if persistent).

### 3. Checking Storage Quotas

To check your available storage quota at UCSD and other sites:

```bash
rucio list-account-limits --account $RUCIO_ACCOUNT --rse T2_US_UCSD
```

If you exceed your quota, you may need to delete old rules to free up space.

### 4. Searching for Datasets

You can search for datasets matching a pattern:

```bash
rucio list-dids cms:/Project/Pattern*
```

## Using the Web Interface

For a more visual experience, you can access the [CMS Rucio WebUI](https://cms-rucio-webui.cern.ch/).
*   Login with your CERN credentials.
*   Use the "Rules" view to request transfers (add rule) to `T2_US_UCSD`.
*   Search for DIDs (Data Identifiers) using the search bar.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `AccountNotFound` | Check `echo $RUCIO_ACCOUNT`. It must match your CERN username. |
| `Missing VOMS extension` | Run `voms-proxy-init -voms cms -rfc` again. |
| `Quota Exceeded` | Delete old rules using `rucio delete-rule <rule_id>`. |

For persistent issues or quota increase requests, please contact `t2support@physics.ucsd.edu`.