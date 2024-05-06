`timescale 1us/1ns
`include "switches_to_LEDs.v"

module tb_switches_to_LEDs();

    //Testbench variables
    reg [N-1:0] i_switch;
    wire [N-1:0] o_LED;

    parameter N=4;
    //instatiate
    switches_to_LEDs DUT             //name
    (.i_switch(i_switch),   //ports
     .o_LED(o_LED)
    );


    //test scenario
    initial begin
         $monitor($time, "i_switch = %b, o_LED = %b", i_switch, o_LED);

         #1; i_switch = 4'b0000;
         #1; i_switch = 4'b0100;
         #1; i_switch = 4'b1010;
         #1; i_switch = 4'b0101;
         #1; i_switch = 4'b1001;
         #10; $stop;
    end
endmodule