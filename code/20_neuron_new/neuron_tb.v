module neuron_tb();

    //variables
    reg clk;
    reg reset;
    reg[31:0] weight_in;
    wire spike;
    reg[5:0] count;

    neuron n1(.clk(clk),
                .reset(reset),
                .weight_in(weight_in),
                .spike(spike));

    initial begin
        $dumpfile("neuron_tb.vcd");
        $dumpvars(0,neuron_tb);
    end

    //testbench
    initial begin
        clk=0;
        reset = 1;
        weight_in = 32'd0;
        count=0;  

        #5
        reset = 0;   
    end

    initial begin
        #21 weight_in = 32'h42340000;
    end

    initial #500 $finish;

    always #5 clk = ~clk;

    //give 20 clocks to reset

    always @(posedge clk) begin
        if (count==20) begin
            count = 0;
            reset = 1;
        end else if (count==5) begin
            reset = 0;
            count = count + 1;
        end else begin
            count = count + 1;
        end
    end

    always @(posedge reset) weight_in = 32'h00000000;


endmodule