module fanout_TESTBENCH; 

    reg [NUM_BITS_ADDR-1:0] source_neuron_address;
    wire [ADDRSIZE-1:0] dest_neuron_address;

    parameter NUM_BITS_ADDR = 12;           // The number of neurons in an accelerator
    parameter NUM_CONNECTIONS = 5;

    parameter ADDRSIZE = NUM_BITS_ADDR * NUM_CONNECTIONS;            // The number of address bits needed to identify a neuron x 5 
                                        // For all 5 downstream neurons

    fanout_mem f1(source_neuron_address, dest_neuron_address);

    // Print the outputs whenever the inputs change
    initial
    begin
        $monitor($time, "  source_neuron_address: %b           dest_neuron_address: %b", source_neuron_address, dest_neuron_address);
    end

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("fanoutmem_wavedata.vcd");
        $dumpvars(0,fanout_TESTBENCH);
    end

    initial
    // Assign the inputs
    begin 

        source_neuron_address = 12'b000000000000;

        #2

        source_neuron_address = 12'b000000000010;

        #3

        source_neuron_address = 12'b000000000001;

        #10

        $finish;

    end

    // //invert clock every 4 seconds
    // always
    //     #4 CLK = ~CLK;

endmodule