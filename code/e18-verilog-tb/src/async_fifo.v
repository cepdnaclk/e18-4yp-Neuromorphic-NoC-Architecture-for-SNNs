module async_fifo #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4)
(
    input  wire                 wr_clk,
    input  wire                 rd_clk,
    input  wire                 rst_n,
    input  wire                 wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    input  wire                 rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                 empty,
    output wire                 full
);

    reg [DATA_WIDTH-1:0] fifo_mem [(1<<ADDR_WIDTH)-1:0];
    reg [ADDR_WIDTH:0]   wr_ptr, wr_ptr_gray;
    reg [ADDR_WIDTH:0]   rd_ptr, rd_ptr_gray;
    reg [ADDR_WIDTH:0]   wr_ptr_gray_rd_clk;
    reg [ADDR_WIDTH:0]   rd_ptr_gray_wr_clk;

    reg [ADDR_WIDTH:0]   rd_ptr_next;

    wire [ADDR_WIDTH:0] wr_ptr_gray_next = (wr_ptr + 1) ^ ((wr_ptr + 1) >> 1);
    wire [ADDR_WIDTH:0] rd_ptr_gray_next = (rd_ptr + 1) ^ ((rd_ptr + 1) >> 1);

    assign rd_data = fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];
    assign empty = (rd_ptr_gray == wr_ptr_gray_rd_clk);
    assign full  = ((wr_ptr_gray == {~rd_ptr_gray_wr_clk[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_wr_clk[ADDR_WIDTH-2:0]}));

    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1;
            wr_ptr_gray <= wr_ptr_gray_next;
        end
    end

    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_next = rd_ptr;
            rd_ptr <= rd_ptr + 1;
            rd_ptr_gray <= rd_ptr_gray_next;
        end
    end

    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n)
            rd_ptr_gray_wr_clk <= 0;
        else
            rd_ptr_gray_wr_clk <= rd_ptr_gray;
    end

    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n)
            wr_ptr_gray_rd_clk <= 0;
        else
            wr_ptr_gray_rd_clk <= wr_ptr_gray;
    end

endmodule

