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
    parameter K = 4;
    parameter INITIAL_WIN_X = 0;
    parameter INITIAL_WIN_Y = 0;
    parameter INITIAL_R_CUR_X = 3;
    parameter INITIAL_R_CUR_Y = 3;

    input clk, rst;
    input mode; // run = 1, edit = 0
    input `WIN_CTRL_CMD win_ctrl_cmd;
    input [7: 0] view_width; // 

    output reg [K - 1: 0] win_x;
    output reg [K - 1: 0] win_y;
    output [K - 1: 0] cur_x;
    output [K - 1: 0] cur_y;// these are the actual position on the whole board
    
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

    reg [K - 1: 0] next_win_x;
    reg [K - 1: 0] next_win_y;
    reg [K - 1: 0] next_cur_x;
    reg [K - 1: 0] next_cur_y;
    
    reg [K - 1: 0] zoom_win_x;
    reg [K - 1: 0] zoom_win_y;
    reg [K - 1: 0] zoom_cur_r_x;
    reg [K - 1: 0] zoom_cur_r_y;

    reg [7: 0] cur_r_x; // r for relative
    reg [7: 0] cur_r_y;
    // cursor output
    assign cur_x = win_x + cur_r_x;
    assign cur_y = win_y + cur_r_y;

    // the boader
    wire [K - 1: 0] ul_bo;
    wire [K - 1: 0] dr_bo;

    wire at_l;
    wire at_r;
    wire at_u;
    wire at_b;
    /////////////////////////////////////////////////
    // when move view window is needed
    wire m_win_d;
    wire m_win_u;
    wire m_win_l;
    wire m_win_r;
    // when only the cursor is needed to be moved
    wire m_cur_d;
    wire m_cur_u;
    wire m_cur_l;
    wire m_cur_r;

    assign ul_bo = {{2'b00}, view_width[K - 1: 2]}; // diivde by 4
    assign br_bo = {{2'b00}, view_width[K - 1: 2]} + {{1'b0}, view_width[K - 1: 1]};

    assign at_l = (cur_r_x == ul_bo); 
    assign at_r = (cur_r_x + 1'b1 == br_bo);
    assign at_u = (cur_r_y == ul_bo);
    assign at_d = (cur_r_y + 1'b1 == br_bo);

    //assign m_win_d = ((cur_mode & at_d) | (win_mode)) & m_d;
    //assign m_win_u = ((cur_mode & at_u) | (win_mode)) & m_u;
    //assign m_win_l = ((cur_mode & at_l) | (win_mode)) & m_l;
    //assign m_win_r = ((cur_mode & at_r) | (win_mode)) & m_r;

    assign m_win_d = win_mode & m_d;
    assign m_win_u = win_mode & m_u;
    assign m_win_l = win_mode & m_l;
    assign m_win_r = win_mode & m_r;

    // assign m_cur_d = (cur_mode & ~at_d & m_d);
    // assign m_cur_u = (cur_mode & ~at_u & m_u);
    // assign m_cur_l = (cur_mode & ~at_l & m_l);
    // assign m_cur_r = (cur_mode & ~at_r & m_r);

    assign m_cur_d = (cur_mode & m_d);
    assign m_cur_u = (cur_mode & m_u);
    assign m_cur_l = (cur_mode & m_l);
    assign m_cur_r = (cur_mode & m_r);

    always @ (*) begin
        case ({m_cur_l, m_cur_r})
            2'b00: next_cur_x = cur_r_x;            
            2'b01: next_cur_x = cur_r_x + 1'b1;            
            2'b10: next_cur_x = cur_r_x - 1'b1;           
            2'b11: next_cur_x = cur_r_x;            
        endcase
        case ({m_cur_u, m_cur_d})
            2'b00 : next_cur_y = cur_r_y;            
            2'b01 : next_cur_y = cur_r_y + 1'b1;            
            2'b10 : next_cur_y = cur_r_y - 1'b1;           
            2'b11 : next_cur_y = cur_r_y;            
        endcase
        case ({m_win_l, m_win_r})
            2'b00 : next_win_x = win_x;            
            2'b01 : next_win_x = win_x + 1'b1;            
            2'b10 : next_win_x = win_x - 1'b1;           
            2'b11 : next_win_x = win_x;            
        endcase
        case ({m_win_u, m_win_d})
            2'b00 : next_win_y = win_y;            
            2'b01 : next_win_y = win_y + 1'b1;            
            2'b10 : next_win_y = win_y - 1'b1;           
            2'b11 : next_win_y = win_y;            
        endcase
    end
    //////////////////////////////////////////////
    //       ZOOM! not a speedster though.      //
    //////////////////////////////////////////////
    //assign z_en = z_i | z_o;
    assign z_en = 0;
    always @ (*) begin
        if (z_i) begin
            zoom_cur_r_x = {1'b0, cur_r_x[K - 1: 1]};// divide by 2
            zoom_cur_r_y = {1'b0, cur_r_y[K - 1: 1]};
            zoom_win_x = win_x + {2'b00, view_width[K - 1: 2]};// divide by 4
            zoom_win_y = win_y + {2'b00, view_width[K - 1: 2]};
        end 
        else if (z_o) begin
            zoom_cur_r_x = {1'b0, cur_r_x[K - 1: 1]};// divide by 2
            zoom_cur_r_y = {1'b0, cur_r_y[K - 1: 1]};
            zoom_win_x = win_x + {2'b00, view_width[K - 1: 2]};// divide by 4
            zoom_win_y = win_y + {2'b00, view_width[K - 1: 2]};
        end
        else begin
            zoom_cur_r_x = cur_r_x;
            zoom_cur_r_y = cur_r_y;
            zoom_win_x = win_x;
            zoom_win_y = win_y;
        end
    end

    // handle window and cursor seperately
    always @ (posedge clk, negedge rst) begin
        if (~rst) begin
            win_x = INITIAL_WIN_X;
            win_y = INITIAL_WIN_Y;
        end else begin
            win_x = (z_en) ? zoom_win_x : next_win_x;
            win_y = (z_en) ? zoom_win_y : next_win_y;
        end
    end

    always @ (posedge clk, negedge rst) begin
        if (~rst) begin
            cur_r_x = INITIAL_R_CUR_X;
            cur_r_y = INITIAL_R_CUR_Y;
        end else if(mode == 1) begin
            cur_r_x = view_width[K - 1: 1];
            cur_r_y = view_width[K - 1: 1];
        end
        else begin
            cur_r_x = (z_en) ? zoom_cur_r_x : next_cur_x;
            cur_r_y = (z_en) ? zoom_cur_r_y : next_cur_y;
        end
    end
endmodule