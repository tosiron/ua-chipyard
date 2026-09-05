# Cache Configuration Experiments

This guide introduces cache experiments using Chipyard/Rocket.

Specific assignments will provide the exact parameters and configurations to modify. The purpose of this document is to establish the experimental methodology.

---

## 1. Why Cache Configuration Matters

Processor performance depends not only on computation but also on how efficiently instructions and data are supplied to the processor.

Cache behavior depends on properties such as:

* capacity,
* line/block size,
* associativity,
* replacement behavior, and
* application memory-access patterns.

A larger cache is not automatically better for every workload, and a cache parameter that helps one application may have little effect on another.

The objective is to connect application behavior to memory-hierarchy design.

---

## 2. Start from the Course Baseline

The baseline architecture is:

```text
CourseRocketConfig
```

Do not modify this configuration directly.

Instead, create a separate configuration for each cache experiment.

For example:

```text
CourseRocketConfig
CourseCache8KBConfig
CourseCache16KBConfig
```

---

## 3. Locate the Relevant Configuration

Chipyard configuration files are generally located under:

```text
/workspace/chipyard/generators/chipyard/src/main/scala/config/
```

Individual assignments will identify the configuration fragment or parameter to modify.

Rocket cache parameters may include concepts such as:

```text
nSets
nWays
blockBytes
```

where, conceptually:

* `nSets` controls the number of cache sets;
* `nWays` controls associativity;
* `blockBytes` controls cache-line size.

Do not assume parameter values without examining the configuration used by the assignment.

---

## 4. Cache Capacity

For a conventional set-associative cache:

$$
Capacity =
Sets \times Ways \times BlockSize.
$$

For example:

```text
64 sets
2 ways
64-byte blocks
```

gives:

$$  64 \times 2 \times 64 = 8192\ bytes = 8\ KiB $$

Always calculate the actual cache capacity represented by your configuration.

---

## 5. Build the Baseline

From:

```bash
cd /workspace/chipyard/sims/verilator
```

build:

```bash
make CONFIG=CourseRocketConfig
```

Run the assigned benchmark and record the requested baseline statistics.

---

## 6. Build the Modified Cache

After creating the new configuration:

```bash
make CONFIG=CourseCacheConfig
```

Run exactly the same benchmark and input:

```bash
./simulator-chipyard.harness-CourseCacheConfig \
  /workspace/student-work/<benchmark>.riscv
```

Do not change the application while comparing cache configurations unless specifically instructed.

---

## 7. Cache Miss Rate

A common metric is:

$$
Miss\ Rate =
\frac{Cache\ Misses}
{Cache\ Accesses}.
$$

For example:

```text
100,000 accesses
5,000 misses
```

gives:

```text
Miss Rate = 5%
```

A lower miss rate often improves performance, but the relationship is not necessarily proportional.

The performance cost of a miss depends on the rest of the memory hierarchy.

---

## 8. Average Memory Access Time

A simplified model is:

$$
AMAT =
Hit\ Time +
Miss\ Rate \times Miss\ Penalty.
$$

Suppose:

```text
Hit time     = 1 cycle
Miss rate    = 5%
Miss penalty = 50 cycles
```

Then:  

$$ AMAT = 1 + 0.05(50) = 3.5\ cycles $$

This simplified model is useful for predicting how cache behavior may affect performance.

The actual processor may contain effects not represented by the simplified equation.

---

## 9. Capacity Experiments

A typical experiment might compare:

```text
4 KiB
8 KiB
16 KiB
32 KiB
```

Before running the simulations, predict what you expect.

Questions to consider:

* Does the application's working set fit?
* Is the application streaming through data?
* Is data reused?
* Is the baseline cache already large enough?
* At what point should additional capacity provide diminishing returns?

Then measure.

---

## 10. Associativity Experiments

A typical experiment might compare:

```text
direct mapped
2-way
4-way
```

Increasing associativity can reduce conflict misses.

However, the relationship between associativity and overall processor design is not free: real hardware may incur additional complexity, access time, energy, and area.

Simulation results should therefore not automatically be interpreted as:

> More associativity is always better.

Instead ask:

> Does this workload benefit enough to justify the architectural change?

---

## 11. Cache-Line Size

Changing block size changes how much neighboring data is fetched on a miss.

Larger blocks may help workloads with strong spatial locality.

For example:

```c
for (i = 0; i < N; i++)
    sum += a[i];
```

accesses consecutive elements.

However, larger blocks can also:

* transfer unused data,
* reduce the number of blocks that fit in the cache, and
* increase memory traffic.

Again, workload behavior determines the result.

---

## 12. Controlled Experiment Example

Suppose the assignment asks whether increasing D-cache capacity helps an application.

Collect:

| Configuration | Cache Size | Cycles | Instructions | CPI | D-Cache Misses |
| ------------- | ---------: | -----: | -----------: | --: | -------------: |
| Baseline      |      4 KiB |        |              |     |                |
| Config A      |      8 KiB |        |              |     |                |
| Config B      |     16 KiB |        |              |     |                |

Then calculate speedup relative to baseline:

$$
Speedup =
\frac{Cycles_{baseline}}
{Cycles_{configuration}}.
$$

The analysis should explain **why** the miss behavior changes and whether that change explains the observed performance.

---

## 13. Diminishing Returns

Suppose:

```text
4 KiB  -> 8 KiB      large improvement
8 KiB  -> 16 KiB     modest improvement
16 KiB -> 32 KiB     almost no improvement
```

This result suggests that after some point, cache capacity is no longer the primary performance bottleneck.

This illustrates a recurring theme in computer architecture:

> Improving one bottleneck eventually exposes another.

---

## 14. Do Not Optimize Only the Statistic

The goal is not necessarily to minimize cache misses, but usually to improve the desired system metric, such as execution time.

A configuration that slightly reduces misses but introduces other costs may not be the best architecture.

Always connect:

```text
architectural change
        ↓
cache behavior
        ↓
processor behavior
        ↓
application performance
```

---

## 15. Reporting Cache Experiments

A good cache analysis should include:

1. baseline configuration;
2. modified parameter;
3. predicted effect;
4. measured cache behavior;
5. measured performance;
6. calculated speedup; and
7. architectural explanation.

Simply reporting that "the larger cache was faster" is insufficient.

