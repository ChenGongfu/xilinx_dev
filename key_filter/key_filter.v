
`timescale 1ns / 1ns

module key_filter(
    input key_in,
    input rst_n,
    input clk,
    output key_out,
    output [1:0] key_state
    );

    reg key_syn1;
    reg key_syn2;
    reg key_reg1;
    reg key_reg2;

    wire key_neg_edge;
    wire key_pos_edge;

    reg key_out_reg;
    reg en_cnt;
    reg cnt_full;
    reg [21:0] cnt;

    reg [1:0] current_state;
    reg [1:0] next_state;

    localparam IDLE = 2'b00;
    localparam FILTER0 = 2'b01;
    localparam DOWN = 2'b11;
    localparam FILTER1 = 2'b10;

    // key 异步变同步
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                begin
                    key_syn1 <= 0;
                    key_syn2 <= 0;
                end
            else
                begin
                    key_syn1 <= key_in;
                    key_syn2 <= key_syn1;
                end
        end
    // 保存同步结果
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                begin
                    key_reg1 <= 0;
                    key_reg2 <= 0;
                end                                
            else
                begin
                    key_reg1 <= key_syn2;
                    key_reg2 <= key_reg1;
                end                                   
        end 
    assign key_neg_edge = !key_reg1 & key_reg2;
    assign key_pos_edge = key_reg1 & !key_reg2;
    
    // key filter state machine
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                current_state <= IDLE;                                 
            else                
                current_state <= next_state;                                
        end
    
    // 50ms 计数器  50ms/20ns = 2.5x10^6 周期
    // 使用 40 个周期用于仿真
    
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)
                begin                              
                cnt <= 0;
                cnt_full <= 0;
                end                                   
            else if(!en_cnt)
                begin                              
                cnt <= 0;
                cnt_full <= 0;
                end                    
            else if(cnt == 22'd39)
                begin
                cnt_full <= 1;
                cnt <= 0;
                en_cnt <= 0;
                end
            else
                cnt <= cnt + 1;
        end                                 


    always@(key_neg_edge or key_pos_edge or cnt_full or current_state)
        begin
            case (current_state)
                IDLE:
                    begin
                        if(key_neg_edge)
                            begin
                                next_state <= FILTER0;
                                en_cnt <= 1;
                            end
                        else
                            begin
                                next_state <= IDLE;
                                en_cnt <= 0;
                            end
                    end
                FILTER0:
                    begin
                        if(key_pos_edge)
                            begin
                                next_state <= IDLE;
                                en_cnt <= 0;
                            end
                        else if(cnt_full)
                            begin
                                next_state <= DOWN;
                                en_cnt <= 0;
                            end
                        else
                            begin
                                next_state <= FILTER0;
                                en_cnt <= 1;
                            end
                    end
                DOWN:
                    begin
                        if(key_pos_edge)
                            begin
                                next_state <= FILTER1;
                                en_cnt <= 1;
                            end
                        else
                            begin
                                next_state <= DOWN;
                                en_cnt <= 0;
                            end
                    end
                FILTER1:
                    begin
                        if(key_neg_edge)
                            begin
                                next_state <= DOWN;
                                en_cnt <= 0;
                            end
                        else if(cnt_full)
                            begin
                                next_state <= IDLE;
                                en_cnt <= 0;
                            end
                        else
                            begin
                                next_state <= FILTER1;
                                en_cnt <= 1;
                            end
                    end
                default 
                    begin
                        next_state <= IDLE;
                        en_cnt <= 0;
                    end
            endcase
        end
    

    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                key_out_reg <= 0;                               
            else
                begin
                    case (current_state)
                        IDLE:
                            begin
                                key_out_reg <= 1;
                            end
                        FILTER0:
                            begin
                                key_out_reg <= 1;
                            end
                        DOWN:
                            begin
                                key_out_reg <= 0;
                            end
                        FILTER1:
                            begin
                                key_out_reg <= 0;
                            end
                    endcase
                end                                     
        end
    assign key_out = key_out_reg;                                                                      
    assign key_state = current_state;
endmodule
