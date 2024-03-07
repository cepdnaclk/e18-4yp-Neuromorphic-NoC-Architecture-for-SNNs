`include "potential_decay.v"
`timescale 1ns/100ps

module test_potential_decay;

    reg CLK;

    //test membrane potential value 4. Divided by 2 is 2
    potential_decay_1 potential_decay(
        .CLK(CLK),
        .delay_rate(1),
        .membrane_potential(32'b01000000100000000000000000000000)
    );

    initial begin
        $dumpfile("test_potential_decay.vcd");
        $dumpvars(0, test_potential_decay);

        CLK = 1'b0;

        #500
        $finish;
    end

    always
        #4 CLK = ~CLK;

endmodule