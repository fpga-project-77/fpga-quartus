module imem_controller#(parameter WIDTH=8)(
    input Clk,
    input iROMREAD_1, iROMREAD_2, iROMREAD_3,iROMREAD_4,                //rEn signals from each core
    input coreS_1, coreS_2, coreS_3,coreS_4,                            //core states from each core
    input [WIDTH-1:0] PC_1, PC_2, PC_3,PC_4,                            //addresses from each core
    input [WIDTH-1:0]INS,                                               //Instruction from IROM
    output reg rEN,                                                     //rEn signal to IROM
    output reg [WIDTH-1:0] PC_OUT,                                      //read address to IROM
    output reg [WIDTH-1:0]INS_1, INS_2, INS_3,INS_4,                    //read instructions to cores
    output reg imemAV1, imemAV2, imemAV3,imemAV4                        //IROM read state signal to each core
);
localparam NORMI = 3'b000;
localparam NORMENDI = 3'b001; 

reg [2:0] NEXT_STATE_IC=NORMI;
reg [2:0] STATE_IC=NORMI;



always @(negedge Clk) begin
    STATE_IC = NEXT_STATE_IC;
    case (STATE_IC)
    NORMI:
        if ((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1 && iROMREAD_4==1) begin
                rEN <= 1;
                PC_OUT <= PC_1;
                NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;
                imemAV4 <= 1;
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                imemAV4 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;              
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if(coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
            if(iROMREAD_1==1 && iROMREAD_2==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if(coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1) begin
            if(iROMREAD_1==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end
    
    NORMENDI:
      if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        INS_4 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        imemAV4 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

      else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

     else if(coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
        INS_1 <= INS;
        INS_2 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        NEXT_STATE_IC <= NORMI;     
     end

      else if(coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1) begin
        INS_1 <= INS;
        imemAV1 <= 1;
        NEXT_STATE_IC <= NORMI;     
     end

    endcase

end

endmodule
    
    
    
    
    
    
    
    
    
   