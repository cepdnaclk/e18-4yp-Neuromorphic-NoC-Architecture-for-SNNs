module prog_counter(PC_NEXT, PC, reset, clk);

    input [31:0] PC_NEXT;
    input clk, reset;

    output reg[31:0] PC;

    always @(posedge clk) begin
        if(reset == 1'b0) begin
            PC <= 32'h00000000;
        end 
        else begin
            PC <= PC + PC_NEXT;
        end
    end

endmodule