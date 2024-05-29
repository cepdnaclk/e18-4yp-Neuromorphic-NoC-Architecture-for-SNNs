//A1- OUT1_ADDRESS
//A2- OUT2_ADDRESS
//A3- IN_ADDRESS

//WD- DATA_IN

//RD1- DATA_OUT1
//RD2- DATA_OUT2

module registe_file(OUT1_ADDRESS, OUT2_ADDRESS, IN_ADDRESS, DATA_IN, 
                    WRITE_EN, CLK, RESET, DATA_OUT1, DATA_OUT2);

    input [31:0] DATA_IN;
    input CLK, RESET;
    input [4:0] OUT1_ADDRESS, OUT2_ADDRESS, IN_ADDRESS;

    output [31:0] DATA_OUT1, DATA_OUT2;

    //register file
    reg [31:0] registers [31:0];

    //read functionality
    assign DATA_OUT1 = (RESET == 1'b0) ? 32'h00000000: registers [OUT1_ADDRESS];
    assign DATA_OUT2 = (RESET == 1'b0) ? 32'h00000000: registers [OUT2_ADDRESS];

    integer i;
    always @(posedge CLK) begin
        if (RESET == 1'b0) begin
            for (i = 0; i < 32; i= i+1) begin
                registers[i] <= 32'h00000000;
            end
        end
        else begin
            if (WRITE_EN) begin
                registers [IN_ADDRESS] <= DATA_IN;
            end
        end
    end

endmodule