//`include "proc_pram.v"
//  MEM AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  15   14  13  12  11  10  9   8   7   6   5   4   3   2   1   

module Bus_mux(MEM, AR, DR, RP, RT, RM1, RK1, RN1, RM2, RK2, RN2, C1,  C2,  C3,  AC, mux_sel, Bus_select);
input [3:0] mux_sel;
input [7:0] MEM, AR, DR, RP, RT, RM1, RK1, RN1, RM2, RK2, RN2, C1,  C2,  C3,  AC;
output [7:0] Bus_select;
// The output is defined as register 
reg [7:0] Bus_select;
always @(mux_sel)
begin
    case(mux_sel)
        
        4'b0001:
            Bus_select <= AC;
        4'b0010:
            Bus_select <= C3;
        4'b0011: 
            Bus_select <= C2;
        4'b0100:
            Bus_select <= C1;
        4'b0101:
            Bus_select <= RN2;
        4'b0110:
            Bus_select <= RK2;
        4'b0111:
            Bus_select <= RM2;
        4'b1000:
            Bus_select <= RN1;
        4'b1001:
            Bus_select <= RK1;
        4'b1010:
            Bus_select <= RM1;
        4'b1011:
            Bus_select <= RT;
        4'b1100:
            Bus_select <= RP;
        4'b1101:
            Bus_select <= DR;
        4'b1110:
            Bus_select <= AR;
        4'b1111:
            Bus_select <= MEM;
    endcase   
end  
endmodule
