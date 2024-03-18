module testbench;

    reg CLK;
    reg [3:0] spike_in;
    reg [127:0] weights_in;
    wire [31:0] result;

    mac m1(CLK, spike_in, weights_in, result);

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, "  spike_in: %b           weights_in: %b              result: %b", spike_in, weights_in, result);
    end

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("mac_wavedata.vcd");
        $dumpvars(0,testbench);
    end

    initial
    // Assign the inputs
    begin 

        CLK = 1'b0;
        // 0.1, 2, 1.2, 3
        // 00111101110011001100110011001101
        // 01000000000000000000000000000000
        // 00111111100110011001100110011010
        // 01000000010000000000000000000000
        weights_in = 128'd82146290175160474081457091226028212224;         // IEEE format 

        #3

        spike_in  = 4'd0;
        #8

        spike_in  = 4'd1;
        #8

        spike_in  = 4'd0;
        #8

        spike_in  = 4'd1;
        #8

        spike_in  = 4'd1;
        #8

        spike_in  = 4'd0;
        #8

        $finish;

    end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;

endmodule