`timescale 1ns/100ps
`include "potential_decay.v"
`include "mac.v"
`include "Addition_Subtraction.v"

module accelerator_initialize;

    parameter  number_of_neurons=10;                        //initiailize number of neurons
    reg CLK;                                                //clock
    reg clear;                                              //clear to start timestep
    reg[3:0] decay_rate;                                    //define decay rate
    reg[3:0] CLK_count;                                     //counter for clocks

    reg[11:0] source_addresses[0:number_of_neurons-1];          //write her simulate spike packets by sending source addresses
    reg[159:0] weights_arrays[0:number_of_neurons-1];           //initialize store weights of the connections
    reg[59:0] source_addresses_arrays[0:number_of_neurons-1];   //initialize connection by writing source addresses to the accumulators
    reg[11:0] neuron_addresses[0:number_of_neurons-1];          //initialize with neuron addresses
    reg[31:0] membrane_potential[0:number_of_neurons-1];        //initialize membrane potential values

    wire [31:0] results_mac[0:number_of_neurons-1];               //store results from the mac
    wire [31:0] results_potential_decay[0:number_of_neurons-1];   //store results of potential decay
    wire [31:0] results_potential_adder[0:number_of_neurons-1];     //store results of potential adder

    // //test membrane potential
    // potential_decay potential_decay_1(CLK, clear, neuron_addresses[0], decay_rate, membrane_potential[0], results_potential_decay[0]);

    //generate 10 potential decay units
    genvar i;
    generate
        for(i=0; i<10; i=i+1) begin
            potential_decay pd(
                .CLK(CLK),
                .clear(clear),
                .neuron_address_initialization(neuron_addresses[i]),
                .decay_rate(decay_rate),
                .membrane_potential_initialization(membrane_potential[i]),
                .output_potential_decay(results_potential_decay[i])
            );
        end
    endgenerate

    //generate 10 accumulators
    generate
        for(i=0; i<10; i=i+1) begin
            mac m(
                .CLK(CLK),
                .neuron_address(neuron_addresses[i]),
                .source_address(source_addresses[i]),
                .weights_array(weights_arrays[i]),
                .source_addresses_array(source_addresses_arrays[i]),
                .clear(clear),
                .mult_output(results_mac[i])
            );
        end
    endgenerate


    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("accelerator_initialize.vcd");
        $dumpvars(0, accelerator_initialize);
    end

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, "  Neuron_address: %b\n                     Membrane Potential: %b\n                     Decay Rate: %d\n                     After Potential Decay: %b\n                      Source_address: %b\n                     MAC result: %b\n", neuron_addresses[6], membrane_potential[6], decay_rate, results_potential_decay[6], source_addresses[0], results_mac[6]);
    end

    // //assign inputs
    initial begin
        CLK = 1'b0;
        CLK_count = 0;
        clear = 1'b0;
        decay_rate = 4'b1000;

        //neuron addresses
        neuron_addresses[0] = 12'd0;
        neuron_addresses[1] = 12'd1;
        neuron_addresses[2] = 12'd2;
        neuron_addresses[3] = 12'd3;
        neuron_addresses[4] = 12'd4;
        neuron_addresses[5] = 12'd5;
        neuron_addresses[6] = 12'd6;
        neuron_addresses[7] = 12'd7;
        neuron_addresses[8] = 12'd8;
        neuron_addresses[9] = 12'd9;


        //initial membrane potential values
        membrane_potential[0] = 32'h41deb852;
        membrane_potential[1] = 32'h42806b85;
        membrane_potential[2] = 32'h40b75c29;
        membrane_potential[3] = 32'h4228b852;
        membrane_potential[4] = 32'h42aeb852;
        membrane_potential[5] = 32'h429deb85;
        membrane_potential[6] = 32'h4165eb85;
        membrane_potential[7] = 32'h4212147b;
        membrane_potential[8] = 32'h428e2e14;
        membrane_potential[9] = 32'h411a147b;

        //send source addresses array first
        source_addresses_arrays[0] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[1] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[2] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[3] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[4] = {12'd1, 12'd2, 12'd5, 12'd0, 12'd0};
        source_addresses_arrays[5] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[6] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[7] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[8] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[9] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};

        //assign the weights
        weights_arrays[0] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[1] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[2] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[3] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[4] = {32'h423f47ae, 32'h4109999a, 32'h0, 32'h0, 32'h0};
        weights_arrays[5] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[6] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[7] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[8] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[9] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};

        #40
        source_addresses[6] = 12'd3;
        source_addresses[4] = 12'd1;

        #4
        source_addresses[6] = 12'd4; 
        source_addresses[4] = 12'd2; 

        #4
        source_addresses[6] = 12'd5;

        #4
        source_addresses[4] = 12'd7; 

        #100
        $finish;   
    end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;

    //timestep is 4 clockcycles
    always @(posedge CLK) begin

        if(CLK_count==3) begin
            CLK_count=0;
            clear = 1'b1;
        end else begin
            CLK_count = CLK_count+1;
        end

        if(CLK_count==1) begin
            clear = 1'b0;
        end
    end

endmodule