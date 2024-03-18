module testbench;

    reg CLK;
    reg [3:0] spike_in;
    reg [127:0] weight;
    reg [31:0] v_threshold;
    reg [31:0] current_potential;
    reg[2:0] decay_rate;

    wire spiked;
    wire [31:0] potential_to_mem;

    accelerator a1(CLK, spike_in, weight, v_threshold, current_potential,decay_rate, spiked, potential_to_mem);

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, "  spike_in: %b             weight: %b              v_threshold: %b     decayed_potential: %b           spiked: %b              potential_to_mem: %b",spike_in, weight, v_threshold, current_potential, spiked, potential_to_mem);
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
        CLK= 1'b0;

        #3
        spike_in  = 4'd0;
        weight = 128'd64;
        v_threshold = 32'd78;
        current_potential = 32'd20;
        decay_rate = 3'd4;

        #8


        $finish;

    end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;

endmodule