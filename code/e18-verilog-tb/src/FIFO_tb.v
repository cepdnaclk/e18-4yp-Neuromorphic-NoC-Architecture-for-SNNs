`timescale 1ns/1ps

module FIFO_tb;

    parameter DSIZE = 12;           // 12 bit data
    parameter ASIZE = 10;           // 10 bits to represented 1024 address locations
    parameter DEPTH = 1 << ASIZE;

    reg [DSIZE-1:0] wdata;
    wire [DSIZE-1:0] rdata;
    wire wfull, rempty;
    reg winc, rinc, wrst_n, rrst_n;

    // for the read and write gated clocks
    reg clk, en_w, en_r;
    wire write_clock, read_clock;

    integer i;
    integer seed = 1;

    // Clock toggling
    initial clk = 0;
    always #5 clk = ~clk;

    // Instantiate clock gating
    clock_gating gater (
        .clk(clk),
        .en_w(en_w),
        .en_r(en_r),
        .write_clock(write_clock),
        .read_clock(read_clock)
    );

    // Instantiate FIFO
    FIFO #(DSIZE, ASIZE) fifo (
        .rdata(rdata),
        .wdata(wdata),
        .wfull(wfull),
        .rempty(rempty),
        .winc(winc),
        .rinc(rinc),
        .wclk(write_clock),
        .rclk(read_clock),
        .wrst_n(wrst_n),
        .rrst_n(rrst_n)
    );

    // Toggle enable signals
    initial begin
        forever begin
            en_r = 1;
            repeat (2048) @(posedge clk);
            en_r = 0;
            repeat (2148) @(posedge clk);
        end
    end

    initial begin
        forever begin
            en_w = 0;
            repeat (2148) @(posedge clk);
            en_w = 1;
            repeat (2048) @(posedge clk);
        end
    end

    // Write on posedge of write_clock
    task write_data(input integer count);
        begin
            for (i = 0; i < count; i = i + 1) begin
                @(posedge write_clock);
                wdata = $random(seed) % 256;                // Job of the NI
                winc = 1;
                @(posedge write_clock);
                winc = 0;
            end
        end
    endtask

    // Read on posedge of read_clock
    task read_data(input integer count);
        begin
            for (i = 0; i < count; i = i + 1) begin
                @(posedge read_clock);
                rinc = 1;
                @(posedge read_clock);
                rinc = 0;
            end
        end
    endtask

    // Simulation
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, FIFO_tb);

        // Initialize
        wrst_n = 1;
        rrst_n = 1;
        winc = 0;
        rinc = 0;
        wdata = 0;

        // Reset
        #20 wrst_n = 0; rrst_n = 0;
        #20 wrst_n = 1; rrst_n = 1;

        // // Test Case 1: Normal write and read
        // fork
        //     write_data(10);
        //     read_data(10);
        // join

        // Test Case 2: Fill FIFO and attempt overflow
        write_data(DEPTH);
        // Test Case 3: Read all + attempt underflow
        read_data(DEPTH);

        // Test Case 2: Fill FIFO and attempt overflow
        write_data(DEPTH);
        // Test Case 3: Read all + attempt underflow
        read_data(DEPTH);

        // // Test Case 2: Fill FIFO and attempt overflow
        // write_data(DEPTH);
        // // Test Case 3: Read all + attempt underflow
        // read_data(DEPTH);

        // // Test Case 2: Fill FIFO and attempt overflow
        // write_data(DEPTH);
        // // Test Case 3: Read all + attempt underflow
        // read_data(DEPTH);

        #100000 $finish;
    end

endmodule
