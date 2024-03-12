module adder(
    input wire [31:0] v_threshold,
    input wire [31:0] weight, 
    input wire [31:0] decayed_potential, 
    output reg [31:0] potential, 
    output reg spike);

    // Addition and comparison
    
    // First add the connection inputs to the decayed
    assign potential = weight + decayed_potential;

    // Compare to see if spiked
    assign spike = potential >= v_threshold;     


endmodule