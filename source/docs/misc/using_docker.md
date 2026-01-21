# Container Computing with Podman (Docker) on UAF Clusters

![Docker Comic](../assets/docker.jpg)

## Introduction to Containers at UCSD CMS T2

Containers provide an elegant solution for running applications with complex dependencies in an isolated environment. They allow you to:

- Create reproducible analysis environments with precise dependency versions
- Run software that requires different operating systems or libraries
- Share your analysis setup easily with collaborators
- Isolate development environments from production workflows

At the UCSD CMS T2 facility, we use **Podman** - a powerful, secure container engine that provides full Docker compatibility without requiring root access. For user convenience, the `docker` command on all UAF machines is aliased to `podman`, allowing you to use familiar Docker commands without modification.

This guide will walk you through the steps to use Docker (Podman) on UAF-2, 3, and 4 machines.

## Setting Up Your Container Environment

By default, Podman stores container images in your home directory (`$HOME/.local/share/containers/storage`). Since home directories are mounted over the network (NFS), this can lead to slow performance and disk quota issues when working with large images.

**We strongly recommend redirecting your container storage to the fast local NVMe storage available on each UAF node.**

### Step 1: Create Local Storage Directories

Since the fast local storage (`/data/userdata`) is unique to each machine, you must run these commands on **each UAF machine** you plan to use for containers.

1.  **Create your directory on the local NVMe drive**:
    ```bash
    mkdir -p /data/userdata/${USER}/docker
    ```

### Step 2: Link Container Storage to NVMe

1.  **Remove the default (networked) storage directory** if it exists:
    ```bash
    rm -rf $HOME/.local/share/containers/storage
    ```

2.  **Create the parent directory structure**:
    ```bash
    mkdir -p $HOME/.local/share/containers/
    ```

3.  **Create a symbolic link** pointing to the fast local storage:
    ```bash
    ln -s /data/userdata/${USER}/docker $HOME/.local/share/containers/storage
    ```

4.  **Verify the setup**:
    ```bash
    ls -l $HOME/.local/share/containers
    ```
    *Output should show `storage -> /data/userdata/your_username/docker`.*

## Basic Container Operations

Now that your local storage is optimized, you can use standard Docker commands.

### Running Containers

- **Basic interactive usage**:
  ```bash
  docker run -it ubuntu:latest bash
  ```

- **Mounting your data** (Crucial for accessing files):
  You need to explicitly mount directories to see your files inside the container.
  ```bash
  docker run -it -v /ceph/cms/store/user/${USER}:/data centos:7
  ```
  *This maps your CEPH user directory to `/data` inside the container.*

- **Running a specific GPU-enabled container**:
  ```bash
  docker run -it --gpus all tensorflow/tensorflow:latest-gpu
  ```

- **Running Jupyter Notebooks**:
  ```bash
  docker run -d --name my_notebook -p 8888:8888 -v $PWD:/home/jovyan/work jupyter/scipy-notebook
  ```

### Managing Containers and Images

- **List running containers**:
  ```bash
  docker ps
  ```

- **List all containers (including stopped ones)**:
  ```bash
  docker ps -a
  ```

- **List downloaded images**:
  ```bash
  docker images
  ```

- **Clean up stopped containers** (frees up space):
  ```bash
  docker container prune
  ```

## Best Practices

1.  **Always use volumes (`-v`)**: Containers are ephemeral. Any data written inside the container is lost when it is deleted. Always write your results to a mounted volume (like `/data` or mapped home directory).
2.  **Clean up regularly**: Images can be large. Run `docker system prune` occasionally to remove unused data.
3.  **Use specific tags**: Instead of `latest`, use specific version tags (e.g., `python:3.9-slim`) for reproducibility.
  $ docker rmi image_id
  ```

## CMS-Specific Container Use Cases

### CMSSW in Containers

The CMS Software (CMSSW) can be run within containers, which is particularly useful for testing across different releases:

```bash
$ docker run -it --name cmssw -v /ceph/cms/store/user/username:/work cms:rhel7
```

Inside the container, you can set up CMSSW:
```bash
source /cvmfs/cms.cern.ch/cmsset_default.sh
scramv1 project CMSSW CMSSW_12_4_0
cd CMSSW_12_4_0/src
eval `scramv1 runtime -sh`
```

### Custom Analysis Environments

You can create your own custom containers with a `Dockerfile`:

```dockerfile
FROM python:3.9

# Install HEP tools
RUN pip install uproot awkward vector matplotlib numpy scipy

# Install CMS-specific packages
RUN pip install correctionlib

WORKDIR /analysis
```

Build your custom image:
```bash
$ docker build -t my-hep-analysis .
```

Run your analysis:
```bash
$ docker run -it -v /ceph/cms/store/user/username/data:/analysis/data my-hep-analysis
```

- To list all running containers, use the `docker ps` command:
  ```
  $ docker ps
  ```

- To stop a running container, use the `docker stop` command followed by the container ID or name:
  ```
  $ docker stop <container_id>
  ```

- To remove a container, use the `docker rm` command followed by the container ID or name:
  ```
  $ docker rm <container_id>
  ```

- To pull an image from a registry, use the `docker pull` command followed by the image name:
  ```
  $ docker pull nginx:latest
  ```

## Advanced Usage

Podman provides many advanced features for managing containers and images. Here are a few examples:

- To create a new container, use the `docker create` command followed by the image name:
  ```
  $ docker create nginx:latest
  ```

- To start a stopped container, use the `docker start` command followed by the container ID or name:
  ```
  $ docker start <container_id>
  ```

- To inspect a container, use the `docker inspect` command followed by the container ID or name:
  ```
  $ docker inspect <container_id>
  ```

- To build a new image from a Dockerfile, use the `docker build` command followed by the path to the Dockerfile:
  ```
  $ docker build -t myimage:latest .
  ```

- To push an image to a container registry, use the `docker push` command
  ```
  $ docker push username/myimage:tag
  ```

With Docker (Podman), you can easily manage containers and images on UAF-2,3, and 4 machines. This guide covered the basics of using Podman, but there are many more features and options available. Refer to the official Podman documentation for more information and explore the possibilities of containerization with Podman.