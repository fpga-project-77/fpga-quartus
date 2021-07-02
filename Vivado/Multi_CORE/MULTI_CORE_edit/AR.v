
module AR //write enable /IR, AR, Rp, Rt, Rk1, Rm1, Rn1, C1
#(parameter WIDTH = 8)
(
input Clk, WEN, selAR, coreINC_AR,
input [WIDTH-1:0] IOut, BusOut, 
input [2:0] coreID,
output [WIDTH-1:0] dout
);

reg [WIDTH-1:0] value;
/*
always @(negedge Clk) 
begin
    if(WEN==1) begin 
        case(selAR)
            1'b1:
                value <= IOut;
            1'b0:
                value <= BusOut;
        endcase   
    end
    else if (coreINC_AR==1) begin //new edit
        value <= value + coreID;
    end
end
*/

always @(negedge Clk) 
begin
    if(WEN==1 && selAR == 0 && coreINC_AR == 0) begin 
        value <= BusOut;   
    end
    if (coreINC_AR==1) begin //new edit
        value <= value + coreID;
    end
    if(WEN==1 && selAR == 1 && coreINC_AR == 0) begin 
        value <= IOut;   
    end
end



// always @(negedge Clk) 
// begin
//     if(WEN==1) begin 
//         case (coreINC_AR)
//             1'b1 : begin
//                 value <= value + coreID;
//             1'b0 :begin
//                 case(selAR)
//                     1'b1: value <= IOut;
//                     1'b0: value <= BusOut;
//                 endcase    
//             end  
//         endcase
//     end
// end

assign dout=value;
    
endmodule