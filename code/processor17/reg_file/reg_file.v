`timescale 1ns/100ps

module reg_file (DATA_IN, DATA_OUT1, DATA_OUT2, IN_ADDRESS, OUT1_ADDRESS, OUT2_ADDRESS, WRITE_EN, CLK, RESET);
    
    input [31:0]  DATA_IN;                                  // 32-bit data input
    input [4:0] IN_ADDRESS, OUT1_ADDRESS, OUT2_ADDRESS;     // Address lines
    input WRITE_EN, CLK, RESET;                             // Control signals
    output [31:0] DATA_OUT1, DATA_OUT2;                 // 32-bit data outputs

    // 32-bit x 32 register file
    reg [31:0] REGISTERS [31:0]; 

    /*** Read asynchronously ***/
    assign #2 DATA_OUT1 = REGISTERS[OUT1_ADDRESS];
    assign #2 DATA_OUT2 = REGISTERS[OUT2_ADDRESS];

    /*** Write on negative clock edge ***/
    integer i;
    always @ (negedge CLK) 
    begin
        if (RESET == 1'b1)
        begin
            for (i = 0; i < 32; i = i + 1)
            begin
                REGISTERS[i] <= #2 0;       // Write zero to all registers
            end
        end
        else
        begin
            if (WRITE_EN == 1'b1 && IN_ADDRESS != 0)     // x0 must always be zero
            begin
                REGISTERS[IN_ADDRESS] <= #2 DATA_IN;    
            end
        end
    end


endmodule
