# Requesting an Account at UCSD CMS T2

## Account Request Procedure

### Step 1: Prepare Required Information

Before submitting your request, please prepare the following information:

| Information | Description |
|-------------|-------------|
| **Username** | Your preferred username (ideally your CMS username if you have one) |
| **SSH Public Key** | Your public key file content (see [key generation instructions](#generating-ssh-keys)) |
| **Supervisor/PI** | Name of your research supervisor or Principal Investigator |
| **CERN DN** | Your CERN Distinguished Name if available<br>Format: `/DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=username/CN=1111111/CN=Real Name` |

### Step 2: Optional Information

You may also include these optional details:

* **Mailing List Subscription**: Specify if you want to receive site announcements via the cmst2 user mailing list
* **Special Requirements**: Any specific computational or storage needs for your research

### Step 3: Submit Your Request

Send an email to the support team with the subject line "T2 Account Request - [Your Name]":

* **Email Address**: [`t2support@physics.ucsd.edu`](mailto:t2support@physics.ucsd.edu)
* **CC**: Include your research supervisor or PI in the CC field
* **Email Body**: Include all the prepared information in a clear format

### Step 4: Account Activation

Once your request is processed:

* You will receive a confirmation email with access instructions
* Typical processing time is 1-2 business days
* For urgent requests, please indicate in your email subject line

## Generating SSH Keys

SSH key authentication is required for secure access to the UCSD CMS T2 computing resources. We recommend using the modern Ed25519 algorithm for better security, though RSA (4096+ bits) is also accepted.

### Mac/Linux: Ed25519 (Recommended)

Run the following command in your terminal to generate a secure Ed25519 key pair:

```bash
ssh-keygen -t ed25519 -a 100
```

*   **Key Location**: Press Enter to accept the default (`~/.ssh/id_ed25519`).
*   **Passphrase**: **Strongly recommended.** This adds a critical layer of security; without it, anyone with your private key has full access to your account.

### Windows: SSH Key Generation Options

#### Option 1: Using Windows Terminal or PowerShell (Windows 10/11)

Modern Windows systems include OpenSSH. Run the same command in specific shells:

```powershell
ssh-keygen -t ed25519 -a 100
```

Your public key will be saved to `C:\Users\YourUsername\.ssh\id_ed25519.pub`.

#### Option 2: Using PuTTY Key Generator

For older Windows systems or those who prefer a graphical interface:

1. Download and install PuTTY from the [official website](https://www.chiark.greenend.org.uk/~sgtatham/putty/)
2. Launch PuTTYgen (PuTTY Key Generator)
3. Under "Parameters":
   * Select "EdDSA" as the key type
   * Choose "Ed25519" as the curve
4. Click "Generate" and move your mouse randomly in the blank area to generate randomness
5. Enter a strong passphrase in the "Key passphrase" fields
6. Click "Save public key" and "Save private key" to store your keys
7. Copy the text from the "Public key for pasting" field to submit in your account request

#### Option 3: Using Windows Subsystem for Linux (WSL)

If you're using WSL:

1. Open your WSL terminal
2. Follow the Linux/Mac instructions above
3. Your key will be located in your WSL user's ~/.ssh directory

It is also recommended that you use the pageant service on Windows to allow you to load your key once on Windows startup so you will not have to enter your passphrase every time you need to login to the UAF.

### RSA

1. Open a terminal or command prompt
2. Run the following command to generate an RSA key pair:

   ```bash
   ssh-keygen -t rsa -b 4096
   ```

3. You will be prompted to enter a file name to save the key pair. Press Enter to accept the default location (`~/.ssh/id_rsa`) or specify a different path
4. You will also be prompted to enter a passphrase. It is **recommended** to use a **strong passphrase** to protect your private key
5. The key pair will be generated and saved in the specified location

### Why ed25519 is Better

ed25519 is a modern elliptic curve algorithm that offers several advantages over RSA:

* **Security**: ed25519 provides a high level of security with shorter key lengths compared to RSA. It is resistant to various cryptographic attacks
* **Performance**: ed25519 is faster than RSA in terms of key generation, signing, and verification. This makes it more efficient for cryptographic operations
* **Compactness**: ed25519 keys are shorter than RSA keys, resulting in smaller storage requirements and faster data transmission

Please note that the instructions provided here are for generating SSH keys on a Unix-like system. If you are using a different operating system, refer to the documentation or consult the relevant resources for instructions specific to your platform.