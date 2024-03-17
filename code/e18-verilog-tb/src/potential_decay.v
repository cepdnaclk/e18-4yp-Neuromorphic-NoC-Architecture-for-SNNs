`timescale 1ns/100ps
`include "Addition_Subtraction.v"
//Potential decay for divinding by 1, 2, 4, and 8 only


module potential_decay(

    input wire CLK,                             //input clock
    input wire[2:0] decay_rate,                 //input decay rate,
    input wire[31:0] membrane_potential,        // membrane_potential
    output reg[31:0] output_potential_decay     //output of the new potential value after decay
    );   
    
    reg [1:0] sign;        //sign of the potential value
    reg [7:0] exponent;    //get exponent of membrane potential value 
    reg [22:0] mantissa;   //get mantissa from membrane potential value
    reg [7:0] adjusted_exponent;   //variable to assign new exponent value
    reg[7:0] exponent_divided_by_2;  //store division by 2
    reg[7:0] exponent_divided_by_4;  //store division by 4
    wire Exception;                             //exception of the addition 
    wire [31:0] result_divide_by_2_plus_4;   //variable to assign new exponent value        

    Addition_Subtraction Addition_Subtraction_1({sign, exponent_divided_by_2, mantissa}, {sign, exponent_divided_by_4, mantissa}, 1'b0, Exception, result_divide_by_2_plus_4);
    
    always @(*) begin
        sign = membrane_potential[31];     
        exponent = membrane_potential[30:23];    
        mantissa = membrane_potential[22:0]; 
        
        case (decay_rate)

            3'd0: begin         //divide by 1
                adjusted_exponent = exponent;
            end

            3'd1: begin         //divide by 2
                adjusted_exponent = exponent-8'd1;
            end

            3'd2: begin         //divide by 4
                adjusted_exponent = exponent-8'd2;
            end

            3'd3: begin         //divide by 8
                adjusted_exponent = exponent-8'd3;
            end

            3'd4: begin         //add division by 2 and 4
                exponent_divided_by_2 = exponent-8'd1;
                exponent_divided_by_4 = exponent-8'd2;
                adjusted_exponent = result_divide_by_2_plus_4[30:23];
            end

            default: adjusted_exponent = exponent;
        endcase

        output_potential_decay = {sign, adjusted_exponent, mantissa};
    end

endmodule