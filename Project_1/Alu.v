//`include "proc_pram.v"
module Alu #(
    parameter WIDTH = 8
) (
    input Clk,
    input [WIDTH-1:0] AC, BusOut,
    input [2:0] ALU_OP,
    output [WIDTH-1:0] result_ac
);

	localparam SET = 3'b001;
	localparam MUL = 3'b010;
	localparam ADD = 3'b100;
    
    reg [WIDTH-1:0] result;
    
    always @* begin
    	case (ALU_OP)
            SET: 
                result<=BusOut;
            MUL:
                result<=AC*BusOut;
            ADD:
                result<=AC+BusOut;
            default: 
                result<=AC;
        endcase    
    end
    assign result_ac = result;
		 
endmodule