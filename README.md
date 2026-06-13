# Laboratory Activity 1: Timers, Interrupts, and Task Scheduling

**Course:** BCA143 Firmware Programming
**Student:** [Your Full Name]
**Date:** [Submission Date]

---

## Project Description

This project implements timer-based interrupts and a cyclic executive scheduler on the **STM32F407ZGT6** microcontroller (RT-Thread RT-Spark board). It demonstrates foreground/background system architecture, priority-based interrupt handling, and real-time timing analysis using the DWT cycle counter.

---

## Hardware

| Component | Details |
|---|---|
| Board | RT-Thread RT-Spark Development Board |
| MCU | STM32F407ZGT6 (LQFP144) |
| LED (Red) | PF11 |
| LED (Blue) | PF12 |
| User Button | PC5 (EXTI, falling edge) |
| Debug Pin | PE0 |

---

## Features

- **TIM2** — 1 Hz periodic interrupt (highest priority, NVIC priority 0)
- **TIM3** — 2 Hz periodic interrupt (medium priority, NVIC priority 1)
- **EXTI** — External interrupt on button press (PC5, falling edge, priority 2)
- Foreground/background (cyclic executive) system architecture
- Timing measurement using the ARM DWT cycle counter
- Timing analysis: latency, ISR duration, task execution time, and response time

---

## Timing Measurements

| Parameter | Definition | Measured Value | Units |
|---|---|---|---|
| T_Release(TIM2) | Timer interrupt period | 1.0 | seconds |
| T_Latency(Task A) | Delay before Task A starts | 24.43 | µs |
| T_ISR(TIM2) | Time spent inside TIM2 ISR | 4.31 | µs |
| T_Task(Task A) | Task A execution time | 50 | ms |
| T_Response(Task A) | Total response time | 50.024 | ms |

---

## Sequence Diagram

> *(Insert sequence diagram image here)*

---

## Build Instructions

1. Open the project in **STM32CubeIDE**
2. Build: `Project → Build All`
3. Connect the RT-Spark board via USB
4. Flash and debug: `Run → Debug` or `Run → Run`

> **Toolchain:** GCC | **Firmware:** STM32Cube FW_F4 V1.28.3 | **CubeMX:** v6.15.0

---

## Analysis

**1. What is the maximum latency for Task A?**

The maximum latency for Task A is **21.006 ms**. This was measured using the DWT cycle counter by recording a timestamp at the beginning of the TIM2 callback and another at the start of the `task_adc_ready` section in the main loop. The difference between these timestamps represents the delay before Task A was executed, and the highest recorded value was 21.006 ms.

**2. What happens to Task A latency if Task B is running when TIM2 fires?**

If Task B is running when the TIM2 interrupt occurs, Task B will be temporarily paused because TIM2 has a higher NVIC priority. The processor will immediately handle the TIM2 interrupt and execute its ISR before returning to Task B. As a result, Task A can be triggered sooner, which helps reduce its latency.

**3. Calculate the worst-case T_Response for Task A if all other tasks are running.**

The worst-case response time is calculated by adding the maximum latency to Task A's execution time:

```
T_Response(worst) = T_Latency(max) + T_Task(A)
                  = 21.006 ms + 50 ms
                  = 71.006 ms
```

**4. How would a preemptive scheduler affect Task A's response time?**

With a preemptive scheduler, the response time of Task A would generally be lower — especially if it holds a higher priority than the other tasks. Once Task A becomes ready, it can interrupt a lower-priority task and begin execution immediately instead of waiting for the current task to finish. This reduces latency and improves the overall response time of Task A.

---

## References

1. Castor, P. R. P. (2025). *Software Design Basics* [Lecture 2]. BCA143 Firmware Programming, MSU-IIT.
2. STMicroelectronics. (2024). *STM32F4 HAL Driver User Manual*.
