`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:35:44 01/06/2019 
// Design Name: 
// Module Name:    m7 
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

// calculate the position of cursor and view window
// when zoom | move cursor
module cursor_ctrl (
    clk, rst,
    mode, // run = 1, edit = 0
    win_ctrl_cmd,
    win_x,
    win_y,
    cur_x,
    cur_y,
    view_width
);
    parameter INITIAL_WIN_X = 0;
    parameter INITIAL_WIN_Y = 0;
    parameter INITIAL_R_CUR_X = 3;
    parameter INITIAL_R_CUR_Y = 3;

    input clk, rst;
    input mode; // run = 1, edit = 0
    input `WIN_CTRL_CMD win_ctrl_cmd;
    input [7: 0] view_width; // 

    output reg `ADDR_WIDTH win_x;
    output reg `ADDR_WIDTH win_y;
    output `ADDR_WIDTH cur_x;
    output `ADDR_WIDTH cur_y;// these are the actual position on the whole board
    
    wire m_u;
    wire m_d;
    wire m_l;
    wire m_r;
    wire z_i;
    wire z_o;
    wire m_mode;

    wire win_mode;
    wire cur_mode;
    // connect the controls all the control commands
    assign m_u = win_ctrl_cmd[`M_UP];
    assign m_d = win_ctrl_cmd[`M_DOWN];
    assign m_l = win_ctrl_cmd[`M_LEFT];
    assign m_r = win_ctrl_cmd[`M_RIGHT];
    assign z_i = win_ctrl_cmd[`Z_IN];
    assign z_o = win_ctrl_cmd[`Z_OUT];
    assign m_mode = win_ctrl_cmd[`M_MODE];
    // unpack the move mode
    assign win_mode = m_mode;
    assign cur_mode = ~m_mode;

    reg `ADDR_WIDTH next_win_x;
    reg `ADDR_WIDTH next_win_y;
    reg `ADDR_WIDTH next_cur_x;
    reg `ADDR_WIDTH next_cur_y;
    
    reg `ADDR_WIDTH zoom_win_x;
    reg `ADDR_WIDTH zoom_win_y;
    reg `ADDR_WIDTH zoom_cur_r_x;
    reg `ADDR_WIDTH zoom_cur_r_y;

    reg [7: 0] cur_r_x; // r for relative
    reg [7: 0] cur_r_y;
    // cursor output
    assign cur_x = win_x + cur_r_x;
    assign cur_y = win_y + cur_r_y;

    // the boader
    wire `ADDR_WIDTH ul_bo;
    wire `ADDR_WIDTH dr_bo;


    //////////////////////////////////////////////
    //       ZOOM! not a speedster though.      //
    //////////////////////////////////////////////
    //assign z_en = z_i | z_o;
    assign z_en = 0;
    // always @ (*) begin
    //     if (z_i) begin
    //         zoom_cur_r_x = {1'b0, cur_r_x[K - 1: 1]};// divide by 2
    //         zoom_cur_r_y = {1'b0, cur_r_y[K - 1: 1]};
    //         zoom_win_x = win_x + {2'b00, view_width[K - 1: 2]};// divide by 4
    //         zoom_win_y = win_y + {2'b00, view_width[K - 1: 2]};
    //     end 
    //     else if (z_o) begin
    //         zoom_cur_r_x = {1'b0, cur_r_x[K - 1: 1]};// divide by 2
    //         zoom_cur_r_y = {1'b0, cur_r_y[K - 1: 1]};
    //         zoom_win_x = win_x + {2'b00, view_width[K - 1: 2]};// divide by 4
    //         zoom_win_y = win_y + {2'b00, view_width[K - 1: 2]};
    //     end
    //     else begin
    //         zoom_cur_r_x = cur_r_x;
    //         zoom_cur_r_y = cur_r_y;
    //         zoom_win_x = win_x;
    //         zoom_win_y = win_y;
    //     end
    // end

    reg pre_m_d = 0;
    reg pre_m_u = 0;
    reg pre_m_l = 0;
    reg pre_m_r = 0;


    // handle window and cursor seperately
    always @ (posedge clk, negedge rst) begin
        if (~rst) begin
            win_x <= INITIAL_WIN_X;
            win_y <= INITIAL_WIN_Y;
				cur_r_x = INITIAL_R_CUR_X;
            cur_r_y = INITIAL_R_CUR_Y;
        end else begin
            if (win_mode) begin
                // move winsdow cursor
                if (m_d & ~ pre_m_d) begin
                    win_x <= win_x;
                    win_y <= win_y + 1;
                end
                if (m_u & ~ pre_m_u) begin
                    win_x <= win_x;
                    win_y <= win_y - 1;
                end
                if (m_l & ~ pre_m_l) begin
                    win_x <= win_x - 1;
                    win_y <= win_y;
                end
                if (m_r & ~ pre_m_r) begin
                    win_x <= win_x + 1;
                    win_y <= win_y;
                end
            end else if (cur_mode) begin
                // move cursor
                if (m_d & ~ pre_m_d) begin
                    cur_r_x = cur_r_x;
                    cur_r_y = cur_r_y + 1;
                end
                if (m_u & ~ pre_m_u) begin
                    cur_r_x = cur_r_x;
                    cur_r_y = cur_r_y - 1;
                end
                if (m_l & ~ pre_m_l) begin
                    cur_r_x = cur_r_x -1;
                    cur_r_y = cur_r_y;
                end
                if (m_r & ~ pre_m_r) begin
                    cur_r_x = cur_r_x + 1;
                    cur_r_y = cur_r_y;
                end
            end
            // always update the cached control commands
            pre_m_d <= m_d; 
            pre_m_u <= m_u;     
            pre_m_l <= m_l;     
            pre_m_r <= m_r;
		end
    end
endmodule