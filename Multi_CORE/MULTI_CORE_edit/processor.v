module processor 
# (parameter WIDTH = 8)
(
    input clk,
    output proc_state
);
// wire clk = CLOCK_50;
wire [(WIDTH)-1:0] INS;                                             //iROM output  
wire [(WIDTH)-1:0] PC_addr;                                         //PC out to imem controller
wire [(WIDTH)-1:0] MEMWRITE_data;                                   //writing data to dram
wire [(WIDTH)-1:0] DRAM_addr;                                       //dram accessing memory location address
wire [(WIDTH)-1:0] MEMREAD_data;                                    //dram output

wire iROMREAD;
wire memWRITE;
wire memREAD;
wire imemAV1, imemAV2, imemAV3, imemAV4;
wire iROMREAD_1, iROMREAD_2, iROMREAD_3,iROMREAD_4;
wire coreS_1, coreS_2, coreS_3,coreS_4;
wire [WIDTH-1:0] PC_1, PC_2, PC_3,PC_4;
wire [WIDTH-1:0]INS_1, INS_2, INS_3,INS_4;
wire [WIDTH-1:0] AR_1, AR_2, AR_3,AR_4;
wire [WIDTH-1:0] DR_1, DR_2, DR_3, DR_4;  
wire memREAD_1, memREAD_2, memREAD_3,memREAD_4;
wire memWE_1, memWE_2, memWE_3,memWE_4;
wire [WIDTH-1:0] MEM_1, MEM_2, MEM_3,MEM_4;      
wire memAV1, memAV2, memAV3,memAV4;

localparam MEMID_CORE1 = 8'd127;                                    //DRAM Store starting locations for respective cores
localparam MEMID_CORE2 = 8'd159;
localparam MEMID_CORE3 = 8'd191;
localparam MEMID_CORE4 = 8'd223;

localparam COREID_1 = 3'd0;
localparam COREID_2 = 3'd1;
localparam COREID_3 = 3'd2;
localparam COREID_4 = 3'd3;

//instruction memory
ins_mem #(.ADDR_WIDTH(WIDTH), .INS_WIDTH(WIDTH)) ins_mem(.instruction(INS), .PC_address(PC_addr), .clk(clk), .rEn(iROMREAD));

//data memory
data_mem #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(WIDTH)) dt_mem(.data(MEMWRITE_data), .addr(DRAM_addr), .wEn(memWRITE), .clk(clk), .mem_out(MEMREAD_data), .rEn(memREAD));

imem_controller #(.WIDTH(WIDTH)) imem_c(.Clk(clk), .iROMREAD_1(iROMREAD_1), .iROMREAD_2(iROMREAD_2), .iROMREAD_3(iROMREAD_3),
 .iROMREAD_4(iROMREAD_4), .coreS_1(coreS_1), .coreS_2(coreS_2), .coreS_3(coreS_3), .coreS_4(coreS_4), .PC_1(PC_1), .PC_2(PC_2), .PC_3(PC_3), .PC_4(PC_4),
 .INS(INS), .rEN(iROMREAD), .PC_OUT(PC_addr), .INS_1(INS_1), .INS_4(INS_4), .INS_2(INS_2), .INS_3(INS_3), .imemAV1(imemAV1),
 .imemAV2(imemAV2), .imemAV3(imemAV3), .imemAV4(imemAV4));


dmem_controller #(.WIDTH(WIDTH)) dmem_c (.Clk(clk), .coreS_1(coreS_1), .coreS_2(coreS_2), .coreS_3(coreS_3), .coreS_4(coreS_4),
.memAV1(memAV1),.memAV2(memAV2), .memAV3(memAV3), .memAV4(memAV4), .AR_1(AR_1), .AR_2(AR_2), .AR_3(AR_3), .AR_4(AR_4),
.DR_1(DR_1), .DR_2(DR_2), .DR_3(DR_3), .DR_4(DR_4), .memREAD_1(memREAD_1), .memREAD_2(memREAD_2), .memREAD_3(memREAD_3),
.memREAD_4(memREAD_4), .memWE_1(memWE_1), .memWE_2(memWE_2), .memWE_3(memWE_3), .memWE_4(memWE_4), .MEM(MEMREAD_data), .rEN(memREAD), .wEN(memWRITE),
.MEM_1(MEM_1), .MEM_2(MEM_2), .MEM_3(MEM_3), .MEM_4(MEM_4), .addr(DRAM_addr), .DR_OUT(MEMWRITE_data));


core #(.WIDTH(WIDTH)) CORE_0 (.Clk(clk), .IROM_dataIn(INS_1), .DRAM_dataIn(MEM_1),.DRAM_dataOut(DR_1), 
                            .IROM_addr(PC_1), .DRAM_addr(AR_1), .memREAD(memREAD_1), .memWRITE(memWE_1), 
                            .iROMREAD(iROMREAD_1), .coreS(coreS_1), 
                            .imemAV(imemAV1), .memAV(memAV1), .MEM_ID(MEMID_CORE1), .coreID(COREID_1));

core #(.WIDTH(WIDTH)) CORE_1 (.Clk(clk), .IROM_dataIn(INS_2), .DRAM_dataIn(MEM_2),.DRAM_dataOut(DR_2), 
                            .IROM_addr(PC_2), .DRAM_addr(AR_2), .memREAD(memREAD_2), .memWRITE(memWE_2), .iROMREAD(iROMREAD_2), .coreS(coreS_2), 
                            .imemAV(imemAV2), .memAV(memAV2), .MEM_ID(MEMID_CORE2), .coreID(COREID_2));

core #(.WIDTH(WIDTH)) CORE_2 (.Clk(clk), .IROM_dataIn(INS_3), .DRAM_dataIn(MEM_3),.DRAM_dataOut(DR_3), 
                            .IROM_addr(PC_3), .DRAM_addr(AR_3), .memREAD(memREAD_3), .memWRITE(memWE_3), .iROMREAD(iROMREAD_3), .coreS(coreS_3), 
                            .imemAV(imemAV3), .memAV(memAV3), .MEM_ID(MEMID_CORE3), .coreID(COREID_3));

core #(.WIDTH(WIDTH)) CORE_3 (.Clk(clk), .IROM_dataIn(INS_4), .DRAM_dataIn(MEM_4),.DRAM_dataOut(DR_4), 
                            .IROM_addr(PC_4), .DRAM_addr(AR_4), .memREAD(memREAD_4), .memWRITE(memWE_4), .iROMREAD(iROMREAD_4), .coreS(coreS_4), 
                            .imemAV(imemAV4), .memAV(memAV4), .MEM_ID(MEMID_CORE4), .coreID(COREID_4));


assign proc_state = (coreS_1 && coreS_2 && coreS_3 && coreS_4);

endmodule