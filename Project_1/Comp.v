module Comp #(
    parameter WIDTH = 8
) (
    //input Clk,
    input [WIDTH-1:0] R1, R2, //inputs comes from AC and bus
    output wire z //output is AC register
);

reg [WIDTH-1:0] value;
reg flagOut;
always @(*) begin
    value <= R1-R2; 
	 flagOut <= (value == 8'b0);
//	if (value==8'b0) begin
//        flagOut <= 1'b1;
//    end 
//    else begin
//        flagOut <= 1'b0;
//    end
end

assign z = flagOut;
    
endmodule 