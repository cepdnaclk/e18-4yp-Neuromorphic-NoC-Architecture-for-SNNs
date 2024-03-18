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

        #3
        spike_in  = 4'd0;
        weights_in = 128'd18321983;

        #8

        spike_in  = 4'd1;
        weights_in = 128'd18321983;

        #8

        spike_in  = 4'd0;
        weights_in = 128'd18321983;

        #8

        spike_in  = 4'd1;
        weights_in = 128'd18321983;

        #8

        spike_in  = 4'd1;
        weights_in = 128'd18321983;

        #8

        spike_in  = 4'd0;
        weights_in = 128'd18321983;

        #8

        $finish;

    end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;

endmodule