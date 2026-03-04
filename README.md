# RISC-V-ISA-32-BIT-5-STAGE-PROCESSOR-DESIGN

#RISC V Architecture
<img width="2481" height="1754" alt="rv32_architecture" src="https://github.com/user-attachments/assets/eef47d7a-4b63-4f69-b69c-68a00dcd785e" />

This diagram shows the architecture of a 32-bit RV32I RISC-V processor implemented using a five-stage pipeline. The major components include the Program Counter (PC), Instruction Memory, Register File, ALU, Data Memory, and Control Unit. Instructions are fetched from instruction memory, decoded in the register file stage, executed in the ALU, optionally access data memory, and finally write results back to registers. A hazard unit is used to detect and handle data hazards in the pipeline.

#Instruction Set Architecture Format
<img width="2481" height="1755" alt="isa_format_table" src="https://github.com/user-attachments/assets/33d8c831-a41a-413b-a52f-a1e987486bce" />

The RISC-V instruction format defines how instructions are structured in a 32-bit word. Each instruction consists of fields such as opcode, destination register (rd), source registers (rs1 and rs2), function codes (funct3 and funct7), and immediate values. These fields determine the type of operation to be performed by the processor. Different instruction formats such as R-type, I-type, S-type, B-type, U-type, and J-type are used depending on the operation.

# Schematic Diagram
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5a1ac52e-bbdd-4af3-a664-35c81284af1c" />




