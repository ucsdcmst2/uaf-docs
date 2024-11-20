# Setting up your UAF Home Directory

## 1. **Setting up a `public_html` Directory for Serving Files/Images via a Web Server**

The `public_html` directory is used to host files and images that you want to make publicly accessible through a web server. This directory should be located in your home directory, and the Apache web server which runs on all machines can serve files from here.

#### Steps:
- **Create the `public_html` directory**:
   Run the following command to create the directory in your home directory:
   ```bash
   mkdir $HOME/public_html
   ```
   This directory will serve as the root folder for any files you want to share via the web.

- **Set correct permissions**:
   You need to make sure the `public_html` directory has the right permissions so that the web server can read and serve files from it. Use these commands to set the appropriate permissions:
   ```bash
   chmod 755 $HOME
   chmod 755 $HOME/public_html
   ```
   These commands ensure that the directory and its contents are accessible by others but only you can modify the files.

- **Place your files in `public_html`**:
   After creating the directory, place any files (e.g., HTML, CSS, images) you wish to serve inside this folder. For example, to make an image publicly accessible:
   ```bash
   cp image.png $HOME/public_html/
   chmod 755 $HOME/public_html/image.png
   ```

- **Accessing the files**:
   You can access files via a URL such as:
   ```
   http://uaf-2.t2.ucsd.edu/~yourusername/image.png
   ```

Note: Just like your home directory, the public_html directory is shared across the UAFs

## 2. **Setting up a Backup Directory**

Creating a backup directory is a good practice to ensure that important files can be restored in case of data loss or accidental deletion.

#### Steps:
- **Create the backup directory**:
   Use the following command to create the directory:
   ```bash
   mkdir $HOME/backup
   ```

- **Copy files to the backup directory**:
   To back up a file or directory, use the `cp` command to copy it to your backup folder. For example:
   ```bash
   cp -r $HOME/important_files/ $HOME/backup/
   ```
   This command copies the `important_files` folder (and all its contents) into the `backup` directory.

- **Automate backups (optional)**:
   You can automate the backup process by using cron jobs or a simple shell script. For instance, you can add a cron job to run daily backups:
   1. Open the crontab editor:
      ```bash
      crontab -e
      ```
   2. Add the following line to run a backup every day at midnight:
      ```bash
      0 0 * * * cp -r $HOME/important_files/ $HOME/backup/
      ```

## 3. **Setting Up Miniforge for Linux**

Miniforge is a minimal installer for Conda, tailored for installing and managing packages in Python and other languages.

#### Steps:
- **Download Miniforge**:
   Visit the official Miniforge GitHub page and download the appropriate installer for your Linux distribution:
   - For most modern 64-bit Linux distributions, use the following command:
     ```bash
     wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
     ```

- **Install Miniforge**:
   After downloading the installer, run the following commands to install it:
   1. Make the installer executable:
      ```bash
      chmod +x Miniforge3-Linux-x86_64.sh
      ```
   2. Run the installer:
      ```bash
      ./Miniforge3-Linux-x86_64.sh
      ```
   3. Follow the prompts and accept the license agreement.
   4. After the installation completes, restart your terminal or run the following command to activate Miniforge:
      ```bash
      source $HOME/miniforge3/bin/activate
      ```

- **Test the installation**:
   Ensure that Miniforge is installed correctly by checking the Conda version:
   ```bash
   conda --version
   ```

- **Create an environment (optional)**:
   You can now create a new environment using Conda:
   ```bash
   conda create --name myenv python=3.9
   ```
   Activate the environment with:
   ```bash
   conda activate myenv
   ```