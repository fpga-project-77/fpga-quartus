// Quartus Prime Verilog Template
// Single port RAM with single read/write address 

module data_mem 
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input wEn, clk, rEn,
	output [(DATA_WIDTH-1):0] mem_out
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;

	//outfile
	integer outfile;

	initial begin
		$readmemh("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\01 - Quartus\\test_data_mem\\data_mem.txt",ram);
	end

	always @ (posedge clk)
	begin
		// Write
		if (wEn) begin
			ram[addr] <= data;
			addr_reg <= addr;
			$writememh("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\01 - Quartus\\test_data_mem\\result.txt",ram);
		end
		if (rEn) begin	
			addr_reg <= addr;
		end
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign mem_out = ram[addr_reg];

endmodule