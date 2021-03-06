module ins_mem 
#(parameter ADDR_WIDTH=8, parameter INS_WIDTH=9)
(
    input   [(ADDR_WIDTH-1):0]  PC_address,     // Input Address
    input clk, rEn,
    output  reg [(INS_WIDTH-1):0]  instruction    // Instruction at memory location Address
      
 );   
    
    reg [(INS_WIDTH-1):0] mem[2**ADDR_WIDTH-1:0];  // 2**ADDR_WIDTH
	
	initial
	begin
		$readmemh("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\00 - Git\\fpga-quartus\\Multi_CORE\\MULTI_CORE_edit\\ins_mem.txt",mem);
			 
	end

    always @(posedge clk) begin
        if (rEn == 1) begin
            instruction <= mem[PC_address];
        end
    end

endmodule
