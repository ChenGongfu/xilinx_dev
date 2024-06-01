module fsm_format3(
    input clk,
    input rst_n,
    input [1:0] X,
    output reg [1:0] Y
);

reg [2:0] current_state;
reg [2:0] next_state;

localparam money_00 = 3'b000;
localparam money_05 = 3'b001;
localparam money_10 = 3'b010;
localparam money_15 = 3'b100;
localparam money_20 = 3'b101;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        current_state <= money_00;
    else
        current_state <= next_state;
end

always@(current_state or X)
begin
    case(current_state)
        money_00:
            begin
                if(X == 2'b00)      next_state <= money_00;
                else if(X == 2'b01) next_state <= money_05;
                else if(X == 2'b10) next_state <= money_10;
            end
        
        money_05:
            begin
                if(X == 2'b00)      next_state <= money_05;
                else if(X == 2'b01) next_state <= money_10;
                else if(X == 2'b10) next_state <= money_15;
            end
        
        money_10:
            begin
                if(X == 2'b00)      next_state <= money_10;
                else if(X == 2'b01) next_state <= money_15;
                else if(X == 2'b10) next_state <= money_20;
            end
        
        money_15:
            begin
                if(X == 2'b00)      next_state <= money_00;
                else if(X == 2'b01) next_state <= money_05;
                else if(X == 2'b10) next_state <= money_10;
            end

        money_20:
            begin
                if(X == 2'b00)      next_state <= money_00;
                else if(X == 2'b01) next_state <= money_05;
                else if(X == 2'b10) next_state <= money_10;
            end    

        default:
            begin
                next_state <= current_state;
            end
    endcase
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        Y <= 2'b00;
    else if(current_state == money_00 || current_state == money_05 || current_state == money_10)
        Y <= 2'b00;
    else if(current_state == money_15)
        Y <= 2'b10;
    else if(current_state == money_20)
        Y <= 2'b11;
end

endmodule