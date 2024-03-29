`include "potential_adder.v"
`timescale 1ns/100ps

module adder_testbench;

    reg CLK;
    reg [31:0] v_threshold;
    reg [31:0] input_weight; 
    reg [31:0] decayed_potential; 
    wire [31:0] potential;
    wire spike;

    //test adder
    potential_adder potential_adder_1(v_threshold, input_weight, decayed_potential, potential, spike);

    //record on gtkwave
    initial begin
        $dumpfile("adder_testbench.vcd");
        $dumpvars(0, adder_testbench);
        #100
        $finish;
    end

    //assign inputs
    initial begin
        CLK = 1'b0;

        v_threshold= 32'b01000001011100000000000000000000;
        input_weight=32'b01000000101000000000000000000000;
        decayed_potential=32'b01000000100000000000000000000000;
    end

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, " Accumalator Input: %b\n                     Potential Decay Input: %b\n                     Threshold: %b\n                     Output Potential: %b\n                     Spiked:%b", input_weight,decayed_potential,v_threshold, potential, spike);
    end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;
endmodule