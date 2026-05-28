# 4-Bit Greater Than Comparator
<u>**Description:**</u> This project consists of a 4-bit greater-than comparator written in RTL using only gate-level logical operators. The 4-bit greater-than comparator accepts two 4-bit inputs and outputs 1 if input A is greater than B, and 0 if A is not greater than B. 

The 4-bit comparator is composed of two 2-bit greater-than comparator modules and one 2-bit equal-to module joined using a minimal number of logic gates. 

Each module was verified with a self-checking testbench that iterated through all possible input combinations to ensure rigorous correctness.

The bitfile was flashed to a CMOD S7 FPGA board. To interface with the FPGA, 8 DIP-switches were wired to accept the inputs and an external LED was wired to output the result.

<u>**Block Diagram**</u>  
<br>
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/greater_4bit_block_diagram.jpg)  
*The 4-bit greater-than comparator accepts two 4-bit inputs (called A and B). The most significant bits of the inputs are fed into both the MSB greater-than comparator and the MSB equal-to comparator. The least significant bits of the inputs are fed into the LSB greater-than comparator.*

*The outputs of these comparators are joined with glue logic, outputting from the 4-bit module a 1 if A is greater than B, and 0 if A is not greater than B.*

<u>**Schematic**</u>  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/greater_4bit_schematic.png)

### <u>Directory Table of Contents</u>
<pre>
4-bit Greater-Than Comparator/
│
├── src/
│   ├── <a href="./src/greater_4bit_top.sv">greater_4bit_top.sv</a>
│   ├── <a href="./src/greater_2bit.sv">greater_2bit.sv</a>
│   └── <a href="./src/equal_2bit.sv">equal_2bit.sv</a>
│
├── sim/
│   ├── <a href="./sim/TB_greater_4bit.sv">TB_greater_4bit.sv</a>
│   └── <a href="./sim/TB_greater_4bit_behav.wcfg">TB_greater_4bit_behav.wcfg</a>
│
├── constraints/
│   └── <a href="./constraints/Cmod-S7-25-Master.xdc">Cmod-S7-25-Master.xdc</a>
│
└── <a href="./README.md">README.md</a>
</pre>
