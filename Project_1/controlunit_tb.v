`timescale 1ns/1ps
`include "cu_param.v"
module controlunit_tb ();

    localparam CLK_PERIOD = 20;
    reg Clk;

    initial begin
        Clk = 1'b0;
        forever begin
            #(CLK_PERIOD/2);
            Clk = ~Clk;
        end
    end

    reg zFlag;
    reg [7:0] INS;
    wire iROMREAD;
    wire memREAD;
    wire memWRITE;
    wire [13:0] wEN;
    wire selAR;
    wire [3:0] busMUX;
    wire [5:0] INC;
	wire [4:0] RST;
    wire [2:0] compMUX;
    wire [2:0] aluOP;

    controlunit dut (.Clk(Clk), .z(zFlag), .INS(INS), .iROMREAD(iROMREAD), .memREAD(memREAD), .memWRITE(memWRITE), .wEN(wEN), .selAR(selAR), .busMUX(busMUX), .INC(INC), .RST(RST), .compMUX(compMUX), .aluOP(aluOP)) ;
    

    initial begin
        #(CLK_PERIOD*2)
        INS <= 8'b00100000;

        #(CLK_PERIOD);
        @(posedge Clk);
        
        #(CLK_PERIOD*6);
        
        @(posedge Clk);
        INS <= 8'b0001_0000; //JMP_M1
        zFlag=0;
        

        #(CLK_PERIOD*7); 
        @(posedge Clk);
        INS <= 8'b0001_0000;  //JMP_M1
        zFlag=1;

        #(CLK_PERIOD*5)
        
    
        repeat(5) @(posedge Clk) begin
            INS <= $random;
            zFlag <= $random;
            
        end
        

        $stop;

        
    end


    
endmodule

