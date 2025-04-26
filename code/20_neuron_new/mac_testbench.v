`timescale 1ns/1ns
`include "mac0.v"

module mac_testbench ();
    
    reg clk;
    reg[31:0] input_weight;
    
    initial begin
        clk=0;
        #5 input_weight = 32'd5;
        #5 input_weight = 32'd10;
        #5 input_weight = 32'd5;
        #5 input_weight = 32'd5;
    end

    always #5 clk = ~clk;
endmodule