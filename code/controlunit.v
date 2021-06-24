//Control unit outputs
// insREAD
// memREAD             //AR read, memory read, DR write
// memWRITE

// [15:0]wEN
//REGISTERS: 
//  PC  IR  AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  15  14  13  12  11  10  9   8   7   6   5   4   3   2   1   0


// [3:0]busMUX		(2**4)
//  AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  13  12  11  10  9   8   7   6   5   4   3   2   1   0


// [5:0]INC        
//  PC  RM2 RK2 RN2  C2  C3
//  5   4   3   2   1   0

// [4:0] RST
// RT   RM2    RK2    RN2   AC
// 4    3      2      1     0

// [2:0]compMUX              //both muxes get the same control signal
//  M1-M2   K1-K2    N1-N2
//  2       1        0

// [2:0]aluOP
// ADD      MUL     SET     
// 2        1       0


//NEXT INSTRUCTION

module controller (
    input Clk, z;
    input [7:0] INS;
    output reg insRead;
    output reg memREAD;
    output reg memWRITE;
    output reg [15:0] wEN;
    output reg [3:0] busMUX;
    output reg [5:0] INC;
    output reg [2:0] compMUX;
    output reg [2:0] aluOP;
);

reg NEXT_STATE;

//DEFINE ALL THE STATES OF THE CONTROL UNIT
always @(posedge Clk) begin
    case(NEXT_STATE) 
        8'h00 : begin       //NO_OP
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;

        end
        8'h10 : begin   //FETCH_1
            insREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h11;
        end
        8'h11 : begin //FETCH_2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0100_0000_0000_0000;         //IR WRITE
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= INS;                      //NEXT INSTRUCTION
        end
        8'h20 : begin   //JMP_M
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b100;
            aluOP <= 0;
            // if (z) begin
            //     NEXT_STATE <= 8'h30;
            // end  
            // else begin
            //     NEXT_STATE <= 8'h23;
            // end  
        end
        8'h21 : begin   //JMP_K
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b010;
            aluOP <= 0;
            // if (z) begin
            //     NEXT_STATE <= 8'h30;
            // end  
            // else begin
            //     NEXT_STATE <= 8'h23;
            // end  
        end
        8'h22 : begin   //JMP_N
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b001;
            aluOP <= 0;
            // if (z) begin
            //     NEXT_STATE <= 8'h30;
            // end  
            // else begin
            //     NEXT_STATE <= 8'h23;
            // end  
        end
        8'h23 : begin       //JMP_2
            insREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h24;
        end
        8'h24 :begin    //JMP_3
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000;     //AR WRITE
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h25;
        end
        8'h30 : begin   //NO JMP
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h40 : begin   //COPY_1
            insREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h41;
        end 
        8'h41 : begin   //COPY_2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000; //AR WRITE
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h42;
        end 
        8'h42 : begin    //COPY_3
            insREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h43;
        end
        8'h43 : begin      //COPY_4
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0001_0000_0000_0000;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            if (INS[1:0]==2'b00) begin             //00 --> M, 01 --> K, 10 --> N
                NEXT_STATE <= 8'h44;
            end
            else if (INS[1:0]==2'b01) begin
                NEXT_STATE <= 8'h45;
            end
            else if (INS[1:0]==2'b10) begin
                NEXT_STATE <= 8'h46;
            end
        end
        8'h44 : begin       //COPY M1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0010_0000_0000;
            busMUX <= 12;       //1100
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h45 : begin       //COPY K1
            insREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 16'b0000_0001_0000_0000;;
            busMUX <= 12;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h46 : begin       //COPY N1
            insREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        end
    endcase
        

        
end
endmodule


