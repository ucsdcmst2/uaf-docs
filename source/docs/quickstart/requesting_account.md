# Requesting an Account

To request an account, please email t2support (with your supervisor in cc) at `t2support@physics.ucsd.edu` with the following information:

>   - Your preferred username (This should be your CMS username if available)
>   - Your SSH public key
>   - Your CERN DN if available ie /DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=username/CN=1111111/CN=Real Name
>   - Please note if you would like docker access please use podman, which is an unprivileged version of docker from RedHat Inc. 

## Generating SSH Keys

To generate SSH keys, you can use either the rsa or ed25519 algorithm. Here are the instructions for both Mac and Unix:
### Mac/Linux ed25519

1. Open a terminal or command prompt.
2. Run the following command to generate an ed25519 key pair:
   ```
   ssh-keygen -t ed25519 -a 100
   ```
3. You will be prompted to enter a file name to save the key pair. Press Enter to accept the default location (`~/.ssh/id_ed25519`) or specify a different path.
4. Choose a passphrase to encrypt the key file. This will be requested when you log in to the UAF, though this can be done once by using
  > * Mac OS will automatically put this in your keychain
  > * Ubuntu: ```sudo apt-get install keychain```
  > * CentOS/Almalinux/Rocky: ```yum install keychain```
  > * More Keychain tool instructions available from [https://www.funtoo.org/Funtoo:Keychain](https://www.funtoo.org/Funtoo:Keychain)
5.  The key pair will be generated and saved in the specified location.

### Windows ed25519

1. Install the tool putty from [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty)
2. Run the tool puttygen (you can use the search in Windows to find the tool)
3. Select EdDSA from the radio options
4. Click Generate and follow the instructions for randomness
5. Enter a passphrase into the key Passphrase box and confirm it
6. Save the public and private keys
7. Email the publick key to the t2support@physics.ucsd.edu email address

It is also recommended that you use the pageant service on windows to allow you to load your key once on windows startup so you will not have to enter your passphrase every time you need to login to the UAF. 


### RSA

1. Open a terminal or command prompt.
2. Run the following command to generate an RSA key pair:
   ```
   ssh-keygen -t rsa -b 4096
   ```
3. You will be prompted to enter a file name to save the key pair. Press Enter to accept the default location (`~/.ssh/id_rsa`) or specify a different path.
4. You will also be prompted to enter a passphrase. It is **recommended** to use a **strong passphrase** to protect your private key.
5. The key pair will be generated and saved in the specified location.

### Why ed25519 is Better

ed25519 is a modern elliptic curve algorithm that offers several advantages over RSA:

- **Security**: ed25519 provides a high level of security with shorter key lengths compared to RSA. It is resistant to various cryptographic attacks.
- **Performance**: ed25519 is faster than RSA in terms of key generation, signing, and verification. This makes it more efficient for cryptographic operations.
- **Compactness**: ed25519 keys are shorter than RSA keys, resulting in smaller storage requirements and faster data transmission.

Please note that the instructions provided here are for generating SSH keys on a Unix-like system. If you are using a different operating system, refer to the documentation or consult the relevant resources for instructions specific to your platform.