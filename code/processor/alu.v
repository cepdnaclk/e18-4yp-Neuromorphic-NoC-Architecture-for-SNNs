//ALU with zero extension, flags incorporated, and logic 

module alu (DATA1, DATA2, SELECT, RESULT, Z, N, V, C);

    //inputs
    input [31:0] DATA1, DATA2;
    input [2:0] SELECT;

    //output
    output reg [31:0] RESULT;
    output Z, N, V, C; 

    //intermediate wires
    wire [31:0] data1_and_data2;
    wire [31:0] data1_or_data2;
    wire [31:0] not_data2;

    //2x1 mux
    wire [31:0] mux_1;

    wire [31:0] sum;

    //4x1 mux
    wire [31:0] mux_2;

    wire [31:0] slt;

    wire c_out;

    //and operation
    assign data1_and_data2 = DATA1 & DATA2;

    //or operation
    assign data1_or_data2 = DATA1 | DATA2;

    //not operation
    assign not_data2 = ~DATA2;

    //ternary operator
    assign mux_1 = (SELECT[0] == 1'b0) ?  DATA2 : not_data2;

    //add or sub
    assign {count, sum} = A + mux_1 + SELECT[0];

    //zero extension
    assign slt = {31'd0,sum[31]};

    //4x1 mux
    assign mux_2 =  (SELECT[2:0] == 3'b000) ? sum :                              //add
                    (SELECT[2:0] == 3'b001) ? sum :                              //sub
                    (SELECT[2:0] == 3'b010) ? data1_and_data2 : 
                    (SELECT[2:0] == 3'b011) ? data1_or_data2 :
                    (SELECT[2:0] == 3'b101) ? slt : 32'h00000000;

    assign RESULT = mux_2;

    //flags assignment
    assign Z = &(~RESULT);  //zero flag
    assign N = RESULT[31];  //negative flag (if bit is 1)
    assign C  = c_out & (~SELECT[1]);    //carry flag
    assign V = (~SELECT[1]) & (DATA1[31] ^ sum[31]) & (~(DATA1[31] ^ DATA2[31] ^ SELECT[0]));    //overflow flag


endmodule