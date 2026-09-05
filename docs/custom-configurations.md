# Custom Chipyard Configurations

Chipyard uses configuration classes to describe processor and SoC designs.

In this course, configuration classes allow us to modify architectural parameters while preserving a known baseline.

---

## 1. Course Baseline

The standard processor configuration is:

```text
CourseRocketConfig
```

Unless an assignment explicitly states otherwise, all architectural experiments should begin from this configuration.

Do **not** modify the standard Chipyard:

```text
RocketConfig
```

and do not modify `CourseRocketConfig` simply to create an experimental architecture.

Instead, create a new configuration derived from the baseline.

---

## 2. Why Use Separate Configurations?

Suppose we want to compare:

```text
Baseline processor
```

against:

```text
Processor with modified cache
```

If we directly modify the baseline, we lose the original architecture.

Instead, we want:

```text
CourseRocketConfig
        |
        +---- CourseCacheConfig
```

This allows both architectures to coexist.

We can then run the same workload on both and compare them directly.

---

## 3. Configuration Location

Course-related Chipyard configurations are generally placed under:

```text
/workspace/chipyard/generators/chipyard/src/main/scala/config/
```

The exact location or starter file will be provided by individual assignments.

---

## 4. Configuration Composition

Chipyard configurations are composed from configuration fragments.

Conceptually:

```scala
class ModifiedConfig extends Config(
  new SomeModification ++
  new CourseRocketConfig
)
```

means:

> Start with `CourseRocketConfig` and apply `SomeModification`.

The precise syntax depends on the architectural feature being changed.

Assignments will provide the relevant configuration fragments or identify the Chipyard parameters you need to modify.

---

## 5. Finding Available Configurations

From:

```bash
cd /workspace/chipyard/sims/verilator
```

you can use:

```bash
make find-configs
```

to identify available configuration classes.

Your configuration should appear in the resulting list.

If it does not, check:

* package declaration,
* class name,
* imports,
* file location, and
* Scala syntax.

---

## 6. Build a Configuration

Build the baseline with:

```bash
make CONFIG=CourseRocketConfig
```

Build a modified configuration with:

```bash
make CONFIG=YourConfig
```

For example:

```bash
make CONFIG=CourseCacheConfig
```

Each configuration generates its own simulator.

---

## 7. Run the Same Workload on Both

For a valid architectural comparison, keep the software workload unchanged.

For example:

```bash
./simulator-chipyard.harness-CourseRocketConfig \
  /workspace/student-work/benchmark.riscv
```

and:

```bash
./simulator-chipyard.harness-CourseCacheConfig \
  /workspace/student-work/benchmark.riscv
```

Then compare the relevant statistics.

This is a controlled experiment:

```text
Same application
Same input
Same software
Different architecture
```

Ideally, only the architectural parameter under investigation changes.

---

## 8. Change One Major Variable at a Time

Suppose you simultaneously change:

* cache size,
* cache associativity,
* branch predictor, and
* another processor parameter.

Performance improves by 20%.

Which change caused the improvement?

You cannot tell.

For most experiments, change one architectural factor at a time.

For example:

```text
CourseRocketConfig
CourseLargerCacheConfig
```

Then:

```text
CourseRocketConfig
CourseTwoWayCacheConfig
```

This makes the effect of each design choice interpretable.

---

## 9. Preserve the Baseline

The following files should be treated as reference implementations unless an assignment specifically instructs you to modify them:

```text
RocketConfig
CourseRocketConfig
```

Likewise, do not modify files under:

```text
generators/rocket-chip
```

unless specifically instructed.

Later assignments and projects may require modifications to Rocket internals. Those modifications should be deliberate and documented.

---

## 10. Naming Configurations

Use descriptive names.

Good:

```text
Course8KBCacheConfig
CourseTwoWayCacheConfig
CourseGShareConfig
ProjectPrefetcherConfig
```

Poor:

```text
TestConfig
NewConfig
Config2
FinalConfig
FinalConfig2
```

A configuration name should communicate what distinguishes it from the baseline.

---

## 11. Record Your Changes

For every custom architecture, you should be able to answer:

1. What configuration did you start from?
2. What architectural parameter changed?
3. What was its original value?
4. What is its new value?
5. Why did you expect this change to affect the workload?
6. What happened when you measured it?

This information will often be required in lab reports and project check-ins.

---

## 12. Keep Experimental Configurations

Do not repeatedly overwrite one configuration while collecting results.

If an experiment compares:

```text
4 KB
8 KB
16 KB
```

prefer separate configurations such as:

```text
CourseCache4KBConfig
CourseCache8KBConfig
CourseCache16KBConfig
```

This makes experiments reproducible and reduces uncertainty about which hardware generated a result.

---

## 13. Architectural Experiments

The general workflow is:

```text
Baseline
   |
   v
Identify bottleneck
   |
   v
Form architectural hypothesis
   |
   v
Create modified configuration
   |
   v
Build hardware
   |
   v
Run same workload
   |
   v
Compare measurements
   |
   v
Explain result
```

The configuration is a means to perform an architectural experiment, not merely to produce a configuration that compiles.

