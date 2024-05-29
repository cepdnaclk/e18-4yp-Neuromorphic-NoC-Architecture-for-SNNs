module main_decoder(op, zero, RegWrite, MemWrite, ResultSrc, ALUSrc, ImmSrc, ALUOp, PCSrc);

    input wire zero;
    input wire [6:0] op;

    output reg RegWrite, MemWrite, ResultSrc, ALUSrc, PCSrc;
    output reg [1:0] ImmSrc, ALUOp;

    //intermediate wires
    wire branch;

    assign RegWrite = ((op == 7'b0000011) | (7'b0110011)) ? 1'b1 : 1'b0;

    assign MemWrite = (op == 7'b0100011) ? 1'b1: 1'b0;

    assign ResultSrc = (op == 7'b0000011) ? 1'b1: 1'b0;

    assign ALUSrc = ((op == 7'b0000011) | (7'b0100011)) ? 1'b1 : 1'b0;

    assign branch = (op == 7'b1100011) ? 1'b1: 1'b0;

    assign ImmSrc = (op == 7'b0100011) ? 2'b01:
                    (op == 7'b1100011) ? 2'b10: 2'b00;

    assign ALUOp =  (op == 7'b0110011) ? 2'b10:
                    (op == 7'b1100011) ? 2'b01: 2'b00;

    assign PCSrc = zero & branch;

endmodule