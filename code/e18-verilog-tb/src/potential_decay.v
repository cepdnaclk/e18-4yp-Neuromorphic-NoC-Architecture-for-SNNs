`timescale 1ns/100ps

module potential_decay(

    input wire CLK,                         //input clock
    input reg[31:0] delay_rate, membrane_potential,                //input delay rate, membrane_potential
    
    output reg[31:0] output_potential_decay);   //output of the new potential value after decay

    wire sign = membrane_potential[31];     //sign of the potential value
    wire [7:0] exponent = membrane_potential[30:23];    //get exponent of membrane potential value 
    wire [22:0] mantissa = membrane_potential[22:0];    //get mantissa from membrane potential value
    wire [7:0] adjusted_exponent;

    always @(*) begin
        adjusted_exponent = exponent-8'b1;
    end

    output_potential_decay = {sign, adjusted_exponent, mantissa};
    
endmodule