module potential_adder(
    input wire [31:0] v_threshold,
    input wire [31:0] input_weight, 
    input wire [31:0] decayed_potential, 
    output reg [31:0] potential, 
    output reg spike);

    wire Exception;
    wire [31:0] add_value;
    wire greater;

    // Addition
    Addition_Subtraction Addition_Subtraction_2(input_weight, decayed_potential, 1'b0, Exception, add_value);
    comparator comparator_2(potential, v_threshold, greater);

    always@(*) begin
        
        potential = add_value;

        // Compare to see if spiked
        if(greater==1'b1) spike=1'b1;
        else spike=1'b0;    
    end 

    // // First add the connection inputs to the decayed potential
    // assign potential = input_weight + decayed_potential;


endmodule