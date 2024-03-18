module potential_adder(
    input wire [31:0] v_threshold,
    input wire [31:0] input_weight, 
    input wire [31:0] decayed_potential, 
    output reg [31:0] potential, 
    output wire spike);

    wire Exception;
    wire [31:0] add_value;

    // Addition
    Addition_Subtraction Addition_Subtraction_2(input_weight, decayed_potential, 1'b0, Exception, add_value);
    
    always@(*) begin
        potential = add_value;
    end 

    // // First add the connection inputs to the decayed potential
    // assign potential = input_weight + decayed_potential;

    // Compare to see if spiked
    assign spike = (potential >= v_threshold);     


endmodule