# riscv-cpu

A RISC-V compatible multicycle CPU implemented in Verilog.  
Includes FSM control, datapath, ALU, memory modules, and a full testbench with waveform validation.

---

## 🚀 Overview

This project implements a custom RISC-V CPU using a 5-stage multicycle architecture.  
It follows a clean modular structure with separate datapath and control (FSM) components.

Developed as part of the **"Low-Level Digital Hardware Systems II"** course at  
**Aristotle University of Thessaloniki (AUTh), School of Electrical & Computer Engineering**.

---

## 🧠 Key Features

- ✅ Multicycle CPU architecture with 5 FSM stages (IF, ID, EX, MEM, WB)
- 📜 Implements a meaningful subset of the **RISC-V RV32I** instruction set
- 🧮 Custom ALU and Register File modules
- 📦 Instruction memory (ROM) and data memory (RAM)
- 🔄 Clean separation between control logic (FSM) and datapath
- 🧪 Fully verified through simulation and waveform analysis using ModelSim

---

## 🛠️ Technologies Used

- **Verilog HDL**
- **ModelSim – Intel FPGA Edition**
- Manual RTL simulation and waveform debugging
- RISC-V ISA (RV32I base subset)

---

## 📂 Project Structure

```
├── datapath.v # Implements the datapath (registers, ALU, muxes, etc.)
├── fsm.v # Finite State Machine (FSM) control unit
├── alu.v # Arithmetic and logic unit
├── regfile.v # Register file module
├── imem.v # Instruction memory (ROM)
├── dmem.v # Data memory (RAM)
├── testbench.v # Full testbench with instruction sequences
└── report.pdf # Final design report (in Greek)

```


---

## 📊 Results

- All test cases passed and validated using waveform inspection
- Instructions correctly executed across the multicycle FSM
- Design correctness confirmed via control signals, data flow, and final register values

---

## ✍️ Author

**Panos Koutris**  
[pkoutris@ece.auth.gr](mailto:pkoutris@ece.auth.gr)  
Student at AUTh – School of Electrical & Computer Engineering

---

## 📎 License

This project is intended for educational and portfolio use.  
Contact me before using it commercially or in any published work.


