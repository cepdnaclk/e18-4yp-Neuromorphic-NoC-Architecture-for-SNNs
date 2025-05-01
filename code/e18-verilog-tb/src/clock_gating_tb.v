`timescale 1ns/100ps

module clock_gating_tb;

    reg en_w, en_r, clk;
    wire write_clock, read_clock;

    clock_gating test(en_w, en_r, clk, write_clock, read_clock);

    initial begin
        clk = 0;
        $dumpfile("clock_gating.vcd");
        $dumpvars(0, clock_gating_tb);
        #300000
        $finish;
    end

    // 1024 read -> calc -> 1024 write
    // when calculating, clock can go low

    // enable high- 2048 CC
    // enable low- 100 CC 

    // Generate the clock
    always #4 clk = ~clk;
    
    // toggle enable read signal
    initial begin
        forever begin
            en_r = 1;
            repeat (1024) @(posedge clk);
            en_r = 0;
            repeat (1124) @(posedge clk);
        end
    end

    // toggle enable write signal
    initial begin
        forever begin
            en_w = 0;
            repeat (1124) @(posedge clk);
            en_w = 1;
            repeat (1024) @(posedge clk);
        end
    end

endmodule