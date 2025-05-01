//---------------DESCRIPTION-----------------------
// This is a FIFO read pointer Handle module with empty flag.
//--------------------------------------------------

//-------------PARAMETERS---------------------------
// ADDR_SIZE: Size of the address bus
//--------------------------------------------------

module rptr_empty #(parameter ADDR_SIZE = 4)(
    output reg rempty,                  // Empty flag
    output [ADDR_SIZE-1:0] raddr,       // Read address
    output reg [ADDR_SIZE :0] rptr,     // Read pointer
    input [ADDR_SIZE :0] rq2_wptr,      // Write pointer (gray) - synchronised to read clock domain
    input rinc, rclk, rrst_n            // Read increment, read-clock, and reset
    );

    reg [ADDR_SIZE:0] rbin;                     // Binary read pointer
    wire [ADDR_SIZE:0] rgray_next, rbin_next;   // Next read pointer in gray and binary code
    wire rempty_val;                            // Empty flag value

    // Synchronous FIFO read pointer (gray code)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)                // Reset the FIFO
            {rbin, rptr} <= 0;
        else 
            {rbin, rptr} <= {rbin_next, rgray_next};  // Shift the read pointer
    end

    assign raddr = rbin[ADDR_SIZE-1:0];                 // Read address calculation from the read pointer
    assign rbin_next = rbin + (rinc & ~rempty);         // Increment the read pointer if not empty
    assign rgray_next = (rbin_next>>1) ^ rbin_next;     // Convert binary to gray code

    // Check if the FIFO is empty
    assign rempty_val = (rgray_next == rq2_wptr);       // Empty flag calculation

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)                // Reset the empty flag
            rempty <= 1'b1;
        else 
            rempty <= rempty_val;  // Update the empty flag
    end
endmodule

// ---------------------------EXPLANATION---------------------------------
// The module implements a read pointer for a FIFO with an empty flag.
// The read pointer is implemented in gray code to avoid glitches when
// transitioning between clock domains. The read pointer is incremented based
// on the read increment signal and the empty flag. The empty flag is set
// when the read pointer is equal to the write pointer, indicating that
// the FIFO is empty. The read pointer and empty flag are updated on each
// clock cycle, and the read address is calculated from the read pointer.
// -----------------------------------------------------------------------