`timescale 1ns / 1ns

module DataMem(

                     input clk,
                     input [31:0] Data_addr,
                     input [31:0] Wdata,
                     input [3:0] we,		
                     output reg [31:0] Rdata
        
		                                      );
		 		 		 
    reg [7:0] memory [2**16-1:0];
    reg [31:0] add0,add1,add2,add3;
	 			 	 	
    always @(posedge clk) begin	 
        if (we[0]==1)		  
          memory[add0] <= Wdata[7:0];				
        if (we[1]==1)		  
          memory[add1] <= Wdata[15:8];				
        if (we[2]==1)		  
          memory[add2] <= Wdata[23:16];				
        if (we[3]==1)		  
          memory[add3] <= Wdata[31:24];
    end
		
	always@(*) begin 	  
	  add0 = (Data_addr & 32'h0000fffc) + 32'h00000000;
	  add1 = (Data_addr & 32'h0000fffc) + 32'h00000001;
	  add2 = (Data_addr & 32'h0000fffc) + 32'h00000002;
	  add3 = (Data_addr & 32'h0000fffc) + 32'h00000003; 	  
	   Rdata ={memory[add3],memory[add2],memory[add1],memory[add0]};	 	   
	end	 
	
endmodule

