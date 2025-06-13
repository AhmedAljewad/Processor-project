# Processor Project

**Authors:** Ahmed Aljewad & Logan Black

## Overview

This project implements a simple six-instruction programmable processor using SystemVerilog. The design is meant for the DE2 FPGA development board. It features a top-level processor module that integrates a Control Unit and Datapath, designed using a top-down approach and implemented bottom-up.

## Processor Architecture

### Top-Level Modules

- **Processor:** Instantiates Control Unit and Datapath modules.

### Module Functionality and Interaction

The processor design is composed of two main blocks: the Controller and the Datapath, which communicate through well-defined control and data signals.

#### Control Unit

- **Program Counter (PC):** Keeps track of the current instruction address and increments each cycle unless cleared or halted.

- **Instruction Register (IR):** Holds the current instruction fetched from instruction memory.

- **State Machine:** Acts as the control unit's brain. It generates control signals that sequence the processor through instruction fetch, decode, execute, memory access, and write-back stages. It determines register file addresses, ALU operations, memory read/write enables, and controls program flow.

The Controller outputs signals such as `RF_W_addr`, `RF_W_en`, `RF_Ra_addr`, `RF_Rb_addr` to manage register file reads/writes, as well as `Alu_s0` to select ALU operations.

#### Datapath

- **Register File (RF):** A 16-register, 16-bit wide storage that supports simultaneous reads from two registers (`Ra_addr`, `Rb_addr`) and writes to a register (`W_addr`).

- **ALU:** Performs arithmetic and logic operations on two 16-bit inputs from the register file, controlled by the ALU select signal (`Alu_s0`) from the Controller.

- **Data Memory (D):** 256 x 16-bit memory module used for data load/store instructions. It is accessed via address and write-enable signals controlled by the Controller.

- **Multiplexer:** Selects the appropriate data source for writing back to the register file, either from the ALU or Data Memory.

#### Interaction Flow

1. The Program Counter (PC) provides the instruction address to fetch the instruction into the Instruction Register (IR).

2. The State Machine decodes the instruction and sets control signals accordingly.

3. Register addresses for reading (`Ra_addr`, `Rb_addr`) and writing (`W_addr`) are sent to the Register File, which outputs operand data.

4. The ALU performs the required computation using operands from the Register File, controlled by ALU operation signals.

5. Depending on the instruction, the Data Memory is accessed for load/store operations.

6. Results from the ALU or Data Memory are routed back to the Register File via the multiplexer for writing.

7. The State Machine orchestrates the sequencing of all these operations ensuring correct data flow and timing.

This modular separation and clear control flow enable easy debugging, maintenance, and extension of the processor design.

### Architecture Diagrams

**Fig 1: Processor Module Hierarchy (Top-down design)**
![Processor Module Hierarchy](https://github.com/user-attachments/assets/77f393b8-db34-4324-ac9b-02fc0bfa00d1)

**Fig 2: Detailed Processor Block Diagram**
![Detailed Processor Block Diagram](https://github.com/user-attachments/assets/d12006e1-3b33-4bb7-9563-1707fff4ea2a)

## Project Structure
processor-project/
├── processor/                      # Final processor and support modules
│   ├── alu.sv
│   ├── buttonsync.sv
│   ├── controlunit.sv
│   ├── datapath.sv
│   ├── decoder.sv
│   ├── dmif.mif
│   ├── fsm.sv
│   ├── imif.mif
│   ├── IR.sv
│   ├── keyfilter.sv
│   ├── mux2to1.sv
│   ├── mux16w8to1.sv
│   ├── PC.sv
│   ├── processor.sv
│   ├── ram.v
│   ├── registerfile.sv
│   ├── rom.v
│   └── testprocessor.sv           # Standalone testbench for full processor
├── TestControlUnit/               # Unit testing of control-related modules
│   ├── Full Control Unit/         # Full control unit and testbench
│   │   └── controlunit.sv         # (contains control + testbench)
│   ├── fsm/                       # FSM + FSM TB
│   │   └── fsm.sv
│   ├── IR/                        # Instruction Register + TB
│   │   └── IR.sv
│   └── PC/                        # Program Counter + TB
│       └── PC.sv
└── TestDatapath/                  # Unit testing of datapath components
    ├── Full Datapath/             # Full datapath test
    │   └── datapath.sv
    ├── RegALU/                    # ALU + Register File testing
    │   └── RegAlU.sv              # Contains both modules + TB
    ├── RegisterFile/              # Register File testing
    │   └── RegisterFile.sv
    └── RegRAM/                    # RF + RAM test
        └── RegRam.sv
## Getting Started

### Prerequisites

- **Quartus Prime** for FPGA synthesis and programming
- **ModelSim** for simulation and verification

### Compilation and Simulation

1. Open Quartus project (`project.qpf`) in Quartus Prime
2. Compile the project to generate the FPGA programming file

**To simulate:**
1. Open ModelSim
2. Load the testbench file `testProcessor.sv` (provided)
3. Run `do runrtl.do` to compile all necessary files and run simulation
4. Use `wave.do` to load waveform configuration

### FPGA Programming

1. Use the `.sof` file generated from Quartus compilation to program the DE2 board
2. The top-level module is `Project.sv`, which instantiates the processor module and interfaces with DE2 board inputs and outputs
3. Use `KEY[2]` as the system clock, `KEY[1]` as synchronous reset

## Usage

- **Switches SW[17:15]:** Select what is displayed on HEX7-4 (e.g., PC, current state, ALU inputs/outputs)
- **HEX3-0:** Always display the current instruction register contents
- Internal signals like program counter, FSM state, ALU inputs and outputs are exposed for debugging

## References

- Course: TCES 330 Spring 2025, Programmable Processor Project
- DE2 FPGA Development Board User Manual
- Quartus Prime and ModelSim Documentation
