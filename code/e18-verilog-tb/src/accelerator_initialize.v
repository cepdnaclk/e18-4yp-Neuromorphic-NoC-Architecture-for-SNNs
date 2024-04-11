`timescale 1ns/100ps
`include "potential_decay.v"

module accelerator_initialize;

    parameter  number_of_neurons=10;                        //initiailize number of neurons
    reg CLK;                                                //clock
    reg clear;                                              //clear to start timestep
    reg[4:0] decay_rate;                                    //define decay rate
    reg[3:0] CLK_count;                                     //counter for clocks

    reg[11:0] source_addresses[0:number_of_neurons-1];          //write her simulate spike packets by sending source addresses
    reg[159:0] weights_arrays[0:number_of_neurons-1];           //initialize store weights of the connections
    reg[59:0] source_addresses_arrays[0:number_of_neurons-1];   //initialize connection by writing source addresses to the accumulators
    reg[11:0] neuron_addresses[0:number_of_neurons-1];          //initialize with neuron addresses
    reg[31:0] membrane_potential[0:number_of_neurons-1];        //initialize membrane potential values

    wire [31:0] results_mac[0:number_of_neurons-1];               //store results from the mac
    wire [31:0] results_potential_decay[0:number_of_neurons-1];   //store results of potential decay
    wire [31:0] results_potential_adder[0:number_of_neurons-1];     //store results of potential adder

    //test membrane potential
    potential_decay potential_decay_1(CLK,clear,neuron_addresses[0], decay_rate,membrane_potential[0], results_potential_decay[0]);

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

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("accelerator_initialize.vcd");
        $dumpvars(0,accelerator_initialize);
    end

    //assign inputs
    initial begin
        CLK = 1'b0;
        CLK_count = 0;
        clear = 1'b0;
        decay_rate = 4'd8;

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

        #100
        $finish;   
    end

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, " Membrane Potential: %b\n                     Decay Rate: %d\n                     After Potential Decay: %b", membrane_potential[0], decay_rate, results_potential_decay[0]);
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