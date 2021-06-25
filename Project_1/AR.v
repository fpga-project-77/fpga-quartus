//`include "proc_pram.v"
module AR //write enable /IR, AR, Rp, Rt, Rk1, Rm1, Rn1, C1
#(parameter WIDTH = 8)
(
input Clk, WEN, selAR,
input [WIDTH-1:0] IOut, BusOut,
output [WIDTH-1:0] dout
);

reg [WIDTH-1:0] value;

always @(posedge Clk) 
begin
    if(WEN==1) begin 
        case(selAR)
            1'b1:
                value <= IOut;
            1'b0:
                value <= BusOut;
        endcase   
    end
end

assign dout=value;
    
endmodule