`timescale 1ns / 1ps
`include "acc.v"

module Accumulating_Adder_tb;

    reg clk;
    reg reset;
    reg [31:0] a_operand;
    wire [31:0] result;
    wire Exception;

    // Instantiate the DUT (Design Under Test)
    Accumulating_Adder uut (
        .clk(clk),
        .reset(reset),
        .a_operand(a_operand),
        .Exception(Exception),
        .result(result)
    );

    // Clock generation
    always #5 clk = ~clk;
// Function to convert IEEE-754 bits to real
    // Helper task to display float in hex
    task print_result;
        input [31:0] res;
        begin
            $display("Time: %0t | Result = 0x%08X", $time, res);
        end
    endtask
    initial begin
        $dumpfile("acc_tb.vcd");
        $dumpvars(0,Accumulating_Adder_tb);
    end
    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        a_operand = 32'h00000000; // 0.0
        #10;

        reset = 0;

        // Add 1.0
        a_operand = 32'h3F800000; // 1.0 in IEEE-754
        #10;
        print_result(result);

        // Add 2.0
        a_operand = 32'h40000000; // 2.0 in IEEE-754
        #10;
        print_result(result);

        // Add 4.0
        a_operand = 32'h40800000; // 4.0 in IEEE-754
        #10;
        print_result(result);

        // Add 0.5
        a_operand = 32'h3F000000; // 0.5 in IEEE-754
        #10;
        print_result(result);

        // Reset
        reset = 1;
        #10;
        print_result(result);

        $finish;
    end

endmodule
