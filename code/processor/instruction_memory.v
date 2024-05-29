module instruction_memory(Address, Reset, ReadData);
    input [31:0] Address;
    input reset;

    output [31:0] ReadData;

    //memory array
    reg [31:0] mem_array [1023:0];

    assign ReadData = (Reset == 1'b0)? 32'h00000000: mem_array[Address[31:2]];
endmodule