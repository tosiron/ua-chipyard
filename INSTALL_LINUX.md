# Native Linux Installation

> **Note:** It is still recommended to use Docker within Linux to prevent package conflicts or potential issues if you are not experienced with Linux. See [INSTALL_DOCKER.md](INSTALL_DOCKER.md) instead if you'd prefer that route.

- Install conda if it is not installed:

```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b
```

- Add executable binary path to bashrc file (eliminates the need for repetitive `export PATH` commands):

```bash
vim ~/.bashrc  # Use your favorite text editor to pull up bashrc
```

- Add the following line to the end of the file:

```bash
export PATH="$HOME/miniforge3/bin:$PATH"
```

- Save your changes to the file and source your bashrc:

```bash
source ~/.bashrc
```

- Update conda installation with latest packages to eliminate potential conflicts during Chipyard build (official recommendation from Chipyard):

```bash
conda update -n base --all
```

- Clone this repository:

```bash
git clone https://github.com/umutsuluhan/chipyard-guide.git
cd chipyard-guide
```

- Initialize the Chipyard submodule included in the repository:

```bash
git submodule update --init --recursive
```

- Install Chipyard using the submodule (no separate `git clone` of Chipyard needed):

```bash
cd chipyard
./build-setup.sh riscv-tools  --skip-marshal --skip-firesim
```

---

Once installation completes, head over to [USAGE.md](USAGE.md) for the hands-on tutorial.
