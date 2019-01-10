`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:21:52 01/06/2019 
// Design Name: 
// Module Name:    m9 
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

// read cell data and drive the cells
`include "defines.v"
module envolve_display_ctrl (
	clk, rst,
    mode,
    scan_x,
    scan_y,
    win_x,
    win_y,
    visi_cell_num,
    cur_x,
    cur_y,
    cell_state,
    cell_x,
    cell_y,
    in_disp_area,
    disp_value_RGB
);
    parameter PX_BOUND_LM = 50; 
    parameter PX_BOUND_RM = 400; 
    parameter PX_BOUND_UM = 50;
    parameter PX_BOUND_DM = 400; 
    parameter MAP_HEIGHT = 8;
    parameter MAP_WIDTH = 8; 
	 
	input clk, rst;
    input mode;
    input cell_state;
    input [9: 0] scan_x;
    input [9: 0] scan_y;
    input [7: 0] visi_cell_num;
    input `ADDR_WIDTH win_x;
    input `ADDR_WIDTH win_y;
    input `ADDR_WIDTH cur_x;
    input `ADDR_WIDTH cur_y;
    output `ADDR_WIDTH cell_x;
    output `ADDR_WIDTH cell_y;
    output in_disp_area;
    output reg [11: 0] disp_value_RGB; // this output goes into the vga core

    // determine the display area of the board, needs testing on the real boad
    wire wi_px_bound_lm; // wihtin the left most bound
    wire wi_px_bound_rm; // ...
    wire wi_px_bound_um;
    wire wi_px_bound_bm;
    wire wi_draw_win;

    assign wi_px_bound_lm = scan_x > PX_BOUND_LM;
    assign wi_px_bound_rm = scan_x < PX_BOUND_RM;
    assign wi_px_bound_um = scan_y > PX_BOUND_UM;
    assign wi_px_bound_bm = scan_y < PX_BOUND_DM;

    assign wi_draw_win = wi_px_bound_lm
                       & wi_px_bound_rm
                       & wi_px_bound_um
                       & wi_px_bound_bm;
    assign in_disp_area = wi_draw_win;

    // always @ (*) begin
    //     if(wi_draw_win) begin
    //         disp_value_RGB = 12'b0000_0000_1111;
    //     end else begin
    //         disp_value_RGB = 12'b1111_1111_0000;
    //     end
    // end

    // draw the cells and cursor

    wire [7: 0] cell_rem_x_px, cell_rem_y_px;
    wire [7: 0] cell_width_px;
    calculate_cell cal_cell (
        .clk(clk), .rst(rst),
        .win_x(win_x),
        .win_y(win_y),
        .scan_r_x(scan_x),
        .scan_r_y(scan_y),
        .visi_cell_num(visi_cell_num),
        .cell_x(cell_x),
        .cell_y(cell_y),
        .cell_rem_x_px(cell_rem_x_px),
        .cell_rem_y_px(cell_rem_y_px),
        .cell_width_px(cell_width_px)
    );
    // cell_x & y in this scope is already relative to the win_x & y
    wire cursor_en;
    assign cursor_en = (mode == `MODE_EDIT) & (cell_x == cur_x) & (cell_y == cur_y);
    wire [11: 0] color_life;
    color_generator color_generator(cell_x, cell_y, color_life);

    always @ (*) begin
        if (~ cursor_en & (cell_rem_x_px == 7'b0 | cell_rem_y_px == 7'b0 )) begin
            disp_value_RGB = 12'b0000_0000_0000;
        end else begin
            if ((cell_x == cur_x) & (cell_y == cur_y)) begin
                disp_value_RGB = 12'b0000_1111_0000;
            end else begin
                disp_value_RGB = (cell_state) ? (color_life): (12'b1111_1111_1111);
            end
            //disp_value_RGB = 12'b1111_1111_0000;
        end
    end
endmodule

module calculate_cell (
    clk, rst,
    win_x,
    win_y,
    scan_r_x, // consider the gap between the board and the boarder
    scan_r_y, // consider the gap between the board and the boarder
    visi_cell_num,
    cell_x,
    cell_y,
    cell_rem_x_px,
    cell_rem_y_px,
    cell_width_px
);
    input      clk, rst;
    input      `ADDR_WIDTH   win_x;
    input      `ADDR_WIDTH   win_y;
    input      [9: 0]       scan_r_x;
    input      [9: 0]       scan_r_y;
    input      [7: 0]       visi_cell_num;
    output wire `ADDR_WIDTH   cell_x;
    output wire `ADDR_WIDTH   cell_y;
    output     [7: 0]       cell_rem_x_px;
    output     [7: 0]       cell_rem_y_px;

    output reg [7: 0] cell_width_px;
    // assign the temporary cell width, needs testing on a real board
    always @ (*) begin
        casex (visi_cell_num[7: 0]) // divide by 4
		  //casex treats all the x and z values in the case expression as don't cares.
          8'b1xxxxxxx : cell_width_px = 8'b0000_1000;
          8'b01xxxxxx : cell_width_px = 8'b0000_1000;
          8'b001xxxxx : cell_width_px = 8'b0000_1000;
          8'b0001xxxx : cell_width_px = 8'b0000_1000;
          8'b00001xxx : cell_width_px = 8'b0001_0000;
          8'b000001xx : cell_width_px = 8'b0010_0000;
          8'b0000001x : cell_width_px = 8'b0100_0000;
          8'b00000001 : cell_width_px = 8'b1000_0000;
        endcase
    end

    wire [9: 0] cell_x_quo, cell_y_quo;
    assign cell_x = win_x + cell_x_quo[7: 0];
    assign cell_y = win_y + cell_y_quo[7: 0];

    divide #(10, 8) div_x (
        .numerator(scan_r_x),
        .denominator(cell_width_px),
        .quotient(cell_x_quo),
        .remain(cell_rem_x_px)
    );

    divide #(10, 8) div_y (
        .numerator(scan_r_y),
        .denominator(cell_width_px),
        .quotient(cell_y_quo),
        .remain(cell_rem_y_px)
    );
    
endmodule

