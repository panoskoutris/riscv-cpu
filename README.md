# riscv-cpu

A fully functional RISC-V compatible multicycle CPU built in Verilog.  
Implements a five-stage FSM controller, datapath, ALU, register file, and memory interface, with complete testbenches for simulation and verification.

## 🚀 Overview

This project was developed as part of the **Digital Hardware Systems I** (Ψηφιακά HW 1) course at the **Aristotle University of Thessaloniki** (AUTH), School of Electrical & Computer Engineering.

The goal was to implement a simplified but realistic **RISC-V processor**, built incrementally from core components like the ALU and register file, up to a complete multicycle CPU architecture with instruction and data memory.

## 🛠️ Technologies Used

- **Verilog HDL** – Hardware description and module design
- **FSM Design** – Finite State Machine for multicycle control
- **Modular Architecture** – ALU, register file, datapath, controller
- **Simulation & Debugging** – Custom testbenches for functional verification
- **RISC-V ISA** – Instruction decoding and execution

---

## 📦 Features

### ✅ Instruction Support
Implements core RISC-V instructions:
- **Register-Register:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT`, `SLL`, `SRL`, `SRA`
- **Immediate:** `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLLI`, `SRLI`, `SRAI`
- **Memory:** `LW`, `SW`
- **Branch:** `BEQ`

### ✅ Components

| Module         | Description |
|----------------|-------------|
| `alu.v`        | 32-bit ALU with support for arithmetic, logical, and shift operations |
| `calc.v`       | Calculator with a 16-bit accumulator using the ALU |
| `calc_enc.v`   | Logic encoder to generate `alu_op` control signals from buttons |
| `regfile.v`    | 32x32-bit Register File with 2 read ports, 1 write port |
| `datapath.v`   | Full RISC-V datapath including PC, ALU, immediate generator, memory interface |
| `top_proc.v`   | Top-level processor module with FSM controller (5 stages: IF, ID, EX, MEM, WB) |
| `*_tb.v`       | Testbenches for simulation and validation of all modules |

---

## 🧪 Simulation & Results

- **ALU and Calculator** are tested using a variety of input combinations.
- **FSM CPU Execution** is verified using an instruction ROM and RAM, observing program counter, memory addresses, and write-back data.
- Waveforms and output logs confirm correct instruction decoding, branching, and memory access.
- Results included in [`report/Αναφορά.pdf`](./report/Αναφορά.pdf).

---

## 🗂️ Repository Structure

```
riscv-cpu/
├── alu.v
├── calc.v
├── calc_enc.v
├── calc_tb.v
├── regfile.v
├── datapath.v
├── top_proc.v
├── top_proc_tb.v
├── report.pdf                
└── README.md

```

---

## 📈 What I Learned

- Designing **modular digital systems** using Verilog
- Applying **FSMs** for multicycle CPU control
- Understanding **instruction decoding** and datapath flow
- Creating thorough **testbenches** and debugging using simulation waveforms
- Mapping **theoretical ISA concepts** to real hardware implementations

---

## 👤 Author

**Παναγιώτης Κούτρης**   
Email: *[your.email@example.com]* (optional)  
School of Electrical & Computer Engineering, AUTH

---

## 📝 License
This project is provided for academic and educational purposes only.


