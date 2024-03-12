module (input wire [31:0] adder_potential, 
    input wire spiked, 
    input wire [31:0] v_threshold,
    output reg [31:0] potential_to_mem);

    // Reset if needed only, if not direct write
    if (spiked) begin
        // Reset the potential according to the model
        // V <- V - Vth
        assign potential_to_mem = adder_potential - v_threshold;

    end else
        assign potential_to_mem = potential;

endmodule