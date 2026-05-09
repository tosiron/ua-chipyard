# Docker Container and Chipyard Installation

This section explains how to set up Chipyard using a Docker container. Instructions are provided for both Windows and Linux environments.

First build the docker container with dependencies:
- If you have a **Windows** machine, follow the steps in [Docker Container Installation on Windows](#docker-container-installation-on-windows)
- If you have a **Linux** machine, follow the steps in [Docker Container Installation on Linux](#docker-container-installation-on-linux)

When container build is completed, install Chipyard following the steps in [Running Docker and Chipyard Installation](#running-docker-and-chipyard-installation)

### Docker Container Installation on Windows

- If you don't have Docker installed, install it from the following link: [Docker for Windows](https://docs.docker.com/desktop/install/windows-install/)
- Open PowerShell and run the following commands:

```powershell
cd chipyard-project-guide  # Change directory to the repository
docker build -t chipyard:1.13.0 .  # Build docker container (don't forget the comma at the end)
```

### Docker Container Installation on Linux

- If you don't have Docker installed, install it from the following link: [Docker for Linux](https://docs.docker.com/engine/install/)

- Build the docker image by running the following command:

```bash
cd chipyard-project-guide  # Change directory to the repository
docker build -t chipyard:1.13.0 .
docker build --network=host -t chipyard:1.13.0 .
```

### Running Docker and Chipyard Installation

Once installation finishes, run the docker container using the following command (we are not using `--rm` so that our changes are not removed from the container):

```bash
docker run --privileged -it --name chipyard chipyard:1.13.0 /bin/bash
```

The Dockerfile clones the latest release from the chipyard repository during container creation, so we will just build it (takes 1–2 hours depending on your connection speed and resources):

```bash
cd chipyard
./build-setup.sh riscv-tools
```

- You can exit the docker container by running the `exit` command and your work won't be deleted.
- To start docker again run the following command:

```bash
docker start -ai ecex62_chipyard
```

- **(Optional)** You can also save your changes locally to a new container:

```bash
docker commit ecex62_chipyard <new_image_name>:<new_tag>
docker run -it --name <new_container_name> <new_image_name>:<new_tag> /bin/bash
```
