`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:38:23 01/06/2019 
// Design Name: 
// Module Name:    m11 
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

module envolve_sub_top (
    clk, rst,
    scan_x,
    scan_y,
    mode,
    visi_cell_num,
    win_ctrl_cmd,
    envo_ctrl_cmd,
    disp_value_RGB,
    in_disp_area
);
    parameter K = 6;
    parameter INITIAL_WIN_X = 1'b0;
    parameter INITIAL_WIN_Y = 1'b0;
    parameter INITIAL_R_CUR_X = 1'b1;
    parameter INITIAL_R_CUR_Y = 1'b1;

    input clk, rst;
    input [9: 0] scan_x;
    input [9: 0] scan_y;
    input mode; // to ctrl
    input [7: 0] visi_cell_num;
    input `WIN_CTRL_CMD win_ctrl_cmd;
    input `ENVO_CTRL_CMD envo_ctrl_cmd;
    output [11: 0] disp_value_RGB;
    output in_disp_area; // from dpc


    // ctrl and logic
    wire write_en, change_state;
    wire [K - 1: 0] wAddrR, wAddrC;
    wire write_data;

    // logic and display
    wire [K - 1: 0] rAddrC, rAddrR; // from display to logic
    wire read_data;// f l t d
    
    // cur ctrl 
    wire [K - 1: 0] cur_x, cur_y;
    wire [K - 1: 0] win_x, win_y; // from cur_ctrl to display

    // dp
    wire [K - 1: 0] cell_x; // from disp
    wire [K - 1: 0] cell_y;

    envolve_logic #(K) evo_logic (
        .clk_envo(change_state), .rst(rst),
        .write_en(write_en),
        .change_state(change_state),
        .rAddrR(cell_y), .rAddrC(cell_x),
        .wAddrR(wAddrR), .wAddrC(wAddrC),
        .write_data(write_data),
        .read_data(read_data)
    );

    envolve_ctrl #(K) evo_ctrl (
        .clk(clk), .rst(rst),
        .envo_ctrl_cmd(envo_ctrl_cmd),
        .change_state(change_state),
        .mode(mode),
        //.wAddrR(wAddrR), .wAddrC(wAddrC),
        .write_en(write_en),
        .write_data(write_data),
        .cur_x(cur_x),
        .cur_y(cur_y)
    );
    // cur_x & y are the positions on the map (not relative to win_x & y)
    cursor_ctrl #(K) cur_ctrl (
        .clk(clk), .rst(rst),
        .mode(mode),
        .win_ctrl_cmd(win_ctrl_cmd),
        .win_x(win_x),
        .win_y(win_y),
        .cur_x(cur_x),
        .cur_y(cur_y),
        .view_width(visi_cell_num)
    );

    envolve_display_ctrl #(.K(K)) dp_ctrl (
	     .clk(clk), .rst(rst), 
        .mode(mode),
        .scan_x(scan_x),
        .scan_y(scan_y),
        .win_x(win_x),
        .win_y(win_y),
        .visi_cell_num(visi_cell_num),
        .cur_x(cur_x),
        .cur_y(cur_y),
        .cell_state(read_data),
        .cell_x(cell_x),
        .cell_y(cell_y),
        .in_disp_area(in_disp_area),
        .disp_value_RGB(disp_value_RGB)
    );

endmodule

