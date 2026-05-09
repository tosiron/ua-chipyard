# ECE 462/562 - Chipyard Installation Guide and Tutorial

This document contains two sections:
- The first section provides installation guides for Chipyard: **Chipyard Installation Instructions**
- The second section introduces the Chipyard framework and includes basic tutorials: **Chipyard Guide**

---

# Chipyard Installation Instructions

Select one of the three options below and follow the corresponding instructions:

- **Option 1:** Docker on Windows or Linux → [Docker Container and Chipyard Installation](#docker-container-and-chipyard-installation)
- **Option 2:** Native Linux Installation → [Native Linux Installation](#native-linux-installation)
- **Option 3:** Virtual Machine Installation → [Virtual Machine Installation](#virtual-machine-installation)

## Native Linux Installation

> **Note:** It is still recommended to use Docker within Linux to prevent package conflicts or potential issues if you are not experienced with Linux.

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

- Clone chipyard and install:

```bash
git clone --branch 1.13.0 https://github.com/ucb-bar/chipyard.git
cd chipyard/
./build-setup.sh riscv-tools
```

---

## Virtual Machine Installation

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

- Create a workspace folder and install Chipyard:

```bash
mkdir workspace  # Create the workspace
cd workspace
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b  # Install conda
vim ~/.bashrc
export PATH="$HOME/miniforge3/bin:$PATH"
source ~/.bashrc  # Update path so that conda is recognized
conda update -n base --all  # Update conda packages
git clone --branch 1.13.0 https://github.com/ucb-bar/chipyard.git
cd chipyard/
./build-setup.sh riscv-tools  # Install chipyard
```

---

# Chipyard Guide

This part of the installation guide provides simple hands-on tutorials:

- [Initial Installation Test](#initial-installation-test)
- [Running Default and Custom Tests](#running-default-and-custom-tests)
- [Custom Design Development](#custom-design-development)
- [Performance Metrics](#performance-metrics)

> **Docker users:** Don't forget to start the container and change directory to the chipyard folder:
> ```bash
> docker start -ai ecex62_chipyard
> cd chipyard
> ```

---

## Initial Installation Test

Test if Chipyard is correctly installed by running the following:

```bash
source env.sh  # Chipyard environment setup script,
               # should be sourced every time
cd sims/verilator
make  # Builds the simplest design and test
./simulator-chipyard.harness-RocketConfig $RISCV/riscv64-unknown-elf/share/riscv-tests/isa/rv64ui-p-simple
```

You should see the following output:

```
[UART] UART0 is here (stdin/stdout).
- /workspace/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/gen-collateral/TestDriver.v:158: Verilog $finish
```

The `sims/verilator` folder contains a Makefile that automatically generates the RTL for the given config and a simulation binary that can run various tests.

---

## Running Default and Custom Tests

Chipyard provides an extensive set of tests for validating your design. They are located under the `tests/` folder. To build them:

```bash
cd tests
mkdir build && cd build
cmake ..
make
```

This process generates `.riscv` files under the `tests/` folder. For example, test `hello.riscv` with the following instructions:

```bash
cd sims/verilator
make  # If you already built the binary in the initial test, you can skip this line
./simulator-chipyard.harness-RocketConfig ../../tests/hello.riscv
```

You should see the following output:

```
[UART] UART0 is here (stdin/stdout).
Hello world from core 0, a rocket
- /workspace/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/gen-collateral/TestDriver.v:158: Verilog $finish
```

### Adding a Custom Test

Create a file named `ecex62.c` under `tests/`:

```bash
touch ecex62.c
```

Copy the following code to the file (you can use `vim` to copy-paste if you are on Docker):

```c
#include <stdio.h>
#include <riscv-pk/encoding.h>
#include <stdint.h>

int main(void) {
    printf("Welcome to ECE462/562\n");
    uint64_t a = 1;
    uint64_t b = 2;
    uint64_t c = a + b;
    printf("The results of addition is: %d\n", c);
    return 0;
}
```

Update `CMakeLists.txt` in the `tests/` folder to add executables and dump files:

```cmake
add_executable(ecex62 ecex62.c)  # Insert this command at line 90
add_dump_target(ecex62)          # Insert this command at line 129
```

Then build the tests again:

```bash
cd build
cmake ..
make
```

Test the new binary in `sims/verilator`:

```bash
cd ../../sims/verilator
./simulator-chipyard.harness-RocketConfig ../../tests/ecex62.riscv
```

You should see the following output:

```
[UART] UART0 is here (stdin/stdout).
Welcome to ECE462/562
The results of addition is: 3
- /workspace/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/gen-collateral/TestDriver.v:158: Verilog $finish
```

Following this setup, you can compose experiments targeting your optimization goal. For example, if you are optimizing branch prediction, you can create specific test cases with high control flow to stress the CPU and benchmark.

---

## Custom Design Development

You can find default RocketCore configurations provided by Chipyard in:

```
generators/chipyard/src/main/scala/config/RocketConfigs.scala
```

It generates the configuration with a single HugeCore if the user does not specify any configuration during simulation build.

To generate a specific configuration such as `DualRocketConfig`, run the following in `sims/verilator`:

```bash
make CONFIG=DualRocketConfig
```

This process will generate a binary named `simulator-chipyard.harness-DualRocketConfig`. You can test it using the `ecex62` binary generated earlier:

```bash
./simulator-chipyard.harness-DualRocketConfig ../../tests/ecex62.riscv
```

Core implementation of the RocketCore generator is in `generators/rocket-chip/src/main/scala`. The `rocket/` folder contains implementations for each CPU component such as data cache (`DCache.scala`), TLB (`TLB.scala`), etc.

### Custom Data Cache Configuration

This tutorial uses `BigCore` as the baseline, defined in:

```
generators/rocket-chip/src/main/scala/rocket/Configs.scala
```

Default data cache values can be found in:

```
generators/rocket-chip/src/main/scala/rocket/HellaCache.scala
```

For this example, we will change `nSets` from 64 to 32 and `nWays` from 4 to 8 for the data cache:

```scala
// Default configuration:
dcache = Some(DCacheParams(
  rowBits = site(SystemBusKey).beatBits,
  nMSHRs = 0,
  blockBytes = site(CacheBlockBytes))),

// Updated configuration:
dcache = Some(DCacheParams(
  nSets = 32,
  nWays = 4,
  rowBits = site(SystemBusKey).beatBits,
  nMSHRs = 0,
  blockBytes = site(CacheBlockBytes))),
```

Instead of modifying in-place, create a new config file:

```bash
touch generators/chipyard/src/main/scala/config/BigCorewithUpdatedDCache.scala
```

Copy-paste the following code to `BigCorewithUpdatedDCache.scala`:

```scala
package chipyard

import org.chipsalliance.cde.config._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.rocket._
import freechips.rocketchip.tile._

class WithNBigCoresDCache(
  n: Int,
  location: HierarchicalLocation,
  crossing: RocketCrossingParams,
) extends Config((site, here, up) => {
  case TilesLocated(`location`) => {
    val prev = up(TilesLocated(`location`), site)
    val idOffset = up(NumTiles)
    val big = RocketTileParams(
      core = RocketCoreParams(mulDiv = Some(MulDivParams(
        mulUnroll = 8,
        mulEarlyOut = true,
        divEarlyOut = true))),
      dcache = Some(DCacheParams(
        nSets = 32,
        nWays = 4,
        rowBits = site(SystemBusKey).beatBits,
        nMSHRs = 0,
        blockBytes = site(CacheBlockBytes))),
      icache = Some(ICacheParams(
        rowBits = site(SystemBusKey).beatBits,
        blockBytes = site(CacheBlockBytes))))
    List.tabulate(n)(i => RocketTileAttachParams(
      big.copy(tileId = i + idOffset),
      crossing
    )) ++ prev
  }
  case NumTiles => up(NumTiles) + n
}) {
  def this(n: Int, location: HierarchicalLocation = InSubsystem) =
    this(n, location, RocketCrossingParams(
      master = HierarchicalElementMasterPortParams.locationDefault(location),
      slave = HierarchicalElementSlavePortParams.locationDefault(location),
      mmioBaseAddressPrefixWhere = location match {
        case InSubsystem => CBUS
        case InCluster(clusterId) => CCBUS(clusterId)
      }
    ))
}
```

Also append the SoC configuration to the end of the file:

```scala
class BigCorewithDCacheUpdateConfig extends Config(
  new WithNBigCoresDCache(1) ++
  new chipyard.config.AbstractConfig)  // Default Chipyard base config
```

Build the new SoC configuration:

```bash
make CONFIG=BigCorewithDCacheUpdateConfig
```

After the build completes, check the generated config JSON to verify cache parameters:

```
generated-src/chipyard.harness.TestHarness.BigCorewithDCacheUpdateConfig/chipyard.harness.TestHarness.BigCorewithDCacheUpdateConfig.json
```

You should see the following entries:

```json
"d-cache-block-size": [64]
"d-cache-sets": [32]
"d-cache-size": [8192]
```

Number of ways can be calculated as:

```
nWays = Cache size / (Number of sets × Block size)
nWays = 8192 / (32 × 64) = 4
```

Now test the new core:

```bash
./simulator-chipyard.harness-BigCorewithDCacheUpdateConfig ../../tests/ecex62.riscv
```

---

## Performance Metrics

You can record the number of cycles and instructions through your custom test:

```c
#include <stdint.h>
#include <stdio.h>

int main() {
    uint64_t start_c, end_c, start_i, end_i;
    asm volatile("csrr %0, mcycle"   : "=r"(start_c));
    asm volatile("csrr %0, minstret" : "=r"(start_i));

    for (volatile int i = 0; i < 1000; i++) {  // Run for multiple iterations
        // Your test code
    }

    asm volatile("csrr %0, mcycle"   : "=r"(end_c));
    asm volatile("csrr %0, minstret" : "=r"(end_i));

    printf("Cycles: %lu\n",       end_c - start_c);
    printf("Instructions: %lu\n", end_i - start_i);
}
```

---

## ROCC Accelerator Integration

If you want to implement a ROCC accelerator and couple it with your CPU, use the template code located in `ECEx62_ROCC.scala`.

This tutorial leverages the example accumulator accelerator from Chipyard and implements it as an external configuration within the system.

### Source Code Description

| Lines   | Description                    |
|---------|-------------------------------|
| 1–19    | Package imports (bare-minimum) |
| 22–92   | Actual accelerator implementation |
| 94–99   | Accelerator configuration      |
| 101–106 | SoC configuration (change accelerator and core type here) |

### Accelerator Implementation

Chipyard includes a detailed explanation regarding the registers exposed for ROCC accelerator implementation in **Section 6.6**.

ROCC accelerator uses custom instruction opcodes, defined as:

```scala
class WithAccumulator(op: OpcodeSet = OpcodeSet.custom0) extends Config((site, here, up) => {
```

In this case, custom opcode 0 is used for invoking the accelerator in test cases.

### Running Tests

1. Include `ECEx62_ROCC.scala` in the following folder:
   ```
   generators/chipyard/src/main/scala/config
   ```

2. Build in `sims/verilator`:
   ```bash
   make CONFIG=ROCCTest
   ```

3. If you haven't already, build the example accumulator test code:
   ```bash≠
   cd tests
   mkdir build && cd build
   cmake ..
   make
   ```

4. Run the example accumulator code from `sims/verilator`:
   ```bash
   ./simulator-chipyard.harness-ROCCTest ../../tests/accum.riscv
   ```

### Implementing Your Own Accelerator

Create a new Scala file in `generators/chipyard/src/main/scala/config` and follow the reference code in `ECEx62_ROCC.scala`.