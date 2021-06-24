//Control unit outputs
// insREAD
// memREAD             //AR read, memory read, DR write
// memWRITE

// [15:0]wEN
//REGISTERS: 
//  PC  IR  AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  15  14  13  12 _11	10  9   8  _7   6   5   4  _3   2   1   0


// [3:0]busMUX		(2**4)
//  AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  14	13  12  11  10  9   8   7   6   5   4   3   2   1   


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

module main (
    input Clk,
    input z,
    input [7:0] REG_IR,
    output reg insRead,
    output reg memREAD,
    output reg memWRITE,
    output reg [15:0] wEN,
    output reg [3:0] busMUX,
    output reg [5:0] INC,
    output reg [2:0] compMUX,
    output reg [2:0] aluOP
);

reg [7:0]NEXT_STATE;
reg [7:0]INS;
reg [7:0]MEM_READ;


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
            NEXT_STATE <= 8'h12;
        end
        8'h12 : begin //FETCH_3
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;         
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            //NEXT_STATE <= INS[7:4]+4'b0000;                      XT INSTRUCTION
            NEXT_STATE <= INS;
        end
        
        8'h20 : begin   //JMP_M                     REG M1 - REG M2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b100;
            aluOP <= 0;
            NEXT_STATE <= ZERO_CHECK;
            if (z) begin
                NEXT_STATE <= 8'h30;
            end  
            else begin
                NEXT_STATE <= 8'h24;
            end  
        end
        8'h21 : begin   //JMP_K                     REG K1 - REG K2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b010;
            aluOP <= 0;
            NEXT_STATE <= ZERO_CHECK;
            if (z) begin
                NEXT_STATE <= 8'h30;
            end  
            else begin
                NEXT_STATE <= 8'h24;
            end  
        end
        8'h22 : begin   //JMP_N                     REG N1 - REG N2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b001;
            aluOP <= 0;
            NEXT_STATE <= ZERO_CHECK;
            if (z) begin
                NEXT_STATE <= 8'h30;
            end  
            else begin
                NEXT_STATE <= 8'h24;
            end  
        end
        // 8'h23 : begin       //JMP_2                 ZERO CHECK
        //     insREAD <= 0;
        //     memREAD <= 0;              
        //     memWRITE <= 0;
        //     wEN <= 0;
        //     busMUX <= 0;
        //     INC <= 0;
        //     RST <= 0;
        //     compMUX <= 0;
        //     aluOP <= 0;
        //     if (z) begin
        //         NEXT_STATE <= 8'h30;
        //     end  
        //     else begin
        //         NEXT_STATE <= 8'h24;
        //     end
        // end
        8'h24 : begin       //JMP_3                 READ_IROM[PC]
            insREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h25;
        end
        8'h25 :begin    //JMP_4                     AR <= IROM[PC]
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000;     
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h26;
        end
        8'h26 : begin       //JMP_5                 PC <= AR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b1000_0000_0000_0000;
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h30 : begin   //NO JMP                    PC <= PC + 1
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
        8'h40 : begin   //COPY_1                     READ_IROM[PC]
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
        8'h41 : begin   //COPY_2                        AR <= IROM[PC], PC <= PC + 1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000; 
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h42;
        end 
        8'h42 : begin    //COPY_3                       MEM_READ[AR]
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
        8'h43 : begin      //COPY_4                     DR <= MEM_READ[AR]
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0001_0000_0000_0000;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            if (INS[1:0]==2'b00) begin             //00 --> M, 01 --> K, 10 --> N   //0100_00[00]
                NEXT_STATE <= 8'h44;
            end
            else if (INS[1:0]==2'b01) begin
                NEXT_STATE <= 8'h45;
            end
            else if (INS[1:0]==2'b10) begin
                NEXT_STATE <= 8'h46;
            end
        end
        8'h44 : begin       //COPY M1               REG M1 <= DR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0010_0000_0000;
            busMUX <= 13;       //1100
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h45 : begin       //COPY K1               REG K1 <= DR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0001_0000_0000;;
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h46 : begin       //COPY N1               REG N1 <= DR
            insREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_1000_0000;
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h50 : begin       //LOAD_2                    MEM_READ[AR]
            insREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h51;
        end
        8'h51 : begin       //LOAD_3                    DR <= MEM_READ[AR]
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0001_0000_0000_0000;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h52 : begin       //LOAD_C1                   AR <= C1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000;
            busMUX <= 4;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h50;
        end
        8'h53 : begin       //LOAD_C2                    AR <= C2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000;
            busMUX <= 3;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h50;
        end
        8'h60 : begin       //STORE_1                    DR <= RT
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0001_0000_0000_0000;
            busMUX <= 11;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h61;
        end
        8'h61 : begin       //STORE_2                      AR <= C3
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000;
            busMUX <= 2;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h62;
        end
        8'h62 : begin       //STORE_3                   MEM_WRITE[AR] <= DR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 1;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h70 : begin       //ASSIGN_1                   READ_IROM[PC]
            insREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h71;
        end
        8'h71 : begin       //ASSIGN_3                AR <= IROM[PC], PC <= PC+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000;
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            if (INS[1:0]==2'b00) begin             //00 --> ASSIGN C1, 01 --> ASSIGN C2, 10 --> ASSIGN C3
                NEXT_STATE <= 8'h72;
            end
            else if (INS[1:0]==2'b01) begin             
                NEXT_STATE <= 8'h73;
            end
            else if (INS[1:0]==2'b10) begin             
                NEXT_STATE <= 8'h74;
            end
        8'h72 : begin       //ASSIGN_C1                   C1 <= AR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_1000;
            busMUX <= 14;                               //14 = 4'b1100
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h73 : begin       //ASSIGN_C2                   C2 <= AR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0100;
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h74 : begin       //ASSIGN_C3                   C3 <= AR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0010;
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h62 : begin       //
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
        8'h80 : begin       //RESET_ALL
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 5'b11111;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h81 : begin       //RESET REG N2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 5'b00010;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h82 : begin       //RESET REG K2
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 5'00100;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h90 : begin       //MOVE TO REG P               REG P <= AC
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_1000_0000_0000;
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h91 : begin       //MOVE TO REG T             REG T <= AC
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0100_0000_0000;
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'h92 : begin       //MOVE TO REG C1                C1 <= AC
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_1000;
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'hA0 : begin       //SET AC AS C1               SET, AC <= C1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            busMUX <= 4;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b001;
            NEXT_STATE <= 8'h10;
        end
        8'hA1 : begin       //SET AC AS DR                SET, AC <= DR
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b001;
            NEXT_STATE <= 8'h10;
        end
        8'hB0 : begin       //MUL REG P                 AC <= REG_P * AC
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            busMUX <= 12;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b010;
            NEXT_STATE <= 8'h10;
        end
        8'hC0 : begin       //ADD REG_T                AC <= REG_1 + AC
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            busMUX <= 11;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b100;
            NEXT_STATE <= 8'h10;
        end
        8'hC1 : begin       //ADD REG_M1                AC <= REG_M1 + AC
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            busMUX <= 10;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b100;
            NEXT_STATE <= 8'h10;
        end
        8'hC2 : begin       //ADD REG_M2                AC <= REG_M2 + AC
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            busMUX <= 7;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b100;
            NEXT_STATE <= 8'h10;
        end
        8'hD0 : begin       //INC REG C2               REG C2 <= C2+1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 6'b00_0010;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'hD1 : begin       //INC REG C3                REG C3 <= C3+1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 6'b00_0001;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'hD2 : begin       //INC reg m2                REG M2 <= M2+1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 6'b01_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'hD3 : begin       //INC REG K2               REG K2 <= K2+1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 6'b00_1000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        8'hD4 : begin       //INC REG N2               REG N2 <= N2+1
            insREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 6'b00_0100;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= 8'h10;
        end
        end
    endcase
        

        
end
endmodule


