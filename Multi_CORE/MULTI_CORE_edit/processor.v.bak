module processor 
# (WIDTH = 8)
(
    input clk;
);

reg [(WIDTH)-1:0] INS;  //iROM output 
reg [(WIDTH)-1:0] PC_addr;
reg [(WIDTH)-1:0] MEMWRITE_data;  //writing data to dram
reg [(WIDTH)-1:0] DRAM_addr;    //dram accessing memory location address
reg [(WIDTH)-1:0] MEMREAD_data; //dram output

reg iROMREAD;
reg memWRITE;
reg memREAD;

//instruction memory
ins_mem #(.ADDR_WIDTH(WIDTH), .INS_WIDTH(WIDTH)) ins_mem(.instruction(INS), .PC_address(PC_addr), .clk(clk), .rEn(iROMREAD));

//data memory
data_mem #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(WIDTH)) dt_mem(.data(DRAM_dataIn), .addr(DRAM_addr), .wEn(memWRITE), .clk(clk), .mem_out(DRAM_dataOut), .rEn(memREAD));

core #(.WIDTH(WIDTH)) CORE_0(.Clk(clk), .IROM_dataIn(INS), .DRAM_dataIn(MEMREAD_data), .DRAM_dataOut(MEMWRITE_data), 
                            .IROM_addr(PC_addr), .DRAM_addr(DRAM_addr),.memREAD(memREAD), .memWRITE(memWRITE), .iROMREAD(iROMREAD));

endmodule