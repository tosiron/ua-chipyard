# Virtual Machine Installation

- If you don't have Oracle VirtualBox installed, install it from the following link: [Oracle VirtualBox](https://www.virtualbox.org/)
- Download the ISO for [Ubuntu 22.04.5 LTS](https://releases.ubuntu.com/22.04/)
- Once installed, start VirtualBox and click **Machine → New**
- Choose any name you prefer and select the downloaded ISO file as the ISO image under **Name and Operating System**
- Set username and password under **Unattended Install**
- Base memory and number of processors depend on your host machine. Try to allocate at least **2 to 4 CPUs** and **8 GB of memory** under **Hardware**
- For storage, it is recommended to provide **at least 50 GB** as Chipyard requires a lot of space after installation under **Hard Disk**
- Wait for VM to boot (may take a couple of minutes). Click **Try or Install Ubuntu** and wait until Linux boots properly. The VM will automatically install Ubuntu.
- Login once installed and pull up a terminal. First add your user to sudoers:

```bash
su -
usermod -aG sudo yourusername
```

- Reboot the machine to apply the changes, then install the necessary packages:

```bash
sudo apt install build-essential dkms vim libguestfs-tools git
```

- Create a workspace folder and install conda:

```bash
mkdir workspace  # Create the workspace
cd workspace
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b  # Install conda
echo 'export PATH="$HOME/miniforge3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc  # Update path so that conda is recognized
conda update -n base --all  # Update conda packages
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
./build-setup.sh riscv-tools --skip-marshal --skip-firesim
```

---

Once installation completes, head over to [USAGE.md](USAGE.md) for the hands-on tutorial.
