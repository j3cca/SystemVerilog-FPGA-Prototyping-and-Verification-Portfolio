# Parametric Bit-Manipulation Unit

## Project Overview
**Description:** For this project, I implemented the shifter unit in two ways: first, using a rotate-right shifter and a rotate-left shifter, second, using only one rotate-right shifter with pre and post-reversing circuits for rotate-left functionality. 

I compared the number of logic cells and the propagation delays of both implementations to determine which implementation used fewer resources. I then parametrized the second implementation to accept any number of input bits, allowing for reusability in future projects.

**Block Diagram:**
<br>
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/parametric_barrel_shifter_block_diagram.png" width="700"> 
> *This parametric bit-manipulation unit accepts an input, an amount to be shifted, and a signal for whether the shift is a left shift or a right shift. Pre and post-reversing circuits allow a multi-function shifter to be constructed using only a single rotate-right shifter, while still allowing the shifting to both the right and left.*

## Simulation
**Verification Summary:** To verify the functionality of each design, three self-checking testbenches were constructed using for-loops to iterate through 1000 random input combinations, ensuring rigorous correctness. For troubleshooting, $display statements printed the inputs and outputs of each test and whether it passed or failed. 

To avoid the tautology problem, I verified the hardware against an independent software algorithm. The RTL uses a `2N` concatenation-and-truncate method for area optimization, while the testbench calculates the expected output using a shift-and-mask algorithm. This will ensure that any errors in the RTL are not repeated in the testbench.

**Simulation Waveform**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/parametric_barrel_shifter_simulation_waveforms.png)
> *This image shows a portion of the simulation waveform with matching outputs from the TB and UUT.*

**Simulation Log Snippet**
<details>
<summary><i>Click to expand</i></summary>

``` Time resolution is 1 ps
-- Starting Test Bench --
Test number         100 executing...
Test number         200 executing...
Test number         300 executing...
Test number         400 executing...
Test number         500 executing...
Test number         600 executing...
Test number         700 executing...
Test number         800 executing...
Test number         900 executing...
-- Test Bench Summary --
Pass count: 1000
Fail count: 0
All tests passed!
$finish called at time : 10 us 
```
</details>

## Implementation  
**Schematic:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/parametric_barrel_shifter_schematic.png" width="800">

<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/parametric_barrel_shifter_schematic_zoom.png" width="800">

**FPGA Utilization and Propagation Delay:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/parametric_barrel_shifter_resource_utilization.png" width="600">

<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/parametric_barrel_shifter_propagation_delay.png" width="600">

## Reflection
My initial goal with implementing this project in two ways was to determine which approach utilized the fewest resources. However, due to innovations in hardware (particularly in this instance, the use of 6-input LUTs) and software (particularly, Vivado's ability to optimize a design), both implementations used the same minimum number of slices. If I was working with an older board or a software with less optimization capability, this exercise would have been more illustrative.

## Directory Table of Contents
<pre>
Parametric Bit-Manipulation Unit/
│
├── src/
│   ├── <a href="./src/parametric_barrel_shifter.sv">parametric_barrel_shifter.sv</a>
│   ├── <a href="./src/barrel_8_bit_alt.sv">barrel_8_bit_alt.sv</a>
│   └── <a href="./src/barrel_8_bit.sv">barrel_8_bit.sv</a>
│
├── sim/
│   ├── <a href="./sim/TB_parametric_barrel_shifter.sv">TB_parametric_barrel_shifter.sv</a>
│   ├── <a href="./sim/TB_barrel_8_bit_alt.sv">TB_barrel_8_bit_alt.sv</a>
│   ├── <a href="./sim/TB_barrel_8_bit.sv">TB_barrel_8_bit.sv</a>
│   └── <a href="./sim/TB_parametric_barrel_shifter_behav.wcfg">TB_parametric_barrel_shifter_behav.wcfg</a>
│
├── constraints/
│   └── <a href="./constraints/Cmod-S7-25-Master.xdc">Cmod-S7-25-Master.xdc</a>
│
└── <a href="./README.md">README.md</a>
</pre>
