module dmem_controller (parameter WIDTH = 8) (
    input Clk,
    input [WIDTH-1:0] AR_1, AR_2, AR_3, AR_4,
    input [WIDTH-1:0] DR_1,DR_2, DR_3, DR_4,
    input [WIDTH-1:0] MEM,   //from DRAM
    input [2:0] coreID,
    input mread_en1, mread_en2, mread_en3, mread_en4,
    input mwrite_en1, mwrite_en2, mwrite_en3, mwrite_en4
    output reg mread_en,
    output reg mwrite_en,
    output reg MEM_1, MEM_2, MEM_3, MEM_4,
    output reg [WIDTH-1:0]Addrs, //to DRAM
    output reg memAV1, memAV2, memAV3, memAV4
    );

    localparam NORM = 3'b000;
    localparam EXP_1 = 3'b001;
    localparam EXP_2 = 3'b010;
    localparam EXP_3 = 3'b011;
    localparam DONE = 3'b100;

    // reg [2:0]NEXT_STATE_DC=2'b00;
    // reg [2:0] STATE_DC = 2'b00;


    always @(negedge Clk) begin
        // STATE_DC = NEXT_STATE_DC;
        // case(STATE_DC) 
        //     NORM:
        //         if(AR_1==AR_2==AR_3==AR_4) begin
        //             MEM_1 <= MEM;
        //             MEM_2 <= MEM;
        //             MEM_3 <= MEM;
        //             MEM_4 <= MEM;
        //             NEXT_STATE_DC <= DONE;
        //         end
        //     EXP_1:

        // endcase
        if(mread_en1==1 && mread_en2==1 && mread_en3==1 && mread_en4==1 )
        if (AR_1==AR_2==AR_3==AR_4) begin

        
        end
        
            
        
        
       


        
    end

    

    

