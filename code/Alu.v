/*module Alu #(
    parameter WIDTH
) (
    input Clk,
    input [2:0] ALU_OP, //comes from the control unit
    input [WIDTH-1:0] AC, BusOut, //inputs comes from AC and bus
    output reg [WIDTH-1:0] result_ac //output is AC register
);

localparam SET = 3'b001;
           MUL = 3'b010;
           ADD = 3'b100;
           



always @(posedge Clk) begin
    case(ALU_OP)
        PASS:
            result_ac=BusOut;
        ADD:
            result_ac=AC+BusOut;
        MUL:
            result_ac=AC*BusOut;
        default:
            result_ac=1'bz; //high impendence in idle state.

    endcase
    
end
    
endmodule*/

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