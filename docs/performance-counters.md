# Performance Counters

Computer architecture experiments require quantitative measurements. In this course, you will use RISC-V hardware performance counters and simulator statistics to analyze application behavior.

The two most fundamental measurements are:

* **cycles**, and
* **retired instructions**.

These allow us to calculate CPI and compare architectural configurations.

---

## 1. Cycle and Instruction Counters

RISC-V provides control and status registers (CSRs) containing performance information.

Two important counters are:

```text
mcycle
minstret
```

`mcycle` counts processor cycles.

`minstret` counts instructions that have retired.

They can be read using the `csrr` instruction.

For example:

```c
static inline unsigned long read_cycles(void)
{
    unsigned long value;

    asm volatile (
        "csrr %0, mcycle"
        : "=r"(value)
    );

    return value;
}

static inline unsigned long read_instructions(void)
{
    unsigned long value;

    asm volatile (
        "csrr %0, minstret"
        : "=r"(value)
    );

    return value;
}
```

---

## 2. Measuring a Region of Code

Usually we do not want to measure program initialization, printing, or unrelated work.

Instead, measure the region of interest.

For example:

```c
unsigned long cycles_start;
unsigned long cycles_end;

unsigned long inst_start;
unsigned long inst_end;

cycles_start = read_cycles();
inst_start   = read_instructions();

/* Region of interest */
compute();

cycles_end = read_cycles();
inst_end   = read_instructions();

unsigned long cycles =
    cycles_end - cycles_start;

unsigned long instructions =
    inst_end - inst_start;
```

The difference represents approximately the work performed by `compute()`.

---

## 3. Calculate CPI

Cycles per instruction is:

$$
CPI =
\frac{\text{Cycles}}
{\text{Instructions}}
$$

For example:

```text
Cycles       = 1,800,000
Instructions = 1,000,000
```

gives:

$$
CPI = 1.8.
$$

CPI is useful because it separates the number of instructions executed from the average number of cycles required per instruction.

However, CPI alone does **not** determine performance.

An optimization may reduce instruction count while increasing CPI, or increase instruction count while reducing total cycles.

The primary quantity of interest is usually total execution time.

---

## 4. CPU Performance Equation

Recall:

$$
CPU\ Time =
Instruction\ Count
\times CPI
\times Clock\ Cycle\ Time.
$$

Equivalently:

$$
CPU\ Time =
\frac{
Instruction\ Count \times CPI
}{
Clock\ Rate
}.
$$

This relationship will recur throughout the semester.

Architectural optimizations may affect different terms.

For example:

* compiler optimization may reduce instruction count;
* pipelining may reduce effective CPI;
* cache misses may increase CPI;
* branch mispredictions may increase CPI;
* a more complicated architecture may affect maximum clock frequency.

Do not assume that improving one term necessarily improves overall performance.

---

## 5. Calculating Speedup

Speedup is:

$$
Speedup =
\frac{T_{\text{old}}}
{T_{\text{new}}}.
$$

If two simulated architectures operate at the same clock frequency:

$$
Speedup =
\frac{Cycles_{\text{old}}}
{Cycles_{\text{new}}}.
$$

For example:

```text
Baseline cycles = 2,000,000
New cycles      = 1,600,000
```

then:

$$
Speedup =
\frac{2,000,000}{1,600,000}
= 1.25.
$$

The new architecture is therefore **1.25× as fast** for this workload under the stated assumptions.

---

## 6. Percentage Reduction Is Not Speedup

Be careful not to confuse these quantities.

If cycles decrease from:

```text
2,000,000
```

to:

```text
1,600,000
```

the cycle reduction is:

$$
\frac{2,000,000-1,600,000}
{2,000,000}
=20\%.
$$

But speedup is:

$$
1.25\times.
$$

These are different quantities.

---

## 7. Amdahl's Law

When only part of an application is improved, use Amdahl's Law:

$$
S =
\frac{1}
{(1-f)+\frac{f}{s}}
$$

where:

* \(f\) is the fraction of original execution time affected by the optimization;
* \(s\) is the speedup of that portion;
* \(S\) is overall application speedup.

For example, suppose profiling shows that a computation consumes 40% of execution time.

If that computation is accelerated by 5x:

$$
S = \frac{1}{0.60+\frac{0.40}{5}} = 1.47
$$

A 5× improvement to the targeted portion therefore produces only approximately a 1.47× overall speedup.

This is why profiling is necessary before deciding what to optimize.

---

## 8. Predict Before Measuring

For many course experiments, you will be asked to:

1. measure the baseline;
2. identify a performance bottleneck;
3. predict the benefit of an architectural change;
4. implement or enable the change;
5. measure the result;
6. explain the difference between prediction and measurement.

A prediction that differs from the measured result is not necessarily a bad result.

The important question is:

> **Why did the actual architecture behave differently from the simplified performance model?**

---

## 9. Measurement Overhead

Reading performance counters requires instructions.

Therefore:

```c
start = read_cycles();
...
end = read_cycles();
```

does not provide a mathematically perfect zero-overhead measurement.

For sufficiently long regions of interest, this overhead is usually small relative to the measured computation.

For very short regions, measurement overhead can become significant.

Do not draw strong conclusions from extremely small differences without considering measurement overhead.

---

## 10. Compiler Optimization

Compiler behavior can significantly affect performance measurements.

The compiler may:

* eliminate unused computations;
* inline functions;
* reorder operations;
* simplify loops;
* remove code whose result is never observed.

If an assignment specifies optimization options, use the specified options so that results are comparable.

---

## 11. What to Report

Unless otherwise specified, performance experiments should report:

| Metric       | Meaning                          |
| ------------ | -------------------------------- |
| Cycles       | Total cycles for measured region |
| Instructions | Retired instructions             |
| CPI          | Cycles / instructions            |
| Speedup      | Baseline time / new time         |

Assignments may additionally request:

* cache accesses,
* cache misses,
* branch counts,
* branch mispredictions,
* stall cycles,
* memory traffic, or
* other microarchitectural statistics.

---

## 12. Interpretation Matters

A table of numbers is not an architectural analysis.

Suppose you obtain:

| Configuration | Instructions |  CPI | Cycles |
| ------------- | -----------: | ---: | -----: |
| Baseline      |        1.00M | 2.00 |  2.00M |
| Modified      |        1.10M | 1.50 |  1.65M |

A useful analysis would observe that the modified architecture executes **more instructions**, but sufficiently reduces CPI so that total execution cycles still decrease.

Always connect measured results to architectural behavior.

