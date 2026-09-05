# Running RISC-V Programs in Chipyard

This guide explains how to compile RISC-V programs and execute them on the `CourseRocketConfig` processor using Verilator.

Before continuing, complete the [Getting Started](/docs/getting-started.md) guide.

---

## 1. Start the Course Environment

From the course repository on your host computer:

```bash
docker compose run --rm chipyard
```

Inside the container, load the Chipyard environment:

```bash
cd /workspace/chipyard
source env.sh
```

---

## 2. Running an Existing RISC-V Test

Move to the Verilator simulation directory:

```bash
cd /workspace/chipyard/sims/verilator
```

If necessary, build the course processor:

```bash
make CONFIG=CourseRocketConfig
```

Run a standard RISC-V ISA test:

```bash
./simulator-chipyard.harness-CourseRocketConfig \
  $RISCV/riscv64-unknown-elf/share/riscv-tests/isa/rv64ui-p-simple
```

A successful execution confirms that the generated processor can execute RISC-V programs correctly.

---

## 3. Compiling Your Own Program

Create a working directory:

```bash
mkdir -p /workspace/student-work/programs/hello
cd /workspace/student-work/programs/hello
```

Create `hello.c`:

```c
#include <stdio.h>

int main(void)
{
    printf("Hello from the Other Side!\n");
    return 0;
}
```

Programs executed using the normal Chipyard bare-metal simulation environment should be compiled using the RISC-V cross-compiler rather than your computer's native compiler.

The exact compilation command may depend on the runtime environment provided for an assignment. When a Makefile or build script is supplied, **use the supplied build system** rather than constructing your own compiler command.

You can verify that the compiler is available with:

```bash
which riscv64-unknown-elf-gcc
```

---

## 4. Using Course Benchmarks

Most course assignments will provide a benchmark or application together with a Makefile.

A typical workflow will be:

```bash
cd /workspace/student-work/<assignment>/<benchmark>
make
```

This should produce a RISC-V executable, often with a name ending in `.riscv`.

For example:

```text
sensor.riscv
```

Do not assume that an ordinary executable compiled for your host computer will run on Rocket. The executable must target the appropriate RISC-V architecture and runtime environment.

---

## 5. Run the Program on Rocket

Once you have a RISC-V executable:

```bash
cd /workspace/chipyard/sims/verilator
```

Then execute:

```bash
./simulator-chipyard.harness-CourseRocketConfig \
  /workspace/student-work/<path-to-program>/program.riscv
```

For example:

```bash
./simulator-chipyard.harness-CourseRocketConfig \
  /workspace/student-work/lab01/sensor.riscv
```

The simulator loads the program into the simulated system and executes it on the generated Rocket processor.

---

## 6. Software Changes vs. Hardware Changes

This distinction is important throughout the course.

### If you change only the program

Recompile the program:

```bash
make
```

You normally **do not** need to rebuild the Verilator processor simulator.

### If you change the processor architecture

For example, if you change:

* cache parameters,
* branch prediction,
* a hardware unit,
* a Chipyard configuration, or
* Rocket implementation code,

you normally need to rebuild the simulator:

```bash
cd /workspace/chipyard/sims/verilator
make CONFIG=<YourConfig>
```

Hardware builds take much longer than software compilation, so don't rebuild the hardware unnecessarily.

---

## 7. Running Different Processor Configurations

Suppose an assignment provides:

```text
CourseRocketConfig
CourseBranchPredictorConfig
```

Build each architecture separately:

```bash
make CONFIG=CourseRocketConfig
make CONFIG=CourseBranchPredictorConfig
```

The generated simulators are separate executables.

You might then run:

```bash
./simulator-chipyard.harness-CourseRocketConfig program.riscv
```

and:

```bash
./simulator-chipyard.harness-CourseBranchPredictorConfig program.riscv
```

This allows you to compare the same application on different architectures.

---

## 8. Reproducible Experiments

When reporting results, always record at least:

* benchmark/application,
* processor configuration,
* input or dataset, if applicable,
* cycle count,
* instruction count,
* CPI when relevant, and
* architectural feature being changed.

For example:

| Configuration      |    Cycles | Instructions |  CPI |
| ------------------ | --------: | -----------: | ---: |
| CourseRocketConfig | 1,850,000 |    1,000,000 | 1.85 |
| CourseBranchPredictorConfig  | 1,420,000 |    1,000,000 | 1.42 |

Do not report only that one configuration was "faster."

Quantify the difference.

For example:

$$
Speedup =
\frac{T_{\text{baseline}}}{T_{\text{new}}}
$$

If clock frequency is unchanged and execution time is represented by simulated cycles:

$$
Speedup =
\frac{Cycles_{\text{baseline}}}
{Cycles_{\text{new}}}.
$$

---

## 9. Common Problems

### `riscv64-unknown-elf-gcc: command not found`

You probably have not loaded the environment:

```bash
cd /workspace/chipyard
source env.sh
```

### Simulator executable does not exist

Build it:

```bash
cd /workspace/chipyard/sims/verilator
make CONFIG=CourseRocketConfig
```

### Program does not execute correctly

First verify that:

1. the executable was compiled for RISC-V;
2. you are using the build procedure supplied with the assignment;
3. the baseline simulator passes `/workspace/test-install.sh`.

If the installation test passes but your application fails, the problem is probably with the application or experiment rather than the base course environment.

---

## Next

Continue with [Performance Counters](performance-counters.md) to learn how to measure processor performance.

