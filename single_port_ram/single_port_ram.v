`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.4.20240526
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2024/06/01 22:56:39
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/06/01 22:56:39
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              single_port_ram.v
// PATH:                   C:\Users\ChenG\ALL_DATA\github\zynq_exp\single_port_ram\single_port_ram.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//



module single_port_ram#(
    parameter DWIDTH = 8,
    parameter DEPTH = 256
    )(
    clk,
    rst_n,
    wr_en,
    addr,
    wr_data,
    rd_data
    );



    input [1-1:0] clk;
    input [1-1:0] rst_n;
    input [1-1:0] wr_en;
    input [8-1:0] addr;
    input [DWIDTH-1:0] wr_data;
    output reg [DWIDTH-1:0] rd_data;

    reg [DWIDTH-1:0] mem [0:DEPTH-1];

    genvar i;
    generate
        for(i = 0; i < DEPTH; i=i+1)
            begin
                always@(negedge rst_n)
                    mem[i] <= 0;
            end
    endgenerate

    always@(posedge clk)
        if(wr_en)
            mem[addr] <= wr_data;

    always@(posedge clk or posedge wr_en)
        if(wr_en)
            rd_data <= 0;
        else if(!wr_en) 
            rd_data <= mem[addr];                                                 
endmodule