# Docker Container and Chipyard Installation

This document explains the setup for Chipyard using a Docker container. Instructions are provided for both Windows and Linux environments.
 
### Docker and Image Installation on Windows/Linux

- If you don't have Docker installed:
    - Install it from the following link for Windows: [Docker for Windows](https://docs.docker.com/desktop/install/windows-install/)
        - On Windows, Docker requires WSL 2 (Windows Subsystem for Linux) to be installed and enabled.
    - Install it from the following link for Linux: [Docker for Linux](https://docs.docker.com/engine/install/)

- Pull the docker image by running the following command:

```bash
docker pull umutsuluhan/ecex62-chipyard:1.14.0
```

### Running Docker

Once installation finishes, run the docker container using the following command (we are not using `--rm` so that our changes are not removed from the container):

```bash
docker run --privileged -it --name ecex62_chipyard umutsuluhan/ecex62-chipyard:1.14.0 /bin/bash
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

---

Once installation completes, head over to [USAGE.md](USAGE.md) for the hands-on tutorial.
