//Write enable signals
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


//aluOP
`define SET 3'b001
`define MUL 3'b010
`define ADD 3'b100

//selAR
`define SIROM 1'b1
`define SBUS 1'b0

//busMUX
//  MEM AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  15   14  13  12  11  10  9   8   7   6   5   4   3   2   1  
`define SAC 4'b0001
`define SC3 4'b0010
`define SC2 4'b0011
`define SC1 4'b0100
`define SRN2 4'b0101
`define SRK2 4'b0110
`define SM2 4'b0111
`define SN1 4'b1000
`define SK1 4'b1001
`define SM1 4'b1010
`define SRT 4'b1011
`define SRP 4'b1100
`define SDR 4'b1101
`define SAR 4'b1110
`define SMEM 4'b1111
