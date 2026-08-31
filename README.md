# ECE 462/562 (University of Arizona) - Chipyard Installation Guide and Tutorial

This repository provides an installation guide for [Chipyard](https://github.com/ucb-bar/chipyard) (v1.14.0). Chipyard is an open-source RISC-V SoC design framework that lets you build, simulate, and customize a RocketCore-based design.

## Getting Started

1. **Clone this repository**:

   ```bash
   git clone https://github.com/umutsuluhan/chipyard-guide.git
   cd chipyard-guide
   ```

2. **Install Chipyard** by following [INSTALL_DOCKER.md](INSTALL_DOCKER.md). Docker works on Windows (via WSL 2), Linux, and macOS.

3. **Follow the tutorial** in [USAGE.md](USAGE.md) to verify your install, run default and custom tests, build custom SoC configurations, measure performance, and integrate a ROCC accelerator.

## Repository Contents

- `Dockerfile` — builds the Docker image used by [INSTALL_DOCKER.md](INSTALL_DOCKER.md)
- `INSTALL_DOCKER.md` — installation guide (Docker)
- `USAGE.md` — hands-on Chipyard tutorial (tests, custom configs, performance metrics, ROCC accelerators)
