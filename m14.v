`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:39:12 01/07/2019 
// Design Name: 
// Module Name:    m14 
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
module main_ctrl(
    clk, rst,
    ps2_byte,
	ps2_state,
    win_ctrl_cmd,
    envo_ctrl_cmd,
    view_width,
    mode
);
    input clk, rst;
    input [7: 0] ps2_byte;
	 input ps2_state;
    output `WIN_CTRL_CMD win_ctrl_cmd;
    output `ENVO_CTRL_CMD envo_ctrl_cmd;
    output [7: 0] view_width;
    output reg mode = 1'b0; // envolve or edit mode
	 
	wire `KEYS keys;
	ps2_parser ps2_p (
        .clk(clk), 
        .ps2_byte(ps2_byte), 
		.ps2_state(ps2_state),
        .keys(keys)
    );

    reg pre_space = 0;
    reg pre_w_mode = 0;
    // window mode 1 or cursor mode 0
    reg w_mode = 0;
    
    always @ (posedge clk or negedge rst) begin
        if (~rst) begin
            mode <= 1'b0;
            w_mode <= 1'b0;
        end else begin
            if (keys[`KEY_SPACE] & ~ pre_space) begin
                mode <= ~mode;
            end
            if (keys[`KEY_W] & ~ pre_w_mode) begin
                w_mode <= ~w_mode;
            end
            pre_w_mode <= keys[`KEY_W];
            pre_space <= keys[`KEY_SPACE];
        end
    end

    reg [7: 0] visi_cell_num = 8;
    reg pre_z_i = 0;
    reg pre_z_o = 0;
	reg has_prsd_z = 0;
 	always @ (posedge clk or negedge rst) begin
	    if (~rst) begin
	        visi_cell_num <= 8'b0000_1000;
	    end else begin
            if (win_ctrl_cmd[`Z_IN] & ~ pre_z_i) begin
                visi_cell_num <= (visi_cell_num > 2) ? visi_cell_num >> 1 : 1;
            end else if (win_ctrl_cmd[`Z_OUT] & ~ pre_z_o) begin
                visi_cell_num <= (visi_cell_num < 64) ? visi_cell_num << 1 : 128;
            end
	        pre_z_i = win_ctrl_cmd[`Z_IN];
            pre_z_o = win_ctrl_cmd[`Z_OUT];
	    end
	end

    assign view_width = visi_cell_num;
 
    assign envo_ctrl_cmd[`CLR]           =  keys[`KEY_C];
    assign envo_ctrl_cmd[`INC_V]         =  keys[`KEY_S_UP];
    assign envo_ctrl_cmd[`DEC_V]         =  keys[`KEY_S_DOWN];
    assign envo_ctrl_cmd[`CUR_USER_CLR] =  keys[`KEY_D];
    assign envo_ctrl_cmd[`CUR_USER_SET]  =  keys[`KEY_E];
    assign envo_ctrl_cmd[`RANDOM]        =  keys[`KEY_R];
    assign envo_ctrl_cmd[`PATTERN]       =  keys[`KEY_P];

    assign win_ctrl_cmd[`M_UP]    = keys[`KEY_AR_U];
    assign win_ctrl_cmd[`M_DOWN]  = keys[`KEY_AR_D];
    assign win_ctrl_cmd[`M_LEFT]  = keys[`KEY_AR_L];
    assign win_ctrl_cmd[`M_RIGHT] = keys[`KEY_AR_R];
    assign win_ctrl_cmd[`Z_IN] = keys[`KEY_IN];
    assign win_ctrl_cmd[`Z_OUT] = keys[`KEY_OUT];
    assign win_ctrl_cmd[`M_MODE] = w_mode;// cur mode

    

endmodule