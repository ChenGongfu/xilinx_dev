module pl_led(
    input sys_clk,
    input rst_n,
    output [3:0] pl_led
);

reg [3:0] pl_led_reg;
reg [31:0] cnt;

always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 32'd0;
        pl_led_reg <= 4'd0;
    end
    else if(cnt <= 32'd49_999_999) begin
        pl_led_reg <= pl_led_reg;
        cnt <= cnt + 32'd1;
    end
    else begin
        cnt <= 32'd0;
        pl_led_reg <= ~pl_led_reg;
    end
end

assign pl_led = pl_led_reg;

endmodule