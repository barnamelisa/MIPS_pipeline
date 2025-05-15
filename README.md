# 🧠 MIPS 5-Stage Pipeline in VHDL

This project implements a 5-stage MIPS pipeline architecture in **VHDL**, featuring hazard detection and forwarding mechanisms for optimized instruction execution.

## 🚀 Overview

The pipeline is divided into the following stages:
1. **Instruction Fetch (IF)**
2. **Instruction Decode (ID)**
3. **Execute (EX)**
4. **Memory Access (MEM)**
5. **Write-Back (WB)**

Each stage was carefully designed and integrated to ensure efficient, streamlined instruction flow and correct data handling.

## ⚙️ Features

- ✅ Fully pipelined MIPS processor (5 stages)
- 🔁 Hazard detection logic to identify and manage data hazards
- 🔀 Forwarding unit to reduce pipeline stalls
- 🧪 Tested with a variety of MIPS instruction sets
- 📁 Modular VHDL code for each pipeline stage

## 📂 Folder Structure

```plaintext
/IF          --> Instruction Fetch Stage
/ID          --> Instruction Decode Stage
/EX          --> Execute Stage
/MEM         --> Memory Access Stage
/WB          --> Write-Back Stage
/HazardUnit  --> Hazard Detection and Forwarding
/Testbench   --> Simulation testbenches
