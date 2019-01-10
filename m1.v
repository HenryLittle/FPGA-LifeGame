`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:52 12/31/2018 
// Design Name: 
// Module Name:    m1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"
module travers_boardm (
    clk, rst,
    enable,
    addrC,
    addrR,
    finish
);
       parameter MAP_HEIGHT = 8;
    parameter MAP_WIDTH = 8;
    input clk,rst;
    input enable;
    output reg [7: 0] addrC; // the max width won't excced 128
    output reg [7: 0] addrR;
    output finish;

    assign finish = (addrC == MAP_WIDTH - 1) & (addrR == MAP_HEIGHT - 1);

    always @ (posedge clk or negedge rst) begin
        if (~rst | finish) begin
            addrC <= 8'b0;
            addrR <= 8'b0;
        end else if (enable) begin
            if (addrC < MAP_WIDTH - 1) begin
                addrC <= addrC + 8'b1;
            end else if (addrC == MAP_WIDTH - 1) begin
                addrC <= 8'b0;
                addrR <= addrR + 8'b1;
            end
        end
    end


endmodule