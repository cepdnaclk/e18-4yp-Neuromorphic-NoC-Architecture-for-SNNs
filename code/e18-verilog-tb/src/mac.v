// MAC unit can process 4 input spikes together
// 4 spike inputs 
// 4 weights corresponding to the synapse

module mac(input wire [3:0] spike_in, input wire [127:0] weight, output reg [127:0] mult_ans);

    reg [127:0] mask;

    always @(*) begin 
        case (spike_in) 
            4'd0:   mult_ans <= 0;                  // No spikes in any of the 4 branches.
            4'd1: begin
                mask = 128'b0;
                mask[31:0] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd2: begin
                mask = 128'b0;
                mask[63:32] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd3: begin
                mask = 128'b0;
                mask[63:0] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd4: begin
                mask = 128'b0;
                mask[95:64] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd5: begin
                mask = 128'b0;
                mask[31:0] = 32'd4294967295; 
                mask[95:64] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd6: begin
                mask = 128'b0;
                mask[95:32] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd7: begin
                mask = 128'b0;
                mask[95:0] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd8: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;   
                mult_ans <= weight & mask; 
            end
            4'd9: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[31:0] = 32'd4294967295;
                mult_ans <= weight & mask; 
            end
            4'd10: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[63:32] = 32'd4294967295;
                mult_ans <= weight & mask; 
            end
            4'd11: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[63:0] = 32'd4294967295;
                mult_ans <= weight & mask; 
            end
            4'd12: begin
                mask = 128'b0;
                mask[127:64] = 32'd4294967295;
                mult_ans <= weight & mask; 
            end
            4'd13: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[31:0] = 32'd4294967295;
                mult_ans <= weight & mask; 
            end
            4'd14: begin
                mask = 128'b0;
                mask[127:32] = 32'd4294967295;
                mult_ans <= weight & mask; 
            end
            4'd15: begin
                mult_ans <= weight;
            end
            default:    mult_ans <= 4'bx;
        endcase
    end


endmodule