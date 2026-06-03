# 4-to-16 Decoder
![demonstration](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/3_to_8_decoder.gif)  

> *The above demonstration is for a 3-to-8 decoder, which was constructed using two 2-to-4 decoders and implemented on the CMOD S7.* 

## Project Overview
**Description:** This project consists of a 4-to-16 decoder written in RTL using only gate-level logical operators. The 4-to-16 decoder is composed of four 2-to-4 decoders, which each drive 4 outputs. The 4-to-16 decoder accepts two inputs as the select bits and two inputs as the enable bits to determine which of the four 2-to-4 decoders to select.

Each module was verified with a self-checking testbench that iterated through all possible input combinations to ensure rigorous correctness.

To save space on the breadboard for future additions, a 3-to-8 decoder was constructed using two 2-to-4 decoders, which would require only 8 LEDs to indicate the output. The bitfile was flashed to a CMOD S7 FPGA board. To interface with the FPGA, three DIP-switches were wired to accept the inputs and eight external LEDs were wired to output the result.

**Block Diagram:**  
<br>
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/4_to_16_decoder_block_diagram.jpg)  
> *The 4-to-16 decoder accepts two inputs as the select bits and two inputs as the enable bits to determine which of the four 2-to-4 decoders to select. The same select bits are fed into each 2-to-4 decoder, and the enable bits are combined using a minimal number of logic gates to select the appropriate decoder, then fed into that decoder.*

> *Each decoder will only output a result when recieving the proper enable signal, so only one decoder outputs at a time.* 

## Simulation
**Verification Summary:** To verify the functionality of each module, self-checking testbenches were constructed using for-loops to iterate through all possible input combinations, ensuring rigorous correctness. For troubleshooting, $display statements printed the inputs and outputs of each test and whether it passed or failed. 

**Simulation Waveform**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/4_to_16_decoder_simulation_waveforms.png)
> *This image shows the full simulation waveform for all inputs of A and B. The onboardLED is inverted from externalLED to provide a visual reference for inputs in which A is not greater than B.*

**Simulation Log Snippet**
<details>
<summary><i>Click to expand</i></summary>

``` Time resolution is 1 ps
-- Starting Test Bench --
PASS test: 00 outputs 0000000000000001 (en = 00)
PASS test: 01 outputs 0000000000000010 (en = 00)
PASS test: 10 outputs 0000000000000100 (en = 00)
PASS test: 11 outputs 0000000000001000 (en = 00)
PASS test: 00 outputs 0000000000010000 (en = 01)
PASS test: 01 outputs 0000000000100000 (en = 01)
PASS test: 10 outputs 0000000001000000 (en = 01)
PASS test: 11 outputs 0000000010000000 (en = 01)
PASS test: 00 outputs 0000000100000000 (en = 10)
PASS test: 01 outputs 0000001000000000 (en = 10)
PASS test: 10 outputs 0000010000000000 (en = 10)
PASS test: 11 outputs 0000100000000000 (en = 10)
PASS test: 00 outputs 0001000000000000 (en = 11)
PASS test: 01 outputs 0010000000000000 (en = 11)
PASS test: 10 outputs 0100000000000000 (en = 11)
PASS test: 11 outputs 1000000000000000 (en = 11)
-- Test Bench Summary --
Pass count: 16
Fail count: 0
All tests passed!
$finish called at time : 160 ns
```
</details>

## Implementation  
**Schematic:**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/4_to_16_decoder_schematic.png)

**FPGA Utilization:**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/4_to_16_decoder_utilization.png)

## Reflection

## Directory Table of Contents
<pre>
4-bit Greater-Than Comparator/
│
├── src/
│   ├── <a href="./src/decoder4_16.sv">decoder4_16.sv</a>
│   ├── <a href="./src/decoder3_8.sv">decoder3_8.sv</a>
│   └── <a href="./src/decoder2_4.sv">decoder2_4.sv</a>
│
├── sim/
│   ├── <a href="./sim/TB_decoder_4_16.sv">TB_decoder_4_16.sv</a>
│   └── <a href="./sim/TB_decoder4_16_behav.wcfg">TB_decoder4_16_behav.wcfg</a>
│
├── constraints/
│   └── <a href="./constraints/Cmod-S7-25-Master.xdc">Cmod-S7-25-Master.xdc</a>
│
└── <a href="./README.md">README.md</a>
</pre>
