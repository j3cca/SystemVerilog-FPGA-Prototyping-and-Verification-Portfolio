# Configurable Timing Engine: Pulse and PWM Generators

<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen.gif" alt="Demonstration" width="400"> 

> *The above demonstration is for a square-wave pulse generator. Because the clock is operating at 12MHz, the human eye is unable to distinguish between high and low intervals, which become "averaged" and dim according to the values applied. The above demonstration shows how the pulse generator can act as a dimmer for an LED. The LOW interval is set to 8 and the HIGH interval is set to 1, 2, 4, and 8 respectively.* 

## Project Overview
**Description:** For this project, I designed and verified two timing engine modules: a parametrized square-wave pulse generator for macro timing control and a parametrized pulse width modulation generator for amplitude control.

The parameterized square-wave pulse generator produces a wave with variable-length high and low intervals. The duration of the intervals is specified by two 4-bit control signals, which are controlled by switches wired to the CMOD S7. The square wave output, for the purpose of demonstration, is wired to an external LED. The design utilizes the CMOD S7's 12MHz onboard crystal oscillator as the clock and onboard button 0 as the asynchronous reset signal.

The pulse width modulation (PWM) generator accepts a control signal that determines the duty cycle of the square wave, which is specified by a 4-bit input wired to switches connected to the device. Like the square-wave pulse generator, this design also utilizes the CMOD S7's 12MHz onboard crystal oscillator as the clock and onboard button 0 as the asynchronous reset signal.

**Pulse Generator Block Diagram:** 
<br>
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen_block_diagram.png)  HEREHERE
> *The design consists of a synchronous cycle counter that acts as a clock divider, and a state machine that tracks the `high_interval` and `low_interval` durations. The logic includes a routing path that forces the output to a safe state if either interval is set to zero, preventing counter underflow.*

**PWM Generator Block Diagram:** 
<br>
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen_block_diagram.png)  HEREHERE
> *The design consists of a synchronous cycle counter that acts as a clock divider, and a state machine that tracks the `high_interval` and `low_interval` durations. The logic includes a routing path that forces the output to a safe state if either interval is set to zero, preventing counter underflow.*

## Simulation
**Verification Summary:** To verify the pulse generator design, I wrote a self-checking testbench in SystemVerilog that exhaustively sweeps all 256 input configurations. 

The testbench drives stimulus changes and de-asserts the reset on the negative clock edge to prevent race conditions with the design's active-high reset. Because the 12 MHz clock has a fractional period 83.333 ns, the testbench uses a 1ns / 1fs timescale and verifies output pulse widths using `$realtime` checks with a 1 ps tolerance to handle rounding errors. 

Finally, I wrapped the transition checks in parallel `fork...join` watchdogs; if a pulse fails to trigger, the watchdog times out instead of hanging the simulator.

To verify the PWM generator design, I reused the pulse generator testbench to sweep all 16 possible duty cycle lengths. This was a great demonstration of how modular design can decrease production time.

**Simulation Waveform**
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen_simulation_waveforms.png) HEREHERE
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
Configurable Timing Engine: Pulse and PWM Generators/
│
├── src/
│   ├── <a href="./src/stim_pulse_gen.sv">TB_stim_pulse_gen.sv</a>
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