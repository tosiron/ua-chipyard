# RoCC Accelerators

Rocket Custom Coprocessor (RoCC) provides a mechanism for attaching custom accelerators to a Rocket-based system.

RoCC will primarily be relevant to advanced assignments and semester projects.

You do not need to understand RoCC for the introductory course exercises.

---

## 1. Why Use an Accelerator?

A general-purpose processor must efficiently support many kinds of computation.

Some applications contain operations that can be executed much more efficiently using specialized hardware.

Conceptually:

```text
Application
     |
     v
Rocket processor
     |
     +------> Custom accelerator
```

Instead of executing a computation entirely as a sequence of ordinary RISC-V instructions, the processor can invoke specialized hardware.

---

## 2. Amdahl's Law Still Applies

Hardware acceleration does not automatically produce large application speedup.

If an accelerator makes a computation \(s\) times faster and that computation originally represents fraction \(f\) of execution time:

$$
Speedup =
\frac{1}
{(1-f)+\frac{f}{s}}.
$$

Therefore, profiling should normally occur **before** accelerator design.

An accelerator for a function that consumes 2% of execution time is unlikely to produce a large application-level speedup regardless of how fast the accelerator itself is.

---

## 3. RoCC in Chipyard

Chipyard and Rocket provide infrastructure for attaching custom RoCC accelerators.

A RoCC accelerator can receive commands from Rocket and communicate with other parts of the system through the interfaces provided by Rocket/Chipyard.

The course repository includes or may provide starter accelerator code derived from the existing RoCC example.

Individual assignments will identify the relevant source files.

---

## 4. Typical Accelerator Workflow

A project using RoCC generally follows this process:

```text
Profile application
        |
        v
Identify expensive operation
        |
        v
Define accelerator operation
        |
        v
Implement RoCC hardware
        |
        v
Integrate with Rocket configuration
        |
        v
Invoke from software
        |
        v
Measure application performance
```

The accelerator itself is only one part of the experiment.

---

## 5. Software/Hardware Interface

Software must communicate with the accelerator.

Conceptually:

```c
result = accelerator_operation(input);
```

may translate into one or more custom instructions understood by the RoCC interface.

The exact invocation mechanism will be provided with the relevant assignment or starter project.

Do not assume that accelerator invocation is free.

Communication between the processor and accelerator can introduce overhead.

---

## 6. Accelerator Overhead

Suppose software execution requires:

```text
100 cycles
```

while the accelerator performs the actual computation in:

```text
10 cycles.
```

It is tempting to claim:

$$
Speedup = 10\times.
$$

But suppose invoking the accelerator, transferring operands, and retrieving results requires another:

```text
15 cycles.
```

The accelerated execution actually requires:

$$
10+15=25\ cycles.
$$

The effective kernel speedup is therefore:

$$
\frac{100}{25}=4\times.
$$

And overall application speedup may be smaller still because of Amdahl's Law.

---

## 7. Baseline Comparison

Every accelerator project must preserve a software baseline.

Conceptually:

```text
CourseRocketConfig
       |
       +---- software implementation

AcceleratedConfig
       |
       +---- RoCC implementation
```

Run the same application and input on both.

Measure application-level performance, not merely accelerator latency.

---

## 8. Correctness Before Performance

Before measuring performance, verify that the accelerator produces the same required result as the software implementation.

The basic sequence should be:

```text
1. Software result
2. Accelerator result
3. Compare
4. Verify correctness
5. Measure performance
```

A faster incorrect implementation is not an optimization.

---

## 9. What Makes a Good Accelerator Target?

Good candidates often have some combination of:

* significant contribution to application runtime;
* repeated execution;
* regular computation;
* exploitable parallelism;
* operations inefficient on the general-purpose processor;
* manageable communication requirements.

Poor candidates often include operations that:

* execute rarely;
* consume little runtime;
* require large communication overhead relative to computation;
* are difficult to specialize effectively.

---

## 10. Project Evaluation

For a course project, you should be prepared to answer:

1. What application bottleneck are you targeting?
2. What fraction of execution time does it represent?
3. Why is specialized hardware appropriate?
4. What speedup did you predict?
5. What hardware did you add?
6. What communication overhead exists?
7. What speedup did you measure?
8. Why does measured performance differ from the prediction?
9. What architectural cost does the accelerator introduce?

Depending on the project, cost may include:

* hardware complexity,
* area,
* memory traffic,
* additional state,
* energy,
* or design complexity.

---

## 11. RoCC Is an Architectural Tradeoff

The objective is not:

> Add an accelerator.

The objective is:

> Determine whether specialization is an effective architectural response to an observed application bottleneck.

