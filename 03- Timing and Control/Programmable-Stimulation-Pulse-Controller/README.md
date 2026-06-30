# Programmable Stimulation Pulse Controller

## Project Overview
**Description:** For this project, I designed and verified a parameterized square-wave pulse generator. This simulates the pulse-control stage of a device like a neurostimulator or pacemaker, where the hardware must maintain precise, configurable "active" (high) and "rest" (low) intervals to ensure safe energy delivery to tissue.

Rather than building a free-running oscillator, I engineered a robust timing engine designed to handle the hazards of a safety-critical environment. I implemented defensive counter logic using >= comparisons instead of simple equality checks; this ensures that if a Single Event Upset (bit-flip) occurs or if the interval parameters are updated dynamically by a CPU, the counter cannot "overshoot" and get stuck in an infinite loop. I also included guarded bypass logic to handle edge cases where an interval is set to zero, preventing mathematical underflow and forcing the output to a known safe state.

**Block Diagram:** 
<br>
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen_block_diagram.png)  
> *The architecture consists of a synchronous cycle counter that acts as a clock divider, and a state machine that tracks the `high_interval` and `low_interval` durations. The logic includes a bypass routing path that forces the output to a safe state if either interval is set to zero, preventing counter underflow.*

## Simulation
**Verification Summary:** To prove the mathematical and timing integrity of the pulse generator, I developed an advanced, self-checking testbench utilizing modern SystemVerilog verification idioms. 

The testbench exhaustively sweeps all 256 combinations of the high and low intervals. To prevent delta-cycle race conditions and mid-flight state corruption, the testbench isolates every stimulus by applying an asynchronous reset on the negative clock edge between iterations. Timing verification is handled using `$realtime` measurements evaluated against a floating-point `epsilon` (1 picosecond tolerance) to account for simulation rounding errors. Furthermore, to ensure the testbench is Continuous Integration (CI) safe, I implemented parallel thread watchdogs (`fork...join_any` with `disable fork`) to gracefully catch and report missing pulses without locking up the simulator.

**Simulation Waveform**
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen_simulation_waveforms.png)
> *This image shows the simulation waveform successfully transitioning between dynamic high and low interval configurations, including the handling of zero-interval edge cases.*

**Simulation Log Snippet**
<details>
<summary><i>Click to expand</i></summary>

``` 
-- Starting Test Bench --
Test number 0 executing...
PASS test:
 high = 0
 low = 0
PASS test:
 high = 1
 duration = 1000.000 ns
PASS test:
 low = 1
 duration = 1000.000 ns
Test number 20 executing...
PASS test:
 high = 2
 duration = 2000.000 ns
PASS test:
 low = 10
 duration = 10000.000 ns
...
-- Test Bench Summary --
Pass count: 512
Fail count: 0
All tests passed!
$finish called at time : 854000 ns
```
</details>

## Implementation  
**Schematic:**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen_schematic.png)

**FPGA Utilization and Propagation Delay:**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen_resource_utilization.png)

## Reflection
*[Draft your reflection here. You might want to mention your transition from textbook 1-based counting to industry-standard 0-based counting, how you learned to handle synthesis hazards inside asynchronous reset blocks, or your experience learning about parallel threads (`fork...join_any`) and watchdogs for robust verification!]*

## Directory Table of Contents
<pre>
Parameterized Square Wave Pulse Generator/
│
├── src/
│   └── <a href="./src/stim_pulse_gen.sv">stim_pulse_gen.sv</a>
│
├── sim/
│   ├── <a href="./sim/TB_stim_pulse_gen.sv">TB_stim_pulse_gen.sv</a>
│   └── <a href="./sim/stim_pulse_gen_behav.wcfg">stim_pulse_gen_behav.wcfg</a>
│
├── constraints/
│   └── <a href="./constraints/Cmod-S7-25-Master.xdc">Cmod-S7-25-Master.xdc</a>
│
└── <a href="./README.md">README.md</a>
</pre>