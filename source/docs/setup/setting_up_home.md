# Setting Up Your UAF Analysis Environment

Your home directory on the UCSD CMS T2 UAF serves as your personal workspace for development, analysis, and data storage. This guide will help you optimize your environment for high-energy physics research.

## Home Directory Organization

Your home directory has a default storage quota. For efficient usage:

```bash
# Check your current disk usage
du -sh $HOME

# Check your quota
quota -s
```

### Recommended Directory Structure

We recommend organizing your home directory with a structure like this:

```
$HOME/
├── analysis/          # Analysis code and projects
│   ├── project1/      # Specific analysis projects
│   └── project2/
├── data/              # Small, local datasets (use /ceph for large data)
├── public_html/       # Web-accessible files
```

You can create this structure with:

```bash
mkdir -p $HOME/{analysis,data,public_html,software,scripts}
```

## Setting Up Web Access with `public_html`

The `public_html` directory enables you to share plots, results, and documentation through a web server running on the UAF machines. This is extremely useful for sharing results with collaborators without emailing large files.

### Creating Your Web Directory

1. **Create the directory** (if not already present):
   ```bash
   mkdir -p $HOME/public_html
   ```

2. **Set proper permissions**:
   For the web server to read your files, your home directory and `public_html` must be executable ("searchable") by others.
   ```bash
   chmod 711 $HOME
   chmod 755 $HOME/public_html
   ```
   *Note: `711` on `$HOME` allows the web server to access known subdirectories without letting other users list your files.*

3. **Add content to your web space**:
   ```bash
   # Example: Copy images for sharing
   cp my_results.png $HOME/public_html/
   chmod 644 $HOME/public_html/my_results.png
   
   # Create a simple HTML page
   cat > $HOME/public_html/index.html << EOF
   <!DOCTYPE html>
   <html>
   <head><title>My CMS Analysis</title></head>
   <body>
     <h1>My Analysis Results</h1>
     <img src="my_results.png" alt="Analysis Results">
   </body>
   </html>
   EOF
   chmod 644 $HOME/public_html/index.html
   ```

- **Accessing your web content**:
   Your website is automatically available at:
   ```
   http://uaf-2.t2.ucsd.edu/~username/
   ```
   Replace `username` with your UAF username and `uaf-2` with whichever UAF machine you're using.

## Environment Configuration

### Setting Up Your `.bashrc`

The `.bashrc` file in your home directory controls your shell environment. Here's a recommended configuration for CMS analysis:

```bash
# Create or edit your .bashrc
vim $HOME/.bashrc
```

```bash
# User specific aliases and functions
# Source CMS Environment
source /cvmfs/cms.cern.ch/cmsset_default.sh

# Set useful aliases
alias llt='ls -lrth'
alias condor_q_me='condor_q $USER'
alias cdcms='cd /ceph/cms/store/user/$USER/'

# Add custom bin directory to PATH
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Set a more informative prompt
export PS1='\[\e[1;32m\]\u@\h \[\e[1;34m\]\w \[\e[1;31m\]$ \[\e[0m\]'

# Set default editor
export EDITOR=vim

# Proxy management
alias gridproxy='voms-proxy-init --voms cms --valid 192:00'
```

Apply changes by logging out and back in, or running:
```bash
source $HOME/.bashrc
```

### Managing Large Files and Storage

For efficient home directory management:

1. **Avoid storing large datasets** in your home directory. Use `/ceph/cms/store/user/username/` instead.

2. **Use symbolic links** to reference data on CEPH:
   ```bash
   ln -s /ceph/cms/store/user/$USER/my_dataset $HOME/data/my_dataset
   ```

3. **Clean up temporary files** regularly:
   ```bash
   # Find large files (>100MB)
   find $HOME -type f -size +100M | sort -k 5 -nr

   # Find old files (not accessed in 90 days)
   find $HOME -type f -atime +90 | grep -v '.bash_history'
   ```

4. **Use compression** for log files and text data:
   ```bash
   # Compress a directory of logs
   tar -czvf logs_archive.tar.gz logs/
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