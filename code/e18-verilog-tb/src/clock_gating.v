module clock_gating (
    input en_w, en_r, clk,                  // signals that control the gated clock
    output wire write_clock,    // gated write clock
    output wire read_clock
);
    wire write;                        //to store the output of the and
    and(write, en_w, clk);               // create gated clock

    wire read;
    and(read, en_r, clk);

    assign write_clock = write;
    assign read_clock = read;
endmodule

