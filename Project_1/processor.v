`include "proc_param.v"

module processor 

#(parameter WIDTH = 8)(
    input Clk,
    input [WIDTH-1:0]IROM_dataIn,       // --> IR or --> AR
    input [WIDTH-1:0]DRAM_dataIn,       // --> DR
    output [WIDTH-1:0]DRAM_dataOut,     // from DR
    output [WIDTH-1:0]IROM_addr,        //PC
    output [WIDTH-1:0]DRAM_addr,         //AR
    output wire memREAD, memWRITE, iROMREAD
);

wire [15:0] wEN;
wire [5:0] INC;
wire [4:0] RST;
wire [2:0] compMUX;
wire [2:0] aluOP;
wire zFlag;
wire selAR;
wire [3:0]busMUX;

reg [WIDTH-1:0]INS;  // instruction from iROM
reg [WIDTH-1:0] COMP_IN1;
reg [WIDTH-1:0] COMP_IN2;
reg [WIDTH-1:0]PC_OUT;
reg [WIDTH-1:0]AR_OUT;
reg [WIDTH-1:0]DR_OUT;
reg [WIDTH-1:0]RP_OUT;
reg [WIDTH-1:0]RT_OUT;
reg [WIDTH-1:0]RM1_OUT;
reg [WIDTH-1:0]RK1_OUT;
reg [WIDTH-1:0]RN1_OUT;
reg [WIDTH-1:0]RM2_OUT;
reg [WIDTH-1:0]RK2_OUT;
reg [WIDTH-1:0]RN2_OUT;
reg [WIDTH-1:0]RC1_OUT;
reg [WIDTH-1:0]RC2_OUT;
reg [WIDTH-1:0]RC3_OUT;
reg [WIDTH-1:0]AC_OUT;

reg [WIDTH-1:0]BUSMUX_OUT;
//PC                                                    15                 5
Reg_module_WI #(.WIDTH(WIDTH)) PC (.Clk(Clk), .WEN(wEN[`PC_W]), .INC(INC[`PC_INC]), .BusOut(AR_OUT), .dout(PC_OUT));
//IR                Reg_module_W                         14
Reg_module_W #(.WIDTH(WIDTH)) IR (.Clk(Clk), .WEN(wEN[`IR_W]), .BusOut(IROM_dataIn), .dout(INS));

//AR                NOT DONE!!                                     13
//Reg_module_W #(.WIDTH(WIDTH)) AR (.Clk(Clk), .WEN(wEN[`AR_W]), .BusOut(??), .dout(AR_OUT));
AR #(.WIDTH(WIDTH)) AR (.Clk(Clk), .WEN(wEN[`AR_W]), .BusOut(BUSMUX_OUT), .IOut(INS), .selAR(selAR), .dout(AR_OUT));

//DR                                                    12
Reg_module_W #(.WIDTH(WIDTH)) DR (.Clk(Clk), .WEN(wEN[`DR_W]), .BusOut(BUSMUX_OUT), .dout(DR_OUT));
//RP                                                    11
Reg_module_W #(.WIDTH(WIDTH)) RP (.Clk(Clk), .WEN(wEN[`RP_W]), .BusOut(BUSMUX_OUT), .dout(RP_OUT));
//RT            to be changed Reg_module_RW             10
//Reg_module_W #(.WIDTH(WIDTH)) RT (.Clk(Clk), .WEN(wEN[`RT_W]), .BusOut(BUSMUX_OUT), .dout(RT_OUT));
Reg_module_RW #(.WIDTH(WIDTH)) RT (.Clk(Clk), .WEN(wEN[`RT_W]), .RST(RST[`RT_RST]), .BusOut(BUSMUX_OUT), .dout(RT_OUT));   
//RM1                                                   9
Reg_module_W #(.WIDTH(WIDTH)) RM1 (.Clk(Clk), .WEN(wEN[`RM1_W]), .BusOut(BUSMUX_OUT), .dout(RM1_OUT));
//RK1                                                   8
Reg_module_W #(.WIDTH(WIDTH)) RK1 (.Clk(Clk), .WEN(wEN[`RK1_W//Write enable signals
`define PC_W 15
`define IR_W 14
`define AR_W 13
`define DR_W 12
`define RP_W 11
`define RT_W 10
`define RM1_W 9
`define Rk1_W 8
`define RN1_W 7
`define RM2_W 6
`define RK2_W 5
`define RN2_W 4
`define RC1_W 3
`define RC2_W 2
`define RC3_W 1
`define AC_W 0

