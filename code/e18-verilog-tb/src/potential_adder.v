// `include "Addition_Subtraction.v"
`timescale 1ns/100ps
`include "comparator.v"

module potential_adder(
    input wire clear,                                              //clear to start timestep
    input wire [31:0] v_threshold,
    input wire [31:0] input_weight, 
    input wire [31:0] decayed_potential, 
    output reg [31:0] final_potential, 
    output reg spike);

    wire [31:0] reset_value;   //variable to assign new exponent value
    wire Exception;
    wire [31:0] add_value;
    wire greater;

    // Addition
    Addition_Subtraction Addition_Subtraction_2(input_weight, decayed_potential, 1'b0, Exception, add_value);

    //subtraction
    Addition_Subtraction Addition_Subtraction_1(add_value, v_threshold, 1'b1, Exception, reset_value);

    //compare the added potential to the threshold
    comparator comparator_2(add_value, v_threshold, greater);

    //if threshold value reached spiked
    always@(reset_value, add_value) begin

        // Compare to see if spiked
        if(greater==1'b1) spike=1'b1;
        else spike=1'b0;  

        if(spike==1'b1) begin
        // Reset the potential according to the model
        // V <- V - Vth
            final_potential = reset_value;
        end else begin
            final_potential = add_value;
        end  
    end

    //reset the spike register
    always @(clear) begin
        if(clear==1'b1) begin
            spike = 1'b0;
        end
    end


    initial begin
        spike = 1'b0;
    end

    //if spiked send spike information to network interface
    //also send the new reset potential value
    //if not spiked send the adder potential
    // always@(spike,clear) begin

    //     if(clear==1'b1) begin
    //         if(spike==1'b1) begin
    //             // Reset the potential according to the model
    //             // V <- V - Vth
    //             final_potential = reset_value;
    //         end else begin
    //             final_potential = added_potential;
    //         end
    //     end
    // end


endmodule