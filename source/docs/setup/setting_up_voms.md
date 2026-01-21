# VOMS Proxy Management

A VOMS (Virtual Organization Membership Service) proxy is your digital identification card for the Grid. It proves you are a member of the CMS collaboration and grants you access to global computing resources, XRootD storage, and Rucio data management.

## 1. Creating a Proxy

### Prerequisites
*   A valid grid certificate (in `.p12` format).
*   Your certificate installed on the UAF (in `~/.globus/`).
*   Registration in the CMS VO.

### Installing Your Certificate
If you haven't installed your certificate yet:
1.  **Copy** your `.p12` file to the UAF:
    ```bash
    scp myCertificate.p12 username@uaf-2.t2.ucsd.edu:~/.globus/usercred.p12
    ```
2.  **Use** the certificate file directly to generate proxies.

### Generating a Proxy
Run the following command to generate a standard proxy:

```bash
voms-proxy-init -voms cms -rfc -valid 192:00
```

*   `-voms cms`: Adds CMS membership extensions.
*   `-rfc`: Creates an RFC-compliant proxy (required for modern Grid tools like HTCondor).
*   `-valid 192:00`: Sets validity to 8 days (192 hours), ideal for long-running workflows.

### Verifying Your Proxy
To check if your proxy is active and valid:

```bash
voms-proxy-info -all
```

**What to look for:**
*   **Timeleft**: Should be > 0.
*   **Attribute**: `/cms/Role=NULL` (or specific role if requested).
*   **Type**: RFC 3820 compliant.

## 2. Auto-Renewing Proxies

Jobs submitted to HTCondor require a valid proxy for their entire duration. If your proxy expires while jobs are idle or running, they may fail or be held. To prevent this, we recommend setting up an automatic renewal script.

### Step 1: Create Renewal Script

Create a script at `$HOME/cron/renewProxy.sh`:

```bash
#!/bin/bash
# Initialize proxy with long validity (8 days)
voms-proxy-init -q -voms cms -rfc -valid 192:00 -cert $HOME/.globus/usercred.p12 -key $HOME/.globus/usercred.p12
```

Make it executable:
```bash
chmod +x $HOME/cron/renewProxy.sh
```

### Step 2: Configure Crontab

Add a cron job to run this script daily.

1.  Open your crontab:
    ```bash
    crontab -e
    ```

2.  Add the following line to run every day at 3:55 PM (or any time you prefer):
    ```cron
    55 15 * * * $HOME/cron/renewProxy.sh > /dev/null 2>&1
    ```

3.  Save and exit.

**Important:** Cron jobs are machine-specific. If you submit jobs from `uaf-2` and `uaf-3`, you must set up this cron job on **both** machines.

## 3. Advanced: Converting .p12 to PEM

Most modern tools accept the `.p12` file directly, but some legacy tools may require separate PEM files (`usercert.pem` and `userkey.pem`).

**Convert to PEM format:**

1.  **Extract Certificate** (Public Key):
    ```bash
    openssl pkcs12 -in usercred.p12 -clcerts -nokeys -out ~/.globus/usercert.pem
    chmod 600 ~/.globus/usercert.pem
    ```

2.  **Extract Private Key**:
    ```bash
    openssl pkcs12 -in usercred.p12 -nocerts -out ~/.globus/userkey.pem
    chmod 400 ~/.globus/userkey.pem
    ```
    *Note: `chmod 400` ensures the private key is read-only and secure.*
