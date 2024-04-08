`timescale 1ns/100ps

module testbench;

    reg CLK;
    reg[3:0] CLK_count;
    reg[11:0] neuron_address;
    reg [11:0] source_address;
    reg[159:0] weights_array;
    reg[59:0] source_addresses_array;
    reg clear;
    wire [31:0] result;

    mac m1(CLK, neuron_address, source_address, weights_array, source_addresses_array, clear, result);

    // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, "  source_address: %b           neuron_address: %b           result: %b              ", source_address, neuron_address, result);
    end

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("mac_wavedata.vcd");
        $dumpvars(0,testbench);
    end

    initial
    // Assign the inputs
    begin 

        CLK = 1'b0;
        CLK_count = 0;
        clear = 1'b0;
        
        //send neuron addresses
        neuron_address = 12'b000000001000;

        //send source addresses array first
        source_addresses_array = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};

        //assign the weights
        weights_array = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};

        #40
        source_address = 12'd3;

        #4
        source_address = 12'd4;  

        #4
        source_address = 12'd5;

        #4
        source_address = 12'd7;       

        #100
        $finish;    

    end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;


    always @(posedge CLK) begin

        if(CLK_count==3) begin
            CLK_count=0;
            clear = 1'b1;
        end else begin
            CLK_count = CLK_count+1;
        end

        if(CLK_count==1) begin
            clear = 1'b0;
        end

    end

endmodule