//register increment signals
`define PC_INC 5
`define RM2_INC 4
`define RK2_INC 3
`define RN2_INC 2
`define RC2_INC 1
`define RC3_INC 0

//register reset signals
`define RT_RST 4
`define RM2_RST 3
`define RK2_RST 2
`define RN2_RST 1
`define AC_RST 0

]), .BusOut(BUSMUX_OUT), .dout(RK1_OUT));
//RN1                                                   7
Reg_module_W #(.WIDTH(WIDTH)) RN1 (.Clk(Clk), .WEN(wEN[`RN1_W]), .BusOut(BUSMUX_OUT), .dout(RN1_OUT));
//RM2
Reg_module_RI #(.WIDTH(WIDTH)) RM2 (.Clk(Clk), .RST(RST[`RM2_RST]), .INC(INC[`RM2_INC]), .BusOut(BUSMUX_OUT), .dout(RM2_OUT));
//RK2
Reg_module_RI #(.WIDTH(WIDTH)) RK2 (.Clk(Clk), .RST(RST[`RK2_RST]), .INC(INC[`RK2_INC]), .BusOut(BUSMUX_OUT), .dout(RK2_OUT));
//RN2
Reg_module_RI #(.WIDTH(WIDTH)) RN2 (.Clk(Clk), .RST(RST[`RN2_RST]), .INC(INC[`RN2_INC]), .BusOut(BUSMUX_OUT), .dout(RN2_OUT));
//RC1                                                   3
Reg_module_W #(.WIDTH(WIDTH)) RC1 (.Clk(Clk), .WEN(wEN[`RC1_W]), .BusOut(BUSMUX_OUT), .dout(RC1_OUT));
//RC2                                                   2                   1
Reg_module_WI #(.WIDTH(WIDTH)) RC2 (.Clk(Clk), .WEN(wEN[`RC2_W]), .INC(INC[`RC2_INC]), .BusOut(BUSMUX_OUT), .dout(RC2_OUT));
//RC3                                                   1                   0
Reg_module_WI #(.WIDTH(WIDTH)) RC3 (.Clk(Clk), .WEN(wEN[`RC3_W]), .INC(INC[`RC3_INC]), .BusOut(BUSMUX_OUT), .dout(RC3_OUT));
//AC            to be changed Reg_module_RW             0
//Reg_module_W #(.WIDTH(WIDTH)) AC (.Clk(Clk), .WEN(wEN[`AC_W]), .BusOut(ALU_OUT), .dout(AC_OUT));
Reg_module_RW #(.WIDTH(WIDTH)) AC (.Clk(Clk), .WEN(wEN[`AC_W]), .RST(RST[`AC_RST]), .BusOut(ALU_OUT), .dout(AC_OUT));   

//ALU
Alu #(.WIDTH(WIDTH)) ALU (.AC(AC_OUT), .BusOut(BUSMUX_OUT), .result_ac(ALU_OUT), .ALU_OP(aluOP));

mux_3to1_8bit  COMPMUX1 (.mux_inN(RN1_OUT), .mux_inK(RK1_OUT), .mux_inM(RM1_OUT), .mux_sel(compMUX), .mux_out(COMP_IN1));
mux_3to1_8bit  COMPMUX2 (.mux_inN(RN2_OUT), .mux_inK(RK2_OUT), .mux_inM(RM2_OUT), .mux_sel(compMUX), .mux_out(COMP_IN2));
Comp #(.WIDTH(WIDTH)) COMP (.R1(COMP_IN1), .R2(COMP_IN2), .z(zFlag));

Bus_mux dut(.MEM(MEM), .AR(AR_OUT), .DR(DR_OUT), .RP(RP_OUT), .RT(RT_OUT), .RM1(RM1_OUT), .RK1(RK1_OUT), .RN1(RN1_OUT), .RM2(RM2_OUT), .RK2(RK2_OUT), .RN2(RN2_OUT), .C1(C1_OUT), .C2(C2_OUT), .C3(C3_OUT), .AC(AC_OUT), .mux_sel(mux_sel), .Bus_select(Bus_select));
//CU
controlunit #(.WIDTH(WIDTH)) CU (.Clk(Clk), .z(zFlag), .REG_IR(INS), .iROMREAD(iROMREAD), .memREAD(memREAD), .memWRITE(memWRITE), .wEN(wEN), .selAR(selAR), .busMUX(busMUX), .INC(INC), .RST(RST), .compMUX(compMUX), .aluOP(aluOP));


assign IROM_addr = PC_OUT;
assign DRAM_dataOut = DR_OUT;
assign DRAM_addr = AR_OUT;
endmodule