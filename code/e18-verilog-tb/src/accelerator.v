module accelerator(
    input wire [3:0] spike_in,
    input wire [127:0] weight,
    input wire [31:0] v_threshold,
    input wire [31:0] decayed_potential,
    output reg spiked,
    output wire [31:0] potential_to_mem);

    // Store connection wires between the three units MAC, Adder and Reset
    wire [31:0] mac_out;
    wire spike_adder;
    wire [31:0] adder_out;

    always @(spike_adder) begin
        assign spiked= spike_adder;
    end

    mac m1(spike_in, weight, mac_out);
    adder a1(v_threshold, mac_out, decayed_potential, adder_out, spike_adder);
    reset r1(adder_out, spike_adder, v_threshold, potential_to_mem);


endmodule