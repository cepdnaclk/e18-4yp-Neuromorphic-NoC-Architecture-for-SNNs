module switches_to_LEDs(
    //port section
    input [N-1:0] i_switch,
     output [N-1:0] o_LED
    );

    parameter N = 4;
    assign o_LED = i_switch;

endmodule