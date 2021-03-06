module dmem_controller#(parameter WIDTH=8)(
    input Clk,
    input coreS_1, coreS_2, coreS_3,coreS_4,
    input [WIDTH-1:0] AR_1, AR_2, AR_3,AR_4,
    input [WIDTH-1:0] DR_1, DR_2, DR_3, DR_4,    
    input [WIDTH-1:0]MEM,                                       //from DRAM
    input memREAD_1, memREAD_2, memREAD_3,memREAD_4,
    input memWE_1, memWE_2, memWE_3,memWE_4,
    output reg rEN,
    output reg wEN,
    output reg [WIDTH-1:0] MEM_1, MEM_2, MEM_3,MEM_4,       
    output reg [WIDTH-1:0] addr,                                //to DRAM
    output reg [WIDTH-1:0] DR_OUT,
    output reg memAV1, memAV2, memAV3,memAV4                    //to cores
);
localparam NORM = 4'b0000;
localparam NORMEND = 4'b0001;
localparam AR_1_2 = 4'b0010;
localparam AR_2_1 = 4'b0011;
localparam AR_2_2 = 4'b0100;
localparam AR_3_1 = 4'b0101;
localparam AR_3_2 = 4'b0110;
localparam AR_4_1 = 4'b0111;
localparam AR_4_2 = 4'b1000;
localparam DR_1_1 = 4'b1001;
localparam DR_1_2 = 4'b1010;
localparam DR_1_3 = 4'b1011;

reg [3:0] NEXT_STATE_DC=NORM;
reg [3:0] STATE_DC = NORM;

always @(posedge Clk) begin
    STATE_DC=NEXT_STATE_DC;
    case (STATE_DC)
     NORM: begin
        memAV1 <= 0;
        memAV2 <= 0;
        memAV3 <= 0;
        memAV4 <= 0;
        rEN <= 0;
        wEN <= 0;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
            if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1 && memREAD_4==1) begin
                if(AR_1==AR_2 && AR_2==AR_3 && AR_3==AR_4) begin // Active 4 cores, same addresses
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                    memAV4 <= 1;

                end
                else begin           // Active 4 cores, different addresses
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;
                end 
              end
              else if(memWE_1==1 && memWE_2==1 && memWE_3==1 && memWE_4==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  memAV4 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
              if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1) begin
                  if(AR_1==AR_2 && AR_2==AR_3) begin //TODO
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                end
                else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;
                end
              end
              else if(memWE_1==1 && memWE_2==1 && memWE_3==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
              
          end 

          else if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
              if(memREAD_1==1 && memREAD_2==1) begin
                  if(AR_1==AR_2) begin //TODO
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                end
                else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;
                end
              end
              else if(memWE_1==1 && memWE_2==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
              
          end 

          else if (coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1) begin
              if(memREAD_1==1) begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
              end
              else if(memWE_1==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 1;
                  NEXT_STATE_DC <= NORM;
              end
              
          end 

          
      end
      NORMEND: begin
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            MEM_4 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
          end

          else if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
          end

          else if (coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
          end
          
          NEXT_STATE_DC <= NORM;
           
      end

      AR_1_2: begin
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0; 
            NEXT_STATE_DC <= AR_2_1;
              
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            NEXT_STATE_DC <= AR_2_1;
          end

          else if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            NEXT_STATE_DC <= AR_2_1;
          end

          else if (coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            NEXT_STATE_DC <= NORM;
          end
      end

      AR_2_1: begin
          rEN <= 1;
          addr <= AR_2;
          NEXT_STATE_DC <= AR_2_2;
          if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
            memAV1 <= 1;
            memAV2 <= 1; 
          end         
      end

      AR_2_2: begin
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0; 
            NEXT_STATE_DC <= AR_3_1;     
        end

        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0; 
            NEXT_STATE_DC <= AR_3_1;    
        end

        if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            NEXT_STATE_DC <= NORM;   
        end          
      end

      AR_3_1: begin
        rEN <= 1;
        addr <= AR_3;
        NEXT_STATE_DC <= AR_3_2;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin      //when 3 cores are working
            memAV1 <= 1;
            memAV2 <= 1;
            memAV3 <= 1;
        end
      end

      AR_3_2: begin
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0; 
            NEXT_STATE_DC <= AR_4_1;
          end

        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0; 
            NEXT_STATE_DC <= NORM;    
        end

      end

      AR_4_1: begin
        rEN <= 1;
        addr <= AR_4;
        NEXT_STATE_DC <= AR_4_2;
        memAV1 <= 1;
        memAV2 <= 1;
        memAV3 <= 1;
        memAV4 <= 1;
      end

      AR_4_2:begin
          MEM_4 <= MEM;
          memAV1 <= 0;   //added to AR_4_1
          memAV2 <= 0;
          memAV3 <= 0;
          memAV4 <= 0; 
          NEXT_STATE_DC <= NORM;
      end

      DR_1_1:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         NEXT_STATE_DC <= DR_1_2;
        end

        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         NEXT_STATE_DC <= DR_1_2;
        end

        else if(coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 1;
         memAV2 <= 1;
         NEXT_STATE_DC <= NORM;
        end
      end

      DR_1_2:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0) begin
            wEN <= 1;
            addr <= AR_3;
            DR_OUT <= DR_3;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            NEXT_STATE_DC <= DR_1_3;
        end

        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1) begin
            wEN <= 1;
            addr <= AR_3;
            DR_OUT <= DR_3;
            memAV1 <= 1;
            memAV2 <= 1;
            memAV3 <= 1;
            NEXT_STATE_DC <= NORM;
        end
        
      end

      DR_1_3:begin
        wEN <= 1;
        addr <= AR_4;
        DR_OUT <= DR_4;
        memAV1 <= 1;
        memAV2 <= 1;
        memAV3 <= 1;
        memAV4 <= 1;
        NEXT_STATE_DC <= NORM;
      end



    endcase
    
end



endmodule


/*always @(negedge Clk) begin
    if (coreS_1==1 && coreS_2==1 && coreS_3==1) begin
        if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1) begin
            if(AR_1==AR_2==AR_3) begin
                iRAMR1 <= 1;    
            end
            else begin
                iRAMR1 <= 1;
                iRAMR2 <= 1;
                iRAMR3 <= 1;
            end
            
        end
        else if (memWE_1==1 && memWE==1 && memWE==1) begin
            iRAMW1 <= 1;
            iRAMW2 <= 1;
            iRAMW3 <= 1;

        end
    end
    else if(coreS_1==1 && coreS_2==1 && coreS_3==0) begin
        if(memREAD_1==1 && memREAD_2==1) begin
            if(AR_1==AR_2==) begin
                iRAMR1 <= 1;    
            end
            else begin
                iRAMR1 <= 1;
                iRAMR2 <= 1;
            end
            
        end
        else if (memWE_1==1 && memWE==1) begin
            iRAMW1 <= 1;
            iRAMW2 <= 1;

        end
    end
    else if(coreS_1==1 && coreS_2==0 && coreS_3==0) begin
        if(memREAD_1==1) begin
            iRAMR1 <= 1;
    
        end
        else if (memWE_1==1) begin
            iRAMW1 <= 0;                
        end
    end
    
end*/