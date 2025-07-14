# riscv-cpu

A fully functional RISC-V compatible multicycle CPU built in Verilog.  
Implements a five-stage FSM controller, datapath, ALU, register file, and memory interface, with complete testbenches for simulation and verification.

## 🚀 Overview

The goal was to implement a simplified but realistic **RISC-V processor**, built incrementally from core components like the ALU and register file, up to a complete multicycle CPU architecture with instruction and data memory.


This project was developed as part of the ** Low-Level Digital HW Systems I** course at the **Aristotle University of Thessaloniki** (AUTH), School of Electrical & Computer Engineering.

## 🛠️ Resources Used

- **Verilog HDL** – Hardware description and module design
- **Tools & Simulators** – EDA Playground & Icarus Verilog 12.0 
- **Instruction Set Architecture** - RISC-V Instruction Set Manual, Volume I: Unprivileged ISA, Document Version 20191213

---

## 📦 Features

### ✅ Instruction Support
Implements core RISC-V instructions:
- **Register-Register:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT`, `SLL`, `SRL`, `SRA`
- **Immediate:** `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLLI`, `SRLI`, `SRAI`
- **Memory:** `LW`, `SW`
- **Branch:** `BEQ`

### ✅ Components

## 📦 Components

| Module             | Description |
|--------------------|-------------|
| `alu.v`            | 32-bit ALU with support for arithmetic, logical, and shift operations |
| `calc.v`           | Calculator with a 16-bit accumulator using the ALU |
| `calc_enc.v`       | Logic encoder to generate `alu_op` control signals from buttons |
| `regfile.v`        | 32×32-bit Register File with 2 read ports, 1 write port |
| `datapath.v`       | Full RISC-V datapath including PC, ALU, immediate generator, memory interface |
| `top_proc.v`       | Top-level processor module with FSM controller (5 stages: IF, ID, EX, MEM, WB) |
| `ram.v`            | Simple RAM module used for data memory |
| `rom.v`            | ROM module used for instruction memory |
| `rom_bytes.data`   | ROM initialization file with encoded RISC-V instructions |
| `*_tb.v`           | Testbenches for simulation and validation of all modules |


---

## 🧪 Simulation & Results

- **ALU and Calculator** are tested using a variety of input combinations.
- **FSM CPU Execution** is verified using an instruction ROM and RAM, observing program counter, memory addresses, and write-back data.
- Waveforms and output logs confirm correct instruction decoding, branching, and memory access.
- Results included in [`report.pdf`](./report.pdf).

---

## 🗂️ Repository Structure

```
riscv-cpu/
├── alu.v # Arithmetic Logic Unit (ALU)
├── calc.v # Calculator with 16-bit accumulator
├── calc_enc.v # Encoder for ALU control signals
├── calc_tb.v # Testbench for the calculator module
├── datapath.v # RISC-V datapath
├── ram.v # Data memory module
├── regfile.v # 32-register file module
├── report.pdf # Final report with results, waveforms, FSM diagram
├── rom.v # Instruction memory module
├── rom_bytes.data # Memory initialization file for ROM
├── top_proc.v # Top-level module with FSM controller
├── top_proc_tb.v # Full system testbench
└── README.md # Project description and documentation

```
---

## ✍️ Author

**Panos Koutris**  
[pkoutris@ece.auth.gr](mailto:pkoutris@ece.auth.gr)  
Student at AUTh – School of Electrical & Computer Engineering

---

## 📝 License
This project is provided for academic and educational purposes only.


