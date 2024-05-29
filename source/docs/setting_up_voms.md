# Setting up VOMS

## Create your PEM pair from the .p12 certificate issued by CERN
To use your grid certificate, you need to convert it to PEM format key pair in 2 separate files: one for the key itself, and one for the certificate.

**Convert to PEM Keypair**

Copy the certificate to a file named myCert.p12 to the computer where you will run voms-proxy-init. If you downloaded it locally, you can achieve this using,
```
scp $PATH_TO_P12 USERNAME@uaf-2.t2.ucsd.edu:~/myCert.p12
```
Extract your certificate (which contains the public key) and the private key:
Extract the certificate:
```
openssl pkcs12 -in myCert.p12 -clcerts -nokeys -out $HOME/.globus /usercert.pem
```
Extract the encrypted private key:
```
openssl pkcs12 -in myCert.p12 -nocerts -out $HOME/.globus/userkey.pem 
```
You must set the permissions on your userkey.pem file to read/write only by the owner, otherwise voms-proxy-init will not use it:
```
chmod 600 $HOME/.globus/userkey.pem
chmod 600 $HOME/.globus/usercert.pem
```
After doing this, either delete myCert.p12 or change the permissions to read/write only by the owner so other users on the machine can't impersonate you.

## Creating an X509 proxy and auto-renewing it
To do this, you need a valid grid certificate.
On the UAF at UCSD:
```
voms-proxy-init -bits 2048 -voms cms --valid 120:00 -rfc -cert=$HOME/.globus/usercert.pem -key=$HOME/.globus/userkey.pem
```
Check that your proxy is valid
```
voms-proxy-info -all
```
You should see two sections separated by "=== VO cms extension information ===". Both sections should have a non-zero value for the "timeleft" field. Also, under "type" it should say "RFC compliant proxy".

The following script can be used as a cronjob to auto-renew your X509 proxy,
copy the line we executed earlier into a script called auto-renew.sh
```
#!/bin/sh
voms-proxy-init -bits 2048 -voms cms --valid 120:00 -rfc -cert=$HOME/.globus/usercert.pem -key=$HOME/.globus/userkey.pem
```
Make the script executable
```
chmod +x auto-renew.sh
```

Test the script and check that in both sections "timeleft" is approximately 120 hours.
Now create a cron job which renews the proxy once per day. Open crontab with
```
crontab -e
```
This opens the vi editor. If you don't know how to use it, good luck 🫡 you are now locked in here forever. Alternatively, save and exit the file by 1) esc 2) :wq
If you prefer to use an alternate editor in the terminal, you can do so by for example,
```
export EDITOR=emacs $ crontab -e
```
this would use emacs instead of vi.
If you export EDITOR=emacs in your bashrc or bash_profile, you'll never have to deal with vi again.

Once the crontab is opened, you need to add the following line. In the place of \${USER} below, please actually type out your username. cron won't recognize the environment variable \${USER}. 
```
55 15 * * * /home/users/${USER}/cron/renewProxy.sh >/dev/null 2>&1
```
Hit return (cron requires a new line following the last listed command) and then save.
Since cron jobs are unique to each UAF machine, and your voms proxy gets stored on /tmp/, you will need to make a separate cron job for each UAF machine you plan to use to submit grid jobs. Just ssh into each UAF machine you want to use, open cron tab, and copy the above line. Since the same /home directory mounts on each UAF, your various cron jobs will use the same script to renew their respective proxies. Remember to Live Long and Proxy.