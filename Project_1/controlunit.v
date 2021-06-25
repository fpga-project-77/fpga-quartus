`include "cu_param.v"

//Control unit outputs
// iROMREAD
// memREAD             //AR read, memory read, DR write
// memWRITE

// [12:0]wEN
//REGISTERS: 
//  PC  IR  AR  DR  RP  RT  RM1 RK1 RN1 C1  C2  C3  AC
//  12 _11	10  9   8  _7   6   5   4  _3   2   1   0


// [3:0]busMUX		(2**4)
//  MEM     AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  15      14	13  12  11  10  9   8   7   6   5   4   3   2   1   


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

module controlunit (
    input Clk,
    input z,
    input [7:0] INS,
    output reg iROMREAD,
    output reg memREAD,
    output reg memWRITE,
    output reg [12:0] wEN,
    output reg selAR,
    output reg [3:0] busMUX,
    output reg [5:0] INC,
	 output reg [4:0] RST,
    output reg [2:0] compMUX,
    output reg [2:0] aluOP,
    output reg coreS);


reg [7:0]NEXT_STATE=`FETCH_1;
reg [7:0]STATE=`FETCH_1;


//DEFINE ALL THE STATES OF THE CONTROL UNIT
always @(posedge Clk) begin
    STATE = NEXT_STATE;
    case(STATE) 
        `NOOP_1 : begin       //NO_OP
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `FETCH_1 : begin   //FETCH_1
            iROMREAD <= 1;       
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_2;
            coreS <= 0;
        end
        `FETCH_2 : begin //FETCH_2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_1000_0000_0000;         //IR WRITE
            selAR <= 0;
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_3;
            coreS <= 0;
        end
        `FETCH_3 : begin //FETCH_3                 IR HAS ALREADY GOT THE INS
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;         
            busMUX <= 0;
            INC <= 0; //fault
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            //NEXT_STATE <= INS[7:4]+4'b0000;                      NEXT INSTRUCTION
            coreS <= 0;
            case (INS[7:4])
                `NOOP_1 : NEXT_STATE <= `NOOP_1 ;
                `JMP : begin
                    case (INS[3:0])
                        `JMP_M : NEXT_STATE <= `JMPM_1;
                        `JMP_K : NEXT_STATE <= `JMPK_1;
                        `JMP_N : NEXT_STATE <= `JMPN_1; 
                    endcase
                end
                `COPY : NEXT_STATE <= `COPY_1;
                `LOAD : begin
                    case (INS[3:0])
                       `LOAD_C1 : NEXT_STATE <= `LOADC1_1;
                       `LOAD_C2 : NEXT_STATE <= `LOADC2_1;
                    endcase
                end
                `STORE : NEXT_STATE <= `STORE_1;
                `ASSIGN : NEXT_STATE <= `ASSIGN_1;
                `RESET : begin
                    case (INS[3:0])
                        `RESET_ALL : NEXT_STATE <= `RESETALL_1;
                        `RESET_N2 : NEXT_STATE <= `RESETN2_1;
                        `RESET_K2 : NEXT_STATE <= `RESETK2_1;
                    endcase
                end
                `MOVE : begin
                    case (INS[3:0])
                        `MOVE_RP : NEXT_STATE <= `MOVEP_1;
                        `MOVE_RT : NEXT_STATE <= `MOVET_1;
                        `MOVE_RC1 : NEXT_STATE <= `MOVEC1_1;
                    endcase
                end
                `SET : begin
                    case (INS[3:0])
                        `SETC1 : NEXT_STATE <= `SETC1_1;
                        `SETDR : NEXT_STATE <= `SETDR_1;
                    endcase
                end
                `MUL : NEXT_STATE <= `MUL_1;
                `ADD : begin
                    case (INS[3:0])
                        `ADD_RT : NEXT_STATE <= `ADDRT_1;
                        `ADD_RM1 : NEXT_STATE <= `ADDRM1_1;
                        `ADD_RM2 : NEXT_STATE <= `ADDRM2_1;
                    endcase
                end
                `ADD : begin
                    case (INS[3:0])
                        `INC_C2 : NEXT_STATE <= `INCC2_1;
                        `INC_C3 : NEXT_STATE <= `INCC3_1;
                        `INC_M2 : NEXT_STATE <= `INCM2_1;
                        `INC_K2 : NEXT_STATE <= `INCK2_1;
                        `INC_N2 : NEXT_STATE <= `INCN2_1;
                    endcase
                end
                `END : NEXT_STATE <= `ENDOP_1;

                // TODO : END OPERATION                             
            endcase
        end
        
        `JMPM_1 : begin   //`JMPM_1                     REG M1 - REG M2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b100;
            aluOP <= 0;
            coreS <= 0;
            //NEXT_STATE <= ZERO_CHECK;
            if (z) begin
                NEXT_STATE <= `NJMP_1;
            end  
            else begin
                NEXT_STATE <=`JMP_2;
            end  
        end
        `JMPK_1 : begin   //JMP_K                     REG K1 - REG K2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b010;
            aluOP <= 0;
            coreS <= 0;
            //NEXT_STATE <= ZERO_CHECK;
            if (z) begin
                NEXT_STATE <= `NJMP_1;
            end  
            else begin
                NEXT_STATE <=`JMP_2;
            end  
        end
        `JMPN_1 : begin   //JMP_N                     REG N1 - REG N2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b001;
            aluOP <= 0;
            coreS <= 0;
            //NEXT_STATE <= ZERO_CHECK;
            if (z) begin
                NEXT_STATE <= `NJMP_1;
            end  
            else begin
                NEXT_STATE <=`JMP_2;
            end  
        end
        // 8'h23 : begin      //ZERO CHECK
        //     iROMREAD <= 0;
        //     memREAD <= 0;              
        //     memWRITE <= 0;
        //     wEN <= 0;
        //    selAR <= 0;
        //     busMUX <= 0;
        //     INC <= 0;
        //     RST <= 0;
        //     compMUX <= 0;
        //     aluOP <= 0;
        //     if (z) begin
        //         NEXT_STATE <= `NJMP_1;
        //     end  
        //     else begin
        //         NEXT_STATE <=`JMP_2;
        //     end
        // end
       `JMP_2 : begin       //JMP_2                 READ_IROM[PC]
            iROMREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <=`JMP_3;
            coreS <= 0;
        end
       `JMP_3 :begin    //JMP_3                     AR <= IROM[PC]
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0100_0000_0000;     
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <=`JMP_4;
            coreS <= 0;
        end
       `JMP_4 : begin       //JMP_4                 PC <= AR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b1_0000_0000_0000;
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `NJMP_1 : begin   //NO`JMP                    PC <= PC + 1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `COPY_1 : begin   //`COPY_1                     READ_IROM[PC]
            iROMREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `COPY_2;
            coreS <= 0;
        end 
        `COPY_2 : begin   //`COPY_2                        AR <= IROM[PC], PC <= PC + 1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0100_0000_0000; 
            selAR <= 1;
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `COPY_3;
            coreS <= 0;
        end 
        `COPY_3 : begin    //`COPY_3                       MEM_READ[AR]
            iROMREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `COPY_4;
            coreS <= 0;
        end
        `COPY_4 : begin      //`COPY_4                     DR <= MEM_READ[AR]
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0010_0000_0000;
            selAR <= 0;
            busMUX <= 15;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (INS[1:0]==2'b00) begin             //00 --> M, 01 --> K, 10 --> N   //0100_00[00]
                NEXT_STATE <= `COPYM_5;
            end
            else if (INS[1:0]==2'b01) begin
                NEXT_STATE <= `COPYK_5;
            end
            else if (INS[1:0]==2'b10) begin
                NEXT_STATE <= `COPYN_5;
            end
        end
        `COPYM_5 : begin       //`COPY M1               REG M1 <= DR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0100_0000;
            selAR <= 0;
            busMUX <= 13;       //1100
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `COPYK_5 : begin       //`COPY K1               REG K1 <= DR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0010_0000;
            selAR <= 0;
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `COPYN_5 : begin       //`COPY N1               REG N1 <= DR
            iROMREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0001_0000;
            selAR <= 0;
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `LOAD_2 : begin       //`LOAD_2                    MEM_READ[AR]
            iROMREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `LOAD_3;
            coreS <= 0;
        end
        `LOAD_3 : begin       //`LOAD_3                    DR <= MEM_READ[AR]
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0010_0000_0000;
            selAR <= 0;
            busMUX <= 15;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `LOADC1_1 : begin       //`LOAD_C1                   AR <= C1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0100_0000_0000;
            selAR <= 0;
            busMUX <= 4;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `LOAD_2;
            coreS <= 0;
        end
        `LOADC2_1 : begin       //`LOAD_C2                    AR <= C2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0100_0000_0000;
            selAR <= 0;
            busMUX <= 3;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `LOAD_2;
            coreS <= 0;
        end
        `STORE_1 : begin       //`STORE_1                    DR <= RT
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0010_0000_0000;
            selAR <= 0;
            busMUX <= 11;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `STORE_2;
            coreS <= 0;
        end
        `STORE_2 : begin       //`STORE_2                      AR <= C3
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0100_0000_0000;
            selAR <= 0;
            busMUX <= 2;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `STORE_3;
            coreS <= 0;
        end
        `STORE_3 : begin       //`STORE_3                   MEM_WRITE[AR] <= DR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 1;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `ASSIGN_1 : begin       //ASSIGN_1                   READ_IROM[PC]
            iROMREAD <= 1;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `ASSIGN_2;
            coreS <= 0;
        end
        `ASSIGN_2 : begin       //ASSIGN_3                AR <= IROM[PC], PC <= PC+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0100_0000_0000;
            selAR <= 1;
            busMUX <= 0;
            INC <= 6'b10_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (INS[1:0]==2'b00) begin             //00 --> ASSIGN C1, 01 --> ASSIGN C2, 10 --> ASSIGN C3
                NEXT_STATE <= `ASSIGNC1_3;
            end
            else if (INS[1:0]==2'b01) begin             
                NEXT_STATE <= `ASSIGNC2_3;
            end
            else if (INS[1:0]==2'b10) begin             
                NEXT_STATE <= `ASSIGNC3_3;
				end
        end 
	    `ASSIGNC1_3 : begin       //ASSIGN_C1                   C1 <= AR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_1000;
            selAR <= 0;
            busMUX <= 14;                               //14 = 4'b1100
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
		  end 
		`ASSIGNC2_3 : begin       //ASSIGN_C2                   C2 <= AR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0100;
            selAR <= 0;
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `ASSIGNC3_3 : begin       //ASSIGN_C3                   C3 <= AR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0010;
            selAR <= 0;
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `RESETALL_1 : begin       //RESET_ALL
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 5'b11111;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `RESETN2_1 : begin       //RESET REG N2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 5'b00010;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `RESETK2_1 : begin       //RESET REG K2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 5'b00100;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `MOVEP_1 : begin       //MOVE TO REG P               REG P <= AC
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0001_0000_0000;
            selAR <= 0;
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `MOVET_1 : begin       //MOVE TO REG T             REG T <= AC
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_1000_0000;
            selAR <= 0;
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `MOVEC1_1 : begin       //MOVE TO REG C1                C1 <= AC
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_1000;
            selAR <= 0;
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `SETC1_1 : begin       //SET AC AS C1               SET, AC <= C1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0001;
            selAR <= 0;
            busMUX <= 4;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b001;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `SETDR_1 : begin       //SET AC AS DR                SET, AC <= DR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0001;
            selAR <= 0;
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b001;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `MUL_1 : begin       //MUL REG P                 AC <= REG_P * AC
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0001;
            selAR <= 0;
            busMUX <= 12;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b010;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `ADDRT_1 : begin       //ADD REG_T                AC <= REG_1 + AC
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0001;
            selAR <= 0;
            busMUX <= 11;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b100;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `ADDRM1_1 : begin       //ADD REG_M1                AC <= REG_M1 + AC
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0001;
            selAR <= 0;
            busMUX <= 10;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b100;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `ADDRM2_1 : begin       //ADD REG_M2                AC <= REG_M2 + AC
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 13'b0_0000_0000_0001;
            selAR <= 0;
            busMUX <= 7;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 3'b100;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `INCC2_1 : begin       //INC REG C2               REG C2 <= C2+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 6'b00_0010;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `INCC3_1 : begin       //INC REG C3                REG C3 <= C3+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 6'b00_0001;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `INCM2_1 : begin       //INC reg m2                REG M2 <= M2+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 6'b01_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `INCK2_1 : begin       //INC REG K2               REG K2 <= K2+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 6'b00_1000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `INCN2_1 : begin       //INC REG N2               REG N2 <= N2+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 6'b00_0100;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `FETCH_1;
            coreS <= 0;
        end
        `ENDOP_1 : begin       //INC REG N2               REG N2 <= N2+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            NEXT_STATE <= `ENDOP_1;
            coreS <= 1;
        end

    endcase
        

        
end
endmodule
