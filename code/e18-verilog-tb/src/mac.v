// MAC unit can process 4 input spikes together

module mac():

    input wire [3:0] beta;
    input wire [7:0] potential;
    output reg [7:0] mult_ans;

    always @(*) begin 
        case (beta) 
            4'd0:   mult_ans <= 0;                  // No spikes in any of the 4 branches.
            4'd1;   mult_ans <= potential >> 3; 
            4'd2:   mult_ans <= potential >> 2;
            4'd3:   mult_ans <= (potential >> 2) + (potential >> 3);
            4'd4:   mult_ans <= (potential >> 1); 
            4'd5:   mult_ans <= (potential >> 1) + (potential >> 3);
            4'd6:   mult_ans <= (potential >> 1) + (potential >> 2);
            4'd7:   mult_ans <= (potential >> 1) + (potential >> 2) + (potential >> 3);
            4'd8:   mult_ans <= potential;
            default:    mult_ans <= 4'bx;
        endcase
    end


endmodule