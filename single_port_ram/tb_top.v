module tb_top;



parameter DWIDTH = 8;
parameter DEPTH = 256;

reg [1-1:0] clk;
reg [1-1:0] rst_n;
reg [1-1:0] wr_en;
reg [8-1:0] addr;
reg [DWIDTH-1:0] wr_data;
wire [DWIDTH-1:0] rd_data;

single_port_ram uut(
    clk,
    rst_n,
    wr_en,
    addr,
    wr_data,
    rd_data
    );

always #10 clk = ~clk;

integer i;

initial begin
    clk = 0;
    rst_n = 0;
    wr_en = 0;
    wr_data = 0;

    #50 rst_n = 1;
    #50 wr_en = 1;
    for (i = 0; i < DEPTH; i=i+1)
        @(posedge clk) begin
            addr <= i;
            wr_data <= wr_data + 1;
        end
    #100 wr_en = 0;
    for (i = 0; i < DEPTH; i=i+1)
    @(posedge clk) begin
        addr <= i;
    end
    
end

endmodule