module adder(
    input wire [31:0] v_threshold,
    input wire [31:0] input_weight, 
    input wire [31:0] decayed_potential, 
    output wire [31:0] potential, 
    output wire spike);

    // Addition and comparison
    
    // First add the connection inputs to the decayed
    assign potential = input_weight + decayed_potential;

    // Compare to see if spiked
    assign spike = potential >= v_threshold;     


endmodule