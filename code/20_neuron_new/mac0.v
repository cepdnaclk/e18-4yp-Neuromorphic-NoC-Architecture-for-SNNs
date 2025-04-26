// MAC unit can process 4 input spikes together
// 4 spike inputs  
// 4 weights corresponding to the synapse

/*  Floating point addition
    Moving through the next four connections ?*/
`timescale 1ns/1ns
// `include "Addition_Subtraction.v"
 

module mac0(
    
    input wire clk,                             //input clock
	input wire set,								//set signal for initialisation
    //input wire[11:0] neuron_address,            //neuron address
    input wire[31:0] weight_in,            //source address of 12 bits
    input reset,
    //input wire[160-1:0] weights_array,            //weights array used during intialization 32x5=160 bits
    //input wire[60-1:0] source_addresses_array,          //corresponding source address array used during initialization 12x5=60 bits
    //input wire clear,                       //signal to signify the end of the timestep
	//input wire [31:0]SET_Count,
    output wire[31:0] mult_output               //output of 32 bits to the adder
    );             

    parameter count=0;
    wire exception;                 //addition exception

    Accumulating_Adder add1(clk, reset, weight_in, excpetion, mult_output);
endmodule