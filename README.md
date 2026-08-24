# ECE 462/562 (University of Arizona) - Chipyard Installation Guide and Tutorial

This repository provides an installation guide for [Chipyard](https://github.com/ucb-bar/chipyard) (v1.14.0). Chipyard is an open-source RISC-V SoC design framework that lets you build, simulate, and customize a RocketCore-based design.

## Getting Started

1. **Install Chipyard** using one of the guides below:

   | Option | Guide | Notes |
   |--------|-------|-------|
   | Docker (Windows or Linux) | [INSTALL_DOCKER.md](INSTALL_DOCKER.md) | Recommended |
   | Native Linux | [INSTALL_LINUX.md](INSTALL_LINUX.md) | For experienced Linux users |
   | Virtual Machine (VirtualBox + Ubuntu) | [INSTALL_VM.md](INSTALL_VM.md) | For Windows/macOS users without Docker |

2. **Follow the tutorial** in [USAGE.md](USAGE.md) to verify your install, run default and custom tests, build custom SoC configurations, measure performance, and integrate a ROCC accelerator.

## Repository Contents

- `chipyard/` — Chipyard v1.14.0, included as a git submodule
- `Dockerfile` — builds the Docker image used by [INSTALL_DOCKER.md](INSTALL_DOCKER.md)
- `INSTALL_DOCKER.md` / `INSTALL_LINUX.md` / `INSTALL_VM.md` — installation guides, one per platform
- `USAGE.md` — hands-on Chipyard tutorial (tests, custom configs, performance metrics, ROCC accelerators)
