`include "potential_decay.v"
`timescale 1ns/100ps

module test_potential_decay;

    reg CLK;
    wire[31:0] output_potential;
    reg[31:0] input_potential;
    reg[2:0] decay_rate;

    //test membrane potential value 4. Divided by 2 is 2
    potential_decay potential_decay_1(CLK,decay_rate,input_potential, output_potential);

    //record on gtkwave
    initial begin
        $dumpfile("test_potential_decay.vcd");
        $dumpvars(0, test_potential_decay);
        #100
        $finish;
    end

    //assign inputs
    initial begin
        CLK = 1'b0;
        decay_rate = 3'd1;
        input_potential = 32'b01000001001000000000000000000000;
    end

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, " Input Potential: %b\n                     After Potential Decay: %b", input_potential, output_potential);
    end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;
endmodule