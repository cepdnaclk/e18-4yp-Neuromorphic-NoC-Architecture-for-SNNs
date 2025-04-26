
// `include "Addition_Subtraction.v"
`timescale 1ns/100ps
// `isnclude "comparator.v"
 
module potential_adder_0(
    //input wire clear_adder_0_adder_0,                                              //clear_adder_0 to start timestep
	 //input wire set,
    //input wire [31:0] v_threshold,
    input wire [31:0] input_weight, 
    input wire [31:0] decayed_potential,
    //input wire [1:0] model,
    //input wire [31:0] a,
    //input wire [31:0] b,
    //input wire [31:0] c,
    //input wire [31:0] d,
    //input wire [31:0] u_initialize,
    output reg [31:0] final_potential, 
    output reg spike);

	 //inputs manual initial
	reg [31:0] v_threshold;
    //reg [31:0] input_weight; 
    //reg [31:0] decayed_potential;
    reg [1:0] model;
    // reg [31:0] a;
    // reg [31:0] b;
    // reg [31:0] c;
    // reg [31:0] d;
    //reg [31:0] u_initialize,
	 
    //common
    
    //for LIF
    wire [31:0] reset_value;   //variable to assign new exponent value
    wire [31:0] add_value;
    wire greater;

    //for izi
    wire [31:0] weight_added;
    // wire [31:0] weight_added_u;
    // wire [31:0] final_u;
    // wire [31:0] bv;
    // wire [31:0] bv_u;
    // wire [31:0] u_plus_d;
    // wire [31:0] a_bv_u;
    // wire greater_izhi;
    // reg[31:0] u;

    wire Exception;
    wire Exception1;
    // wire Exception2;

    // wire Exception3;
    // wire Overflow3;
    // wire Underflow3;

    // wire Exception4;

    // wire Exception5;
    // wire Overflow5;
    // wire Underflow5;

    // wire Exception6;


//for QLIF

    // wire[31:0] weight_added_Q;
    // wire [31:0] reset_value_Q;
    // wire Exception_Q_1;
    // wire greater_Q;
    // wire Exception_Q_2;

//**********Common************************
    // Addition
    Addition_Subtraction Addition_Subtraction_2(input_weight, decayed_potential, 1'b0, Exception, weight_added);
//***********************************************

//LIF**************************
    //subtraction
    Addition_Subtraction Addition_Subtraction_1(weight_added, v_threshold, 1'b1, Exception1, reset_value);

    //compare the added potential to the threshold
    comparator comparator_2(weight_added, v_threshold, greater);
//************************************

// //*******************Izi***********
//     //update potential with subtracting u
//     Addition_Subtraction Addition_Subtraction_3(weight_added, u, 1'b1, Exception2, weight_added_u);

//     //u = u+d
//     Addition_Subtraction Addition_Subtraction_7(d, u, 1'b1, Exception6, u_plus_d);  

//     //compare the added potential to the threshold
//     comparator comparator_3(weight_added_u, v_threshold, greater_izhi);

//     //bv
//     Multiplication Multiplication_1(b, decayed_potential, Exception3, Overflow3, Underflow3, bv);  

//     //bv-u
//     Addition_Subtraction Addition_Subtraction_4(bv, u, 1'b1, Exception4, bv_u);

//     //a(bv-u)
//     Multiplication Multiplication_2(a, bv_u, Exception5, Overflow5, Underflow5, a_bv_u);
// //*********************************************


// //**********QLIF
//     //v_squared plus input weight
//     Addition_Subtraction Addition_Subtraction_Q_1(decayed_potential, input_weight, 1'b1, Exception_Q_1, weight_added_Q);

//     //compare the added potential to the threshold
//     comparator comparator_Q_1(weight_added_Q, v_threshold, greater_Q);

//     //subtraction
//     Addition_Subtraction Addition_Subtraction_Q_2(weight_added_Q, v_threshold, 1'b1, Exception_Q_2, reset_value_Q);

//depending on the model set spike and reset values
    always@(*) begin
        
			 case (model)
            //LIF
					2'b00: begin
                // Compare to see if spiked
						if(greater==1'b1) spike=1'b1;
						else spike=1'b0;  

						if(spike==1'b1) begin
                // Reset the potential according to the model
                // V <- V - Vth
							final_potential = reset_value;
						end else begin
							final_potential = weight_added;
						end  
					end

            // //izhikevixh
			// 		2'b01: begin
            //     // Compare to see if spiked
			// 			if(greater_izhi==1'b1) spike=1'b1;
			// 			else spike=1'b0;  

			// 			if(spike==1'b1) begin
            //     // Reset the potential according to the model
            //     // V <- V - Vth
			// 				final_potential = c;
			// 				u = u_plus_d;
			// 			end else begin
			// 				final_potential = weight_added_u;
			// 			end  
			// 		end


            // //QLIF
			// 		2'b10: begin    
            //     // Compare to see if spiked
			// 			if(greater_izhi==1'b1) spike=1'b1;
			// 			else spike=1'b0;  

			// 			if(spike==1'b1) begin
            //     // Reset the potential according to the model
            //     // V <- V - Vth
			// 				final_potential = reset_value_Q;
			// 			end else begin
			// 				final_potential = weight_added_Q;
			// 			end  
			// 		end  

					default: final_potential = weight_added;
			endcase
		end
   


        //initial
        initial begin
            spike = 1'b0;
            v_threshold = 32'h42200000;
            model = 2'b00;
    
            // a = 32'h4287c7ae;
            // b = 32'h4287c7ae;
            // c = 32'h4287c7ae;
            // d = 32'h4287c7ae;
            //u_initialize = 32'h4287c7ae;
            //input_weight = 32'h42470A3D;
            //decayed_potential = 32'h425ED852;
            /*output0 = input_weight[0];
            output1 = input_weight[1];
            output2 = input_weight[2];
            output3 = input_weight[3];
            output4 = input_weight[4];
            output5 = input_weight[5];
            output6 = input_weight[6];
            output7 = input_weight[7];
            output8 = input_weight[8];
            output9 = input_weight[9];*/
        end
endmodule