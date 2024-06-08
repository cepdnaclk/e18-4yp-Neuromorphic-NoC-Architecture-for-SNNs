`timescale 1ns/100ps

module branch_control_unit (DATA1, DATA2, SELECT, BJ_SIG);

    input [31:0] DATA1, DATA2;
    input [3:0] SELECT;
    output reg BJ_SIG;

    // Wires to hold intermediate calculations
    wire BEQ, BNE, BLT, BGE, BLTU, BGEU;

    // Comparison calculations
    assign BEQ = DATA1 == DATA2;
    assign BNE = DATA1 != DATA2;
    assign BLT = $signed(DATA1) < $signed(DATA2);
    assign BGE = $signed(DATA1) >= $signed(DATA2);
    assign BLTU = $unsigned(DATA1) < $unsigned(DATA2);
    assign BGEU = $unsigned(DATA1) >= $unsigned(DATA2);

    always @ (*)
    begin
        #2 
        if (SELECT[3])      // SELECT[3] = 1 means the instruction is a branch/jump instruction
        begin
            case (SELECT[2:0])
                // for JAL and JALR
                3'b010:
                    BJ_SIG = 1'b1; 
                // for BEQ
                3'b000:
                    BJ_SIG = BEQ;
                // for BNE
                3'b001:
                    BJ_SIG = BNE;
                // for BLT
                3'b100:
                    BJ_SIG = BLT;
                // for BGE
                3'b101:
                    BJ_SIG = BGE;
                // for BLTU
                3'b110:
                    BJ_SIG = BLTU; 
                // for BGEU
                3'b111:
                    BJ_SIG = BGEU; 
                default:
                    BJ_SIG = 1'b0;
            endcase
        end
        else
        begin
            BJ_SIG = 1'b0;
        end
    end
    
endmodule