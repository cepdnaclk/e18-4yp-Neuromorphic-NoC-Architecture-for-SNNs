// -----------------DESCRIPTION------------------
// This is a 2-stage synchronous FIFO module.
// ----------------------------------------------

// -------------PARAMETERS------------
// SIZE: Size of the input data bus
// -----------------------------------

module two_ff_sync #(parameter SIZE = 4)( 
    output reg [SIZE-1:0] q2,   // Output of the second flip-flop
    input [SIZE-1:0] din,       // Input data
    input clk, rst_n            // Clock and reset
    );

    reg [SIZE-1:0] q1; // Output of the first flip-flop

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            {q2, q1} <= 0;          // Reset the FIFO
        else 
            {q2, q1} <= {q1, din};  // Shift the data
    end 

endmodule

// ---------------------------EXPLANATION---------------------------------
// The module has two flip-flops, q1 and q2, which store the input data. 
// On each clock cycle, the data is shifted from q1 to q2, and new data 
// is loaded into q1. The reset signal (rst_n) is active low, meaning the 
// FIFO is reset when rst_n is low.  
// -----------------------------------------------------------------------
 