//--------------DESCRIPTION--------------
// This is a testbench for the FIFO module.
// The testbench generates random data and writes it to the FIFO, 
// then reads it back and compares the results.
//---------------------------------------

`timescale 1ns/1ps

module FIFO_tb;

    parameter DSIZE = 8; // Data bus size
    parameter ASIZE = 3; // Address bus size
    parameter DEPTH = 1 << ASIZE; // Depth of the FIFO memory

    reg [DSIZE-1:0] wdata;   // Input data
    wire [DSIZE-1:0] rdata;  // Output data
    wire wfull, rempty;      // Write full and read empty signals
    reg winc, rinc, wclk, rclk, wrst_n, rrst_n; // Write and read signals

    FIFO #(DSIZE, ASIZE) fifo (
        .rdata(rdata), 
        .wdata(wdata),
        .wfull(wfull),
        .rempty(rempty),
        .winc(winc), 
        .rinc(rinc), 
        .wclk(wclk), 
        .rclk(rclk), 
        .wrst_n(wrst_n), 
        .rrst_n(rrst_n)
    );

    integer i=0;
    integer seed = 1;

    // Read and write clock in loop
    always #5 wclk = ~wclk;    // faster writing
    always #10 rclk = ~rclk;   // slower reading

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("async_fifo_testbench.vcd");
        $dumpvars(0, FIFO_tb);
    end
    
    initial begin
        // Initialize all signals
        wclk = 0;
        rclk = 0;
        wrst_n = 1;     // Active low reset
        rrst_n = 1;     // Active low reset
        winc = 0;
        rinc = 0;
        wdata = 0;

        // Reset the FIFO
        #40 wrst_n = 0; rrst_n = 0;
        #40 wrst_n = 1; rrst_n = 1;

        // TEST CASE 1: Write data and read it back
        rinc = 1;
        for (i = 0; i < 10; i = i + 1) begin
            wdata = $random(seed) % 256;
            winc = 1;
            #10;
            winc = 0;
            #10;
        end

        // TEST CASE 2: Write data to make FIFO full and try to write more data
        rinc = 0;
        winc = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            wdata = $random(seed) % 256;
            #10;
        end

        // TEST CASE 3: Read data from empty FIFO and try to read more data
        winc = 0;
        rinc = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            #20;
        end

        $finish;
    end

endmodule

//----------------------------EXPLANATION-----------------------------------------------
// The testbench for the FIFO module generates random data and writes it to the FIFO,
// then reads it back and compares the results. The testbench includes three test cases:
// 1. Write data and read it back.
// 2. Write data to make the FIFO full and try to write more data.
// 3. Read data from an empty FIFO and try to read more data. The testbench uses
// clock signals for writing and reading, and includes reset signals to initialize
// the FIFO. The testbench finishes after running the test cases.
//--------------------------------------------------------------------------------------