# ECE 462/562 (University of Arizona) - Chipyard Installation Guide and Tutorial

This repository provides the Chipyard/Rocket environment used for
ECE 462/562 Computer Architecture.

(Thanks to Umut for creating the original version of this tutorial!)

## Requirements

Install:

1. Git
2. Docker Desktop: [Docker for Windows](https://docs.docker.com/desktop/setup/install/windows-install/) (requires WSL 2); [Docker for Linux](https://docs.docker.com/engine/install/)

## Setup

Clone this repository:

```bash
git clone https://github.com/tosiron/ua-chipyard.git
cd ua-chipyard
```

Download the course environment:

```bash
docker compose pull
```

Start Chipyard:

```bash
docker compose run --rm chipyard
```

Inside the container, verify installation:

```bash
/workspace/test-install.sh
```

You should see:

```text
Environment: PASS
```

Then continue to:

[Getting Started](/docs/getting-started.md)
