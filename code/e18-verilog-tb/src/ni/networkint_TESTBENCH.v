module networkint_TESTBENCH; 

    reg [NUM_BITS_ADDR-1:0] source_neuron_address;
    wire stays;

    parameter NUM_BITS_ADDR = 12;           // The number of neurons in an accelerator

    network_interface n1(source_neuron_address, stays);

    // Print the outputs whenever the inputs change
    initial
    begin
        $monitor($time, "  source_neuron_address: %b           stays: %b", source_neuron_address, stays);
    end

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("networkinterface_wavedata.vcd");
        $dumpvars(0,networkint_TESTBENCH);
    end

    initial
    // Assign the inputs
    begin 

        source_neuron_address = 12'b000000000000;

        #5


        $finish;

    end

    // //invert clock every 4 seconds
    // always
    //     #4 CLK = ~CLK;

endmodule