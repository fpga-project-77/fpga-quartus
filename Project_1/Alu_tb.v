`timescale 1ns/1ps
module Alu_tb ();
    localparam CLK_PERIOD = 10;
    reg Clk;

    initial begin
        Clk=1'b0;
        forever begin
            #(CLK_PERIOD/2);
            Clk <= ~Clk;    
        end
    end

    localparam WIDTH = 8;
    reg [WIDTH-1:0] AC, BusOut;
    reg [2:0] ALU_OP;
    wire [WIDTH-1:0] result_ac;
    

    Alu #(.WIDTH(WIDTH)) dut (.AC(AC), .BusOut(BusOut), .result_ac(result_ac), .ALU_OP(ALU_OP));

    initial begin
        #(CLK_PERIOD*2);

        @(posedge Clk);
        AC=8'b00010101;
        BusOut=8'b10101010;
        ALU_OP=3'b001;

        #(CLK_PERIOD*2);
        @(posedge Clk);
        AC=8'b00010101;
        BusOut=8'b10101010;
        ALU_OP=3'b100;

        @(posedge Clk);
        AC=8'b00010101;
        BusOut=8'b10101010;
        // ALU_OP=3'b010;

        @(posedge Clk);
        AC=8'b00010101;
        BusOut=8'b10101010;
        ALU_OP=3'b001;

       
        repeat(5) @(posedge Clk) begin
            BusOut <= $random;
            AC <= $random;
            ALU_OP <= $random;
            $display("%8b", BusOut);
            $display("%8b", AC);
        end

        $stop;

    end   
endmodule