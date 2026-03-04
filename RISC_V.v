`timescale 1ns / 1ns

module RISC_V(
                    
				input reset,
                input clk,
                input I_Req,            //interrupt request
                input [31:0] Rdata,  // data read from data memory
                input [31:0] inst_data,   // data from instruction memory
                output [31:0] inst_addr,  // address to instruction memory
                output [31:0] Data_addr,  // address to data memory
                output [31:0] Wdata, // data to be written to data memory
                output [3:0] we,      // write enable signal for each byte of the word
                // Additional outputs for debugging
                output [31:0] reg31,
                output reg [31:0] PC,
	            output reg IACK //interrupt acknowledge 
                                                   
											   	);     		
			
wire [31:0] inst_data_sig;
wire [31:0] PC_branch;
wire [31:0] PC_plus4;
wire PCsrc;
wire stalling;
wire invalid;

assign inst_data_sig = inst_data;
assign PC_plus4 = PC + 4;
assign inst_addr = PC;

reg invalid2 ;

//Update PC only if there is no stalling 
always @(posedge clk or posedge reset ) begin
		if (reset)
		begin
			PC <= 32'h00000000;
			IACK <= 0;		   
		end
		else begin
			if (~(stalling)) begin
				PC <= PCsrc ? PC_branch :PC_plus4;
				IACK <= I_Req;
			end
		end						
end

wire [31:0] PC_ID;
wire [31:0] inst_data_ID;
wire IACK_ID;
  
// IF_ID stage

IF_ID if_id_stage(
					.clk(clk),
                    .reset(reset),
					.stalling((stalling || PCsrc )), // stall in case of branch taken or in data hazards 
					.PC_in(PC),
					.inst_data_in(inst_data_sig),
					.ACK_in(IACK),
					.ACK_out(IACK_ID),
					.PC_out(PC_ID),
					.inst_data_out(inst_data_ID)
																		);
							
wire [1:0] alusrc;
wire memtoreg;
wire  regwrite;
wire [3:0] memwrite;
wire [2:0] branch;
wire [1:0] aluop;
wire [1:0] regin;
wire [2:0] imm;
wire opinvalid;
wire [3:0] mul_div_op;

wire [1:0] ALUsrc_EX;
wire memtoreg_EX;
wire  regwrite_EX;
wire [3:0] memwrite_EX;
wire [2:0] branch_EX;
wire [1:0] ALUop_EX;
wire [1:0] regin_EX;
wire opinvalid_EX;
wire IACK_EX;

//Control Unit

Control_Unit CONTROL(
	   					.inst_data(inst_data_ID),
							.alusrc(alusrc),
							.memtoreg(memtoreg),
							.regwrite(regwrite),
							.memwrite(memwrite),
							.branch(branch),
							.aluop(aluop),
							.regin(regin),
							.imm(imm),
							.mul_div_op(mul_div_op),
							.opinvalid(opinvalid)
																	);
					
wire [31:0]memtoregdata;
wire [31:0] indataforreg;
wire [31:0] data_to_reg;
wire [31:0]datawire1;
wire [31:0]datawire2;
wire [31:0]datawire1_EX;
wire [31:0]datawire2_EX;
wire regwrite_WB;
wire [31:0] inst_data_WB;
wire invalid_WB;
wire [3:0] mul_div_op_outwire;

// Register File

RegFile regfile(

							.rs1(inst_data_ID[19:15]),
							.rs2(inst_data_ID[24:20]),
							.rd(invalid_WB ? 5'b11000 : inst_data_WB[11:7]),
							.Wdata( data_to_reg),
							.we(regwrite_WB),
							.clk(clk),
							.rdata1(datawire1),
							.rdata2(datawire2),
							.reg31(reg31)
		
																);				
wire [31:0] immgen;
wire [31:0] immgen_EX;
wire [31:0] PC_EX;
wire [31:0] inst_data_EX;

wire memread_EX;

assign memread_EX = (inst_data_EX[6:0]==7'b0000011);

Staller hazard_detection_unit(

	             	.MemRead_EX(memread_EX),
	             	.inst_data_EX(inst_data_EX),
	             	.inst_data_ID(inst_data_ID),
	             	.Staller(stalling)
	                                       
													    	);

				
ImmGen immegen(
		             .imm(imm),
		             .inst_data(inst_data_ID),
		             .immgen(immgen)
		                                       );
			
reg PCsrc2;

// making  signals zero for bubbling instructions in case of data or control hazards
ID_EX id_ex_stage(


           			.clk(clk),
                                .reset(reset),
	           		.regin_in((stalling || PCsrc || PCsrc2|| invalid || invalid2) ? 2'b0 : regin), //do the flush behaviour
	           		.branch_in((stalling || PCsrc|| PCsrc2|| invalid|| invalid2) ? 3'b0 : branch),
	           		.memtoreg_in((stalling || PCsrc||  PCsrc2|| invalid|| invalid2) ? 1'b0 : memtoreg),
	           		.ALUop_in((stalling || PCsrc||  PCsrc2|| invalid|| invalid2) ? 2'b0 : aluop),
	           		.ALUsrc_in((stalling || PCsrc||  PCsrc2|| invalid|| invalid2) ? 2'b0 : alusrc),
	           		.regwrite_in((stalling || PCsrc||  PCsrc2|| invalid || invalid2) ? 1'b0 : regwrite),
	           		.memwrite_in((stalling || PCsrc|| PCsrc2|| invalid || invalid2) ? 4'b0 : memwrite),
	           		.rdata1_in((stalling || PCsrc||  PCsrc2|| invalid || invalid2) ? 32'b0 :datawire1),
	           		.rdata2_in((stalling || PCsrc||  PCsrc2||invalid || invalid2) ? 32'b0 :datawire2),
						   .mul_div_op_in((stalling || PCsrc||  invalid || invalid2) ? 4'b1111 :mul_div_op),
					    	.mul_div_op_out(mul_div_op_outwire),
	           		.rdata1_out(datawire1_EX),
	           		.rdata2_out(datawire2_EX),
		           	.immgen_in(immgen),
		           	.immgen_out(immgen_EX),
		           	.regin_out(regin_EX),
		           	.branch_out(branch_EX),
		           	.memtoreg_out(memtoreg_EX),
		           	.ALUop_out(ALUop_EX),
		           	.ALUsrc_out(ALUsrc_EX),
		           	.regwrite_out(regwrite_EX),
		           	.memwrite_out(memwrite_EX),
		           	.PC_in(PC_ID),
		           	.PC_out(PC_EX),
		           	.inst_data_in(inst_data_ID),
	           		.inst_data_out(inst_data_EX),
		           	.opinvalid_in((stalling || PCsrc|| PCsrc2|| invalid || invalid2) ? 1'b0 : opinvalid),
		           	.opinvalid_out(opinvalid_EX),
		           	.ACK_in(IACK_ID),
		           	.ACK_out(IACK_EX)
						
						
	           	           	           	           		);		

wire [3:0] alucon;
wire [31:0] inst_data_MEM;
wire  regwrite_MEM;

ALU_Control alucontrol(

	   	           		.aluop(ALUop_EX),
			           		.funct7(inst_data_EX[31:25]),
		           			.funct3(inst_data_EX[14:12]),
		           			.alu_contrl(alucon)
		
		
	           			           			           		);

wire zero;
wire [31:0] aluoutdata;
wire [31:0] PC_plus4_EX;

wire [1:0] forward1, forward2;

// Forwarding unit
Forwarding_Unit FU(

		                 	.inst_data_EX(inst_data_EX),
		                 	.inst_data_MEM(inst_data_MEM),
		                 	.inst_data_WB(inst_data_WB),
		                 	.regwrite_MEM(regwrite_MEM),
		                 	.regwrite_WB(regwrite_WB),
		                 	.forward1(forward1),
		                 	.forward2(forward2)
								
                                                		);
				
wire [31:0] rdata1_forEX, rdata2_forEX;
wire [31:0] aluoutdata_MEM;

wire [31:0] PC_plus4_MEM;
wire [31:0] immgen_MEM;

wire memtoreg_MEM;
wire invalid_MEM;

wire [3:0] memwrite_MEM;
wire [1:0] regin_MEM;
wire [31:0]datawire2_MEM;

assign rdata1_forEX = (forward1 == 2'b10) ? ( (inst_data_MEM[6:0]==7'b0110111 ) ? immgen_MEM : aluoutdata_MEM ):
						(forward1 == 2'b01) ? data_to_reg : datawire1_EX;
						
assign rdata2_forEX = (forward2 == 2'b10) ? aluoutdata_MEM:
						(forward2 == 2'b01) ? data_to_reg: datawire2_EX;
												
wire diff; 

assign diff = (inst_data_EX[6:0]==7'b0010011) ? 1'b1 :  1'b0;
						
// Arithmetic Logic Unit
ALU alu(
				.in1(ALUsrc_EX[1] ? PC_EX : rdata1_forEX),
				.in2(ALUsrc_EX[0] ? immgen_EX : rdata2_forEX),
				.alu_contrl(alucon),
				.diff(diff),
				.out(aluoutdata),
				.zero(zero)
												);
		
// Program Counter and it handle control hazards 
PC ProgCount(

					.PC(PC_EX),
					.immgen(immgen_EX),
					.branch(branch_EX),
					.invalid(invalid),
					.zero(zero),
					.alu_out(aluoutdata),
					.PC_plus4(PC_plus4_EX),
					.PC_next(PC_branch),
					.PCsrc(PCsrc)
					
											);
			
wire [31:0] mul_div_result;

Mult_Div_Unit mul_div_unit (


                                        .operand1((forward1==0) ? datawire1_EX : rdata1_forEX),
			    	  	.operand2((forward2==0) ? datawire2_EX : rdata2_forEX),
			    		.mul_div_op(mul_div_op_outwire),
			    		.Result(mul_div_result)
 
                                       );		
			
		
// If any control hazard takes place, two instructions need to be bubbled

always@(posedge clk)begin
  PCsrc2<=PCsrc;
  invalid2<=invalid;
end	
											 
// EX_MEM stage

assign invalid = opinvalid_EX || IACK_EX; 																		
																	
EX_MEM ex_mem_stage(

							  	.clk(clk),
                                                                .reset(reset),
							  	.memtoreg_in(memtoreg_EX),
							  	.regwrite_in(regwrite_EX),
							  	.memwrite_in(memwrite_EX),
							  	.ALUout_in(aluoutdata),
							  	.rdata2_in(rdata2_forEX),
							  	.rdata2_out(datawire2_MEM),
								.ALUout_out(aluoutdata_MEM),
								.memwrite_out(memwrite_MEM),
								.regwrite_out(regwrite_MEM),
								.memtoreg_out(memtoreg_MEM),
								.immgen_in(immgen_EX),
								.immgen_out(immgen_MEM),
								.regin_in(regin_EX),
								.regin_out(regin_MEM),
								.PC_plus4_in(PC_plus4_EX),
								.PC_plus4_out(PC_plus4_MEM),
								.inst_data_in(inst_data_EX),
								.inst_data_out(inst_data_MEM),
								.invalid_in(invalid),
								.invalid_out(invalid_MEM)
								  
								  
									 								 	);
				
// Handling SW, SH, SB

assign we = (memwrite_MEM == 4'b1111 && Data_addr[1:0]== 2'b00) ? 4'b1111: //SW
				(memwrite_MEM == 4'b0011 && Data_addr[1:0]== 2'b00) ? 4'b0011: //SH 1s half
				(memwrite_MEM == 4'b0011 && Data_addr[1:0]== 2'b10) ? 4'b1100: //SH 2nd half
				(memwrite_MEM == 4'b0001 && Data_addr[1:0]== 2'b00) ? 4'b0001: //SB 1s byte
				(memwrite_MEM == 4'b0001 && Data_addr[1:0]== 2'b01) ? 4'b0010: //SB 2nd byte
				(memwrite_MEM == 4'b0001 && Data_addr[1:0]== 2'b10) ? 4'b0100: //SB 3rd byte
				(memwrite_MEM == 4'b0001 && Data_addr[1:0]== 2'b11) ? 4'b1000: 4'b0000; //SB 4th byte

assign Wdata = (memwrite_MEM == 4'b0000) ? datawire2_MEM : (datawire2_MEM << Data_addr[1:0] * 8) ;
assign Data_addr = reset? 32'b0 : aluoutdata_MEM;

wire [31:0] aluoutdata_WB;
wire [31:0] PC_plus4_WB;
wire [31:0] immgen_WB;
wire [31:0] Data_addr_WB;
wire memtoreg_WB;
wire [1:0] regin_WB;
wire [31:0]Rdata_WB;

// MEM_WB interface

MEM_WB memwb(
		.clk(clk),
                .reset(reset),
		.memtoreg_in(memtoreg_MEM),
		.regwrite_in(regwrite_MEM),
		.ALUout_in(aluoutdata_MEM),
		.Rdata_in(Rdata),
		.immgen_in(immgen_MEM),
		.PC_plus4_in(PC_plus4_MEM),
		.regin_in(regin_MEM),
		.inst_data_in(inst_data_MEM),
		.Data_addr_in(Data_addr),
		.Data_addr_out(Data_addr_WB),
		.inst_data_out(inst_data_WB),
		.regin_out(regin_WB),
		.PC_plus4_out(PC_plus4_WB),
		.immgen_out(immgen_WB),
		.ALUout_out(aluoutdata_WB),
		.Rdata_out(Rdata_WB),
		.memtoreg_out(memtoreg_WB),
		.regwrite_out(regwrite_WB),
		.invalid_in(invalid_MEM),
		.invalid_out(invalid_WB)
		);
		
assign memtoregdata = memtoreg_WB ? Rdata_WB :
                      (inst_data_WB[6:0] == 7'b0110011 && inst_data_WB[31:25] ==7'b0000001)? mul_div_result : aluoutdata_WB;
							 							 													 
// Handling LW, LH, LB
							 
assign indataforreg = (memtoreg_WB && (inst_data_WB[14:12] == 3'b001 || inst_data_WB[14:12] == 3'b101)) ? ((memtoregdata >> (Data_addr_WB[1:0] * 8)) & 32'h0000FFFF) :
							 (memtoreg_WB && (inst_data_WB[14:12] == 3'b000 || inst_data_WB[14:12] == 3'b100)) ? ((memtoregdata >> (Data_addr_WB[1:0] * 8)) & 32'h000000FF) : memtoregdata;
							 				
 // in case of interrupt or exception, pc+4 should be saved							 
assign data_to_reg = (regin_WB == 2'b00) ? immgen_WB :
						 (regin_WB == 2'b01) ? indataforreg :
						 (regin_WB == 2'b10 || invalid_WB) ? PC_plus4_WB : indataforreg ;						 
						 
endmodule

