module tb_top;

//port declaration
reg key_in;
reg rst_n;
reg clk;

wire key_out;
wire [1:0] key_state;

// uut
key_filter uut(
    key_in,
    rst_n,
    clk,
    key_out,
    key_state
);

// clk declaration
always #10 clk = ~clk;

// 激励
initial begin
    clk = 0;
    rst_n = 0;
    key_in = 1;
    #100 rst_n = 1;

    #50 key_in = 0;

    #900 key_in = 1;

    #2000 $stop;

end

endmodule