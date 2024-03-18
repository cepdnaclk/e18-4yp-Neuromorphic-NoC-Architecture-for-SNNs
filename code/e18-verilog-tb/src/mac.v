// MAC unit can process 4 input spikes together
// 4 spike inputs 
// 4 weights corresponding to the synapse

/*  Floating point addition
    Moving through the next four connections ?*/

module mac(input wire CLK,
    input wire [3:0] spike_in, 
    input wire [127:0] weight, 
    output reg [31:0] mult_output);

    reg [127:0] mask;
    reg [127:0] mult_ans;

    // For floating point addition
    wire excpetion1, excpetion2, exception3;
    wire [31:0] add_val1, add_val2, add_val3;


    always @(posedge CLK) begin 
        case (spike_in) 
            4'd0:   mult_output = 32'b0;                  // No spikes in any of the 4 branches.
            4'd1: begin
                mask = 128'b0;
                mask[31:0] = 32'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd2: begin
                mask = 128'b0;
                mask[63:32] = 32'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd3: begin
                mask = 128'b0;
                mask[63:0] = 32'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd4: begin
                mask = 128'b0;
                mask[95:64] = 32'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd5: begin
                mask = 128'b0;
                mask[31:0] = 32'd4294967295; 
                mask[95:64] = 32'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd6: begin
                mask = 128'b0;
                mask[95:32] = 32'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd7: begin
                mask = 128'b0;
                mask[95:0] = 64'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd8: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;   
                mult_ans = weight & mask; 
            end
            4'd9: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[31:0] = 32'd4294967295;
                mult_ans = weight & mask; 
            end
            4'd10: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[63:32] = 32'd4294967295;
                mult_ans = weight & mask; 
            end
            4'd11: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[63:0] = 64'd4294967295;
                mult_ans = weight & mask; 
            end
            4'd12: begin
                mask = 128'b0;
                mask[127:64] = 64'd4294967295;
                mult_ans = weight & mask; 
            end
            4'd13: begin
                mask = 128'b0;
                mask[127:96] = 32'd4294967295;  
                mask[31:0] = 32'd4294967295;
                mult_ans = weight & mask; 
            end
            4'd14: begin
                mask = 128'b0;
                mask[127:32] = 96'd4294967295;
                mult_ans = weight & mask; 
            end
            4'd15: begin
                mult_ans = weight;
            end
            default:    mult_ans = 4'bx;
        endcase
        
        // mult_output = mult_ans[31:0] + mult_ans[63:32] + mult_ans[95:64] + mult_ans[127:96];
        // mult_output = add_val3;
    end

    Addition_Subtraction add1(mult_ans[31:0], mult_ans[63:32], 1'b0, excpetion1, add_val1);
    Addition_Subtraction add2(add_val1, mult_ans[95:64], 1'b0, excpetion2, add_val2);
    Addition_Subtraction add3(add_val2, mult_ans[127:96], 1'b0, exception3, add_val3);

    always@(add_val3 or spike_in) begin
        mult_output = add_val3;
    end

endmodule