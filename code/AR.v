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
        if (selAR == 1) begin
           value <= IOut; 
        end  
        else if (selAR == 0) begin
           value <= BusOut;
        end     
    end
end

assign dout=value;
    
endmodule