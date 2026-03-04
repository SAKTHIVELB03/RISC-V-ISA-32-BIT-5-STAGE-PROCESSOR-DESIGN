# RISC-V-ISA-32-BIT-5-STAGE-PROCESSOR-DESIGN

# RISC V Architecture
<img width="2237" height="1437" alt="riscv_architecture_enhanced" src="https://github.com/user-attachments/assets/1d9b9777-98e8-42d3-a55b-be44d55bb18c" />


This diagram shows the architecture of a 32-bit RV32I RISC-V processor implemented using a five-stage pipeline. The major components include the Program Counter (PC), Instruction Memory, Register File, ALU, Data Memory, and Control Unit. Instructions are fetched from instruction memory, decoded in the register file stage, executed in the ALU, optionally access data memory, and finally write results back to registers. A hazard unit is used to detect and handle data hazards in the pipeline.

# Instruction Set Architecture Format
<img width="1288" height="384" alt="3d402802-7eb9-4762-b3d7-3b545e66b0b1_enhanced" src="https://github.com/user-attachments/assets/0e65e6a2-b2e7-46db-98c8-fa80d30da603" />
<img width="1290" height="330" alt="6cd09863-baa6-49be-b418-6de4fe8c51b1_enhanced" src="https://github.com/user-attachments/assets/357661fa-6b9c-46f4-9baf-346fe6e71a7d" />



The RISC-V instruction format defines how instructions are structured in a 32-bit word. Each instruction consists of fields such as opcode, destination register (rd), source registers (rs1 and rs2), function codes (funct3 and funct7), and immediate values. These fields determine the type of operation to be performed by the processor. Different instruction formats such as R-type, I-type, S-type, B-type, U-type, and J-type are used depending on the operation.


# R Type Instructions
<img width="1280" height="548" alt="2529341c-ef6f-47d7-8106-5a1a344a70b8_enhanced" src="https://github.com/user-attachments/assets/921c4bc8-fddd-4083-9b22-6a94d768e38c" />


R-type instructions perform register-to-register operations. These instructions use two source registers and one destination register. The ALU performs arithmetic or logical operations such as ADD, SUB, AND, OR, XOR, and shift operations. The result of the computation is written back to the destination register.

# I Type Instructions
<img width="1750" height="756" alt="fdad9554-3158-401e-b15f-810ab0b1649c_enhanced" src="https://github.com/user-attachments/assets/24338818-0a11-416c-a3c4-e08b4be3a20c" />

I-type instructions perform operations that involve an immediate value. Instead of using two source registers, one operand is taken from a register and the other from a constant immediate value encoded in the instruction. Examples include ADDI, ANDI, ORI, and shift operations like SLLI and SRLI.

# S,J and L Type Instructions
<img width="1182" height="192" alt="3b5b4566-57ed-426b-81d6-866ecab8c6cc_enhanced" src="https://github.com/user-attachments/assets/e8fe5686-db9f-47ce-a25f-f10fdfbfa8dd" />

S-type instructions are used for store operations where data from a register is written to memory. J-type instructions are used for jump operations that modify the program counter to transfer control to another instruction address. L-type instructions are used for load operations where data is read from memory and stored in a register.

# B Type Instruction
<img width="910" height="404" alt="d7aebd22-6615-4248-9add-80e2729374ef_enhanced" src="https://github.com/user-attachments/assets/a206fbcd-0d84-40e6-b938-985b46382134" />

B-Type instructions in the RV32I architecture are conditional branch instructions used to alter the control flow of the program based on register comparisons. These instructions compare the values stored in two registers (rs1 and rs2) and update the Program Counter (PC) if the specified condition is satisfied. The branch target address is calculated by adding the sign-extended immediate value to the current PC.

The implemented B-type instructions include BEQ (branch if equal), BNE (branch if not equal), BLTU (branch if unsigned less than), and BGEU (branch if unsigned greater than or equal). These instructions play a critical role in implementing loops, conditional execution, and decision-making logic within the processor.

# Pipeline Stage 1 – Instruction Fetch
<img width="660" height="463" alt="image" src="https://github.com/user-attachments/assets/4078fec0-2e0d-43dc-b4fc-37184eb79972" />

In the Instruction Fetch stage, the processor retrieves the instruction from the instruction memory using the Program Counter (PC). After fetching the instruction, the PC is incremented by 4 to point to the next instruction. This stage ensures that the correct instruction enters the pipeline for further processing.


# Pipeline Stage 2 – Instruction Decode
<img width="656" height="460" alt="image" src="https://github.com/user-attachments/assets/2d0668d2-7a88-4ec5-914b-f6c6f3efcb49" />

During the Instruction Decode stage, the fetched instruction is interpreted to determine the operation type and operand locations. The register file is accessed to read the required source registers. The control unit generates control signals required for subsequent stages.

# Pipeline Stage 3 – Execution (ALU)
<img width="654" height="449" alt="image" src="https://github.com/user-attachments/assets/3c22f123-561e-4e66-9e8e-400537dd9149" />

In the Execution stage, the Arithmetic Logic Unit (ALU) performs the required arithmetic or logical operation specified by the instruction. Operations such as addition, subtraction, logical operations, shifts, and comparisons are carried out in this stage.

# Pipeline Stage 4 – Memory
<img width="671" height="455" alt="image" src="https://github.com/user-attachments/assets/c197ec05-8538-4cd4-88cb-d4bf252b0159" />

The Memory Access stage is used for load and store instructions. If the instruction requires memory access, the processor either reads data from the data memory (load) or writes data to the memory (store). Instructions that do not involve memory operations skip this stage.

# Pipeline Stage 5 – Write Back
<img width="662" height="462" alt="image" src="https://github.com/user-attachments/assets/2e67c776-0f1d-4633-bb30-2104964a491d" />

In the Write Back stage, the result produced by the ALU or the data retrieved from memory is written back into the destination register of the register file. This completes the execution of the instruction.

# Data Hazard in Pipeline
<img width="667" height="453" alt="image" src="https://github.com/user-attachments/assets/d3dfbd0a-a645-447c-915f-e06bb77a0709" />

A data hazard occurs when an instruction depends on the result of a previous instruction that has not yet completed execution. Techniques such as forwarding and pipeline stalling are used to resolve these hazards and maintain correct program execution.

# Load Word Hazard Handling
<img width="669" height="457" alt="image" src="https://github.com/user-attachments/assets/b3c95554-04e9-4921-9083-e70ae36cc263" />

Load word hazards occur when an instruction immediately following a load instruction requires the loaded data. Since the data becomes available only after the memory access stage, the pipeline is stalled for one cycle to ensure correct data availability.

# Control Hazard
<img width="666" height="463" alt="image" src="https://github.com/user-attachments/assets/9d4adfdf-c40e-4f60-b421-204827781a83" />

Control hazards occur due to branch or jump instructions that change the flow of execution. To handle this, instructions that have already entered the pipeline after the branch may be flushed if the branch condition is satisfied.

# Schematic Diagram
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5a1ac52e-bbdd-4af3-a664-35c81284af1c" />




