

`timescale 1ns / 1ps

module Accumulating_Adder(


    input clk,
    input reset,
    input [31:0] a_operand,   // Input value in IEEE-754 format
    output Exception,
    output reg [31:0] result  // Output accumulated result
);

wire [31:0] operand_a, operand_b;
wire [23:0] significand_a, significand_b;
wire [24:0] significand_add;
wire [30:0] add_sum;
wire [7:0] exponent_diff;

reg [31:0] accumulator;

// Initial assignment
assign operand_a = a_operand;
assign operand_b = accumulator;

// Check for IEEE-754 special case exception
assign Exception = (&operand_a[30:23]) | (&operand_b[30:23]);

// Extract significands (add hidden bit if normalized)
assign significand_a = (|operand_a[30:23]) ? {1'b1, operand_a[22:0]} : {1'b0, operand_a[22:0]};
assign significand_b = (|operand_b[30:23]) ? {1'b1, operand_b[22:0]} : {1'b0, operand_b[22:0]};

// Match exponents by shifting
assign exponent_diff = (operand_a[30:23] > operand_b[30:23]) ? 
                        (operand_a[30:23] - operand_b[30:23]) : 
                        (operand_b[30:23] - operand_a[30:23]);

wire [23:0] aligned_a = (operand_a[30:23] > operand_b[30:23]) ? significand_a : significand_a >> exponent_diff;
wire [23:0] aligned_b = (operand_a[30:23] > operand_b[30:23]) ? significand_b >> exponent_diff : significand_b;

wire [7:0] result_exp = (operand_a[30:23] > operand_b[30:23]) ? operand_a[30:23] : operand_b[30:23];

// Add aligned significands
assign significand_add = aligned_a + aligned_b;

// Normalize result
assign add_sum[22:0] = significand_add[24] ? significand_add[23:1] : significand_add[22:0];
assign add_sum[30:23] = significand_add[24] ? (result_exp + 1) : result_exp;

wire output_sign = 1'b0;  // assume positive values only for simplicity

// Update accumulator and result on clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        accumulator <= 32'd0;
        result <= 32'd0;
    end else if (!Exception) begin
        accumulator <= {output_sign, add_sum};
        result <= accumulator;
    end else begin
        result <= 32'd0;
    end
end

endmodule
