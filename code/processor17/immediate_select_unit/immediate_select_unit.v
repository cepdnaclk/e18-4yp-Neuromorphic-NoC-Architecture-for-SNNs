`timescale 1ns/100ps

module immediate_select_unit (INSTRUCTION, SELECT, OUTPUT);

    input [31:0] INSTRUCTION;
    input [2:0] SELECT;
    output reg [31:0] OUTPUT;

    wire[31:0] TYPE_I, TYPE_S, TYPE_B, TYPE_U, TYPE_J;

    // Immediate value encodings for each type
    assign TYPE_I = {{21{INSTRUCTION[31]}}, INSTRUCTION[30:20]};
    assign TYPE_S = {{21{INSTRUCTION[31]}}, INSTRUCTION[30:25], INSTRUCTION[11:7]};
    assign TYPE_B = {{20{INSTRUCTION[31]}}, INSTRUCTION[7], INSTRUCTION[30:25], INSTRUCTION[11:8], 1'b0};
    assign TYPE_U = {INSTRUCTION[31:12], 12'b0};
    assign TYPE_J = {{12{INSTRUCTION[31]}}, INSTRUCTION[19:12], INSTRUCTION[20], INSTRUCTION[30:21], 1'b0};

    always @ (*)
    begin
        case (SELECT)
            3'b000:
                OUTPUT = TYPE_U;

            3'b001:
                OUTPUT = TYPE_J;

            3'b010:
                OUTPUT = TYPE_I;

            3'b011:
                OUTPUT = TYPE_B;

            3'b100:
                OUTPUT = TYPE_S;
                
            default:
                OUTPUT = 32'b0;
        endcase
    end

    /*     wire [19:0] TYPE1, TYPE2;
        wire [11:0] TYPE3, TYPE4, TYPE5;
        wire [4:0] TYPE6;


        // Combinations
        assign TYPE1 = INSTRUCTION[31:12];  //  U - Immediate
        assign TYPE2 = INSTRUCTION[31:12];  // J - Immediate
        assign TYPE3 = INSTRUCTION[31:20];
        assign TYPE4 = {INSTRUCTION[31:25],INSTRUCTION[11:7]};
        assign TYPE5 = {INSTRUCTION[31:25],INSTRUCTION[11:7]};
        assign TYPE6 = INSTRUCTION[29:25];


    // SELECT[3] == 1'b1 used for unsigned

    always @(*)begin
        case (SELECT[2:0])
            // TYPE 1 - U  (LUI. AUIPC)
            3'b000:
                OUTPUT = {TYPE1, {12{1'b0}}};
            // TYPE 2 - J (JAL)
            3'b001:
                // leave this for now else: by default
                if(SELECT[3] == 1'b1)
                    OUTPUT = {{11{1'b0}},TYPE2,1'b0};
                else
                    // seperate INSTRUCTION[31] on 2nd position to show similarity with signed
                    OUTPUT = {{11{INSTRUCTION[31]}},INSTRUCTION[31], INSTRUCTION[19:12],INSTRUCTION[20], INSTRUCTION[30:21],1'b0}; 
            // TYPE 3 - I (ADDI , ...., LB, .. , JALR)
            3'b010:
                if(SELECT[3] == 1'b1)
                    OUTPUT = {{20{1'b0}},TYPE3};
                else
                    OUTPUT = {{20{TYPE3[11]}}, TYPE3};
            // TYPE 4 - B (BEQ)
            3'b011:
                if (SELECT[3] == 1'b1)
                    OUTPUT = {{20{1'b0}},INSTRUCTION[31],INSTRUCTION[7],INSTRUCTION[30:25],INSTRUCTION[11:8],1'b0};
                else
                    OUTPUT = {{20{INSTRUCTION[31]}},INSTRUCTION[31],INSTRUCTION[7],INSTRUCTION[30:25],INSTRUCTION[11:8],1'b0};
            // Type 5 - S (SB, SH, SW)
            3'b100:
                if (SELECT[3] == 1'b1)
                    OUTPUT = {{20{1'b0}}, TYPE5};
                else
                    OUTPUT = {{20{TYPE5[11]}}, TYPE5};
            // Type 6 (SLLI, SRLI, SRAI)
            3'b101:
                OUTPUT = {{27{1'b0}}, TYPE6};
        endcase
    end */

endmodule