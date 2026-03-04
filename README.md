# RISC-V-ISA-32-BIT-5-STAGE-PROCESSOR-DESIGN

# RISC V Architecture
<img width="1046" height="664" alt="image" src="https://github.com/user-attachments/assets/861db3e7-6f52-4bcb-b340-3d3fd3bf4bb9" />

This diagram shows the architecture of a 32-bit RV32I RISC-V processor implemented using a five-stage pipeline. The major components include the Program Counter (PC), Instruction Memory, Register File, ALU, Data Memory, and Control Unit. Instructions are fetched from instruction memory, decoded in the register file stage, executed in the ALU, optionally access data memory, and finally write results back to registers. A hazard unit is used to detect and handle data hazards in the pipeline.

# Instruction Set Architecture Format
<img width="1017" height="668" alt="image" src="https://github.com/user-attachments/assets/4565ab49-96a1-406d-8361-4c444abc0334" />


The RISC-V instruction format defines how instructions are structured in a 32-bit word. Each instruction consists of fields such as opcode, destination register (rd), source registers (rs1 and rs2), function codes (funct3 and funct7), and immediate values. These fields determine the type of operation to be performed by the processor. Different instruction formats such as R-type, I-type, S-type, B-type, U-type, and J-type are used depending on the operation.


# R Type Instructions
<img width="897" height="443" alt="image" src="https://github.com/user-attachments/assets/68eb8c4c-afe9-4c53-89f8-c96a8eae359d" />

R-type instructions perform register-to-register operations. These instructions use two source registers and one destination register. The ALU performs arithmetic or logical operations such as ADD, SUB, AND, OR, XOR, and shift operations. The result of the computation is written back to the destination register.

# I Type Instructions
I-type instructions perform operations that involve an immediate value. Instead of using two source registers, one operand is taken from a register and the other from a constant immediate value encoded in the instruction. Examples include ADDI, ANDI, ORI, and shift operations like SLLI and SRLI.

# S,J and L Type Instructions
S-type instructions are used for store operations where data from a register is written to memory. J-type instructions are used for jump operations that modify the program counter to transfer control to another instruction address. L-type instructions are used for load operations where data is read from memory and stored in a register.

# Pipeline Stage 1 – Instruction Fetch
In the Instruction Fetch stage, the processor retrieves the instruction from the instruction memory using the Program Counter (PC). After fetching the instruction, the PC is incremented by 4 to point to the next instruction. This stage ensures that the correct instruction enters the pipeline for further processing.


# Pipeline Stage 2 – Instruction Decode
During the Instruction Decode stage, the fetched instruction is interpreted to determine the operation type and operand locations. The register file is accessed to read the required source registers. The control unit generates control signals required for subsequent stages.

# Pipeline Stage 3 – Execution (ALU)
In the Execution stage, the Arithmetic Logic Unit (ALU) performs the required arithmetic or logical operation specified by the instruction. Operations such as addition, subtraction, logical operations, shifts, and comparisons are carried out in this stage.

# Pipeline Stage 4 – Memory
The Memory Access stage is used for load and store instructions. If the instruction requires memory access, the processor either reads data from the data memory (load) or writes data to the memory (store). Instructions that do not involve memory operations skip this stage.

# Pipeline Stage 5 – Write Back
In the Write Back stage, the result produced by the ALU or the data retrieved from memory is written back into the destination register of the register file. This completes the execution of the instruction.

# Data Hazard in Pipeline
A data hazard occurs when an instruction depends on the result of a previous instruction that has not yet completed execution. Techniques such as forwarding and pipeline stalling are used to resolve these hazards and maintain correct program execution.

# Load Word Hazard Handling
Load word hazards occur when an instruction immediately following a load instruction requires the loaded data. Since the data becomes available only after the memory access stage, the pipeline is stalled for one cycle to ensure correct data availability.

# Control Hazard
Control hazards occur due to branch or jump instructions that change the flow of execution. To handle this, instructions that have already entered the pipeline after the branch may be flushed if the branch condition is satisfied.

# Schematic Diagram
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5a1ac52e-bbdd-4af3-a664-35c81284af1c" />




