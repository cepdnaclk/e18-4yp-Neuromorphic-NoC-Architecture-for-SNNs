module testbench;

    reg [3:0] spike_in;
    reg [127:0] weight;
    reg [31:0] v_threshold;
    reg [31:0] decayed_potential;

    wire spiked;
    wire [31:0] potential_to_mem;

    accelerator a1(spike_in, weight, v_threshold, decayed_potential, spiked, potential_to_mem);

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, "  spike_in: %b             weight: %b              v_threshold: %b     decayed_potential: %b           spiked: %b              potential_to_mem: %b",spike_in, weight, v_threshold, decayed_potential, spiked, potential_to_mem);
    end

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("accelerator_wavedata.vcd");
        $dumpvars(0,testbench);
    end

    initial
    // Assign the inputs
    begin 
        spike_in  = 4'd0;
        weight = 128'd64;
        v_threshold = 32'd78;
        decayed_potential = 32'd20;


        $finish;

    end

endmodule