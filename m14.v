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
    output reg mode;

    parameter ZOOM_MIN = 8'b0000_1000; //  8
    parameter ZOOM_MAX = 8'b1000_0000; //128
	 
	 wire `KEYS keys;
	 ps2_parser ps2_p (
        .clk(clk), 
        .ps2_byte(ps2_byte), 
		  .ps2_state(ps2_state)
        .keys(keys)
    );


    // change mode @ tested
    always @ (posedge keys[`KEY_SPACE] or negedge rst) begin
        if (~rst) begin
            mode <= 1'b0;
        end else begin
            mode <= ~mode;
        end
    end
	 

    //envo_ctrl_cmd[`CLR] = keys[`KEY_R];
    assign envo_ctrl_cmd[`INC_V] = keys[`KEY_S_UP];
    assign envo_ctrl_cmd[`DEC_V] = keys[`KEY_S_DOWN];
    assign envo_ctrl_cmd[`CUR_USER_DATA] = keys[`KEY_E];
    assign envo_ctrl_cmd[`CUR_USER_SET] = keys[`KEY_E];
    assign envo_ctrl_cmd[`RANDOM] = keys[`KEY_R];

    assign win_ctrl_cmd[`M_UP]    = keys[`KEY_AR_U];
    assign win_ctrl_cmd[`M_DOWN]  = keys[`KEY_AR_D];
    assign win_ctrl_cmd[`M_LEFT]  = keys[`KEY_AR_L];
    assign win_ctrl_cmd[`M_RIGHT] = keys[`KEY_AR_R];
    assign win_ctrl_cmd[`Z_IN] = keys[`KEY_IN];
    assign win_ctrl_cmd[`Z_OUT] = keys[`KEY_OUT];
    assign win_ctrl_cmd[`M_MODE] = 1'b0;// cur mode

    

endmodule