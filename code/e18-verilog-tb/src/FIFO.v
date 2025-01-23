//--------------DESCRIPTION-----------------
// This is a FIFO module with a configurable data size and address size.
// This is a top level module which wraps all the submodules together.
//-------------------------------------------

// -------------PARAMETERS------------
// DSIZE: Size of the data bus
// ASIZE: Size of the address bus
// -----------------------------------

module FIFO #(parameter DSIZE = 8,
    parameter ASIZE = 4)(
    output [DSIZE-1:0] rdata,       // Output data - data to be read
    output wfull,                   // Write full signal
    output rempty,                  // Read empty signal
    input [DSIZE-1:0] wdata,        // Input data - data to be written
    input winc, wclk, wrst_n,       // Write increment, write clock, write reset
    input rinc, rclk, rrst_n        // Read increment, read clock, read reset
    );

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

    two_ff_sync #(ASIZE+1) sync_r2w (       // Read pointer syncronization to write clock domain
        .q2(wq2_rptr), 
        .din(rptr),
        .clk(wclk), 
        .rst_n(wrst_n)
    );

    two_ff_sync #(ASIZE+1) sync_w2r (       // Write pointer syncronization to read clock domain
        .q2(rq2_wptr), 
        .din(wptr),
        .clk(rclk), 
        .rst_n(rrst_n)
    );

    FIFO_memory #(DSIZE, ASIZE) fifomem(    // Memory module
        .rdata(rdata), 
        .wdata(wdata),
        .waddr(waddr), 
        .raddr(raddr),
        .wclk_en(winc), 
        .wfull(wfull),
        .wclk(wclk)
    );

    rptr_empty #(ASIZE) rptr_empty(         // Read pointer and empty signal handling
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr), 
        .rq2_wptr(rq2_wptr),
        .rinc(rinc), 
        .rclk(rclk),
        .rrst_n(rrst_n)
    );

    wptr_full #(ASIZE) wptr_full(           // Write pointer and full signal handling
        .wfull(wfull), 
        .waddr(waddr),
        .wptr(wptr), 
        .wq2_rptr(wq2_rptr),
        .winc(winc), 
        .wclk(wclk),
        .wrst_n(wrst_n)
    );

endmodule

// ---------------------------EXPLANATION---------------------------------
// This module is a FIFO implementation with configurable data and address
// sizes. It consists of a memory module, read and write pointer handling
// modules, and read and write pointer synchronization modules. The read and
// write pointers are synchronized to the respective clock domains, and the
// read and write pointers are checked for empty and full conditions,
// respectively. The FIFO memory module stores the data and handles the
// read and write operations.
// -----------------------------------------------------------------------