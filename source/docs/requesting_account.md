# Requesting an Account

To request an account, please email t2support (with your supervisor in cc) at `t2support@physics.ucsd.edu` with the following information:
   - Your preferred username
   - Your SSH public key

## Generating SSH Keys

To generate SSH keys, you can use either the rsa or ed25519 algorithm. Here are the instructions for both:
### ed25519

1. Open a terminal or command prompt.
2. Run the following command to generate an ed25519 key pair:
   ```
   ssh-keygen -t ed25519 -a 100
   ```
3. You will be prompted to enter a file name to save the key pair. Press Enter to accept the default location (`~/.ssh/id_ed25519`) or specify a different path.
4. You can optionally enter a passphrase for added security.
5. The key pair will be generated and saved in the specified location.

### RSA

1. Open a terminal or command prompt.
2. Run the following command to generate an RSA key pair:
   ```
   ssh-keygen -t rsa -b 4096
   ```
3. You will be prompted to enter a file name to save the key pair. Press Enter to accept the default location (`~/.ssh/id_rsa`) or specify a different path.
4. You will also be prompted to enter a passphrase. It is recommended to use a strong passphrase to protect your private key.
5. The key pair will be generated and saved in the specified location.

### Why ed25519 is Better

ed25519 is a modern elliptic curve algorithm that offers several advantages over RSA:

- **Security**: ed25519 provides a high level of security with shorter key lengths compared to RSA. It is resistant to various cryptographic attacks.
- **Performance**: ed25519 is faster than RSA in terms of key generation, signing, and verification. This makes it more efficient for cryptographic operations.
- **Compactness**: ed25519 keys are shorter than RSA keys, resulting in smaller storage requirements and faster data transmission.

Please note that the instructions provided here are for generating SSH keys on a Unix-like system. If you are using a different operating system, refer to the documentation or consult the relevant resources for instructions specific to your platform.

If you have any further questions or need assistance, please feel free to reach out to t2support at t2support@physics.ucsd.edu