`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////////
//      _____       ___       ___  ___   _____        _____   _____        _       _   _____   _____  //
//     /  ___|     /   |     /   |/   | | ____|      /  _  \ |  ___|      | |     | | |  ___| | ____| //
//    | |        / /| |    / /|   /| | | |__        | | | | | |__        | |     | | | |__   | |__    //
//   | |  _    / / | |   / / |__/ | | |  __|       | | | | |  __|       | |     | | |  __|  |  __|    //
//  | |_| |  / /  | |  / /       | | | |___       | |_| | | |          | |___  | | | |     | |___     //
// \_____/ /_/   |_| /_/        |_| |_____|      \_____/ |_|          |_____| |_| |_|     |_____|     //
//                                             Henry Little                                           //
////////////////////////////////////////////////////////////////////////////////////////////////////////
`include "defines.v"
module LifeGame(
   input clk,
	input rstn,
	input [15:0]SW,
	input ps2_clk,
	input ps2_data,
	output hs,
	output vs,
	output [3:0] r,
	output [3:0] g,
	output [3:0] b,
	inout [4:0] BTN_X,
	inout [3:0] BTN_Y,
	output SEGLED_CLK,
	output SEGLED_CLR,
	output SEGLED_DO,
	output SEGLED_PEN,
    output LED_CLK,
	output LED_CLR,
	output LED_DO,
	output LED_PEN
);

    // // window and cursor control commands
    // `define WIN_CTRL_CMD [6: 0]
    // `define M_UP 0
    // `define M_DOWN 1
    // `define M_LEFT 2
    // `define M_RIGHT 3
    // `define Z_IN 4
    // `define Z_OUT 5
    // `define M_MODE 6
    
    // // envolve control related commands
    // `define ENVO_CTRL_CMD [7: 0]
    // `define CLR 0
    // `define INC_V 1
    // `define DEC_V 2
    // `define CUR_USER_DATA 3
    // `define CUR_USER_SET 4
    // `define RANDOM 5
    wire `WIN_CTRL_CMD win_ctrl_cmd;
    wire `ENVO_CTRL_CMD envo_ctrl_cmd;
    reg [31: 0] count;
	always @ (posedge clk) begin
        count <= count + 1;
    end 
    parameter visi_num_cells = 8'b1000_0000;

    wire [9: 0] pAddrC_X;
	wire [8: 0] pAddrR_Y;
	wire rst;
	assign rst = SW[15];

    wire [11: 0] disp_value_RGB;
	 
	wire mode;
    wire [6: 0] wAddrC, wAddrR;
    wire [2: 0] testbits;
	wire [7: 0] view_width;
    envolve_sub_top #( .MAP_WIDTH(48), .MAP_HEIGHT(48)) envolve(
       .clk(clk), .rst(rst),
       .scan_x(pAddrC_X),
       .scan_y({1'b0, pAddrR_Y}),
       .mode(mode),
       .visi_cell_num(view_width),
       .win_ctrl_cmd(win_ctrl_cmd), // SW[6: 0]
       .envo_ctrl_cmd(envo_ctrl_cmd), // SW[14: 7]
       .disp_value_RGB(disp_value_RGB),
       .testbits(testbits)
    );
	 
	wire [7: 0] ps2_byte; // output from ps2 driver
	wire ps2_state;       // output form ps2 driver
	main_ctrl mainCtrl (
        .clk(clk), 
        .rst(rst), 
        .ps2_byte(ps2_byte), 
        .ps2_state(ps2_state), 
        .win_ctrl_cmd(win_ctrl_cmd), 
        .envo_ctrl_cmd(envo_ctrl_cmd), 
        .view_width(view_width), 
        .mode(mode)
    );
	 
	///////////////////////////////////////////////////
	//                    DRIVERS                    //
	///////////////////////////////////////////////////
    VGA_driver vga (
		.clk_25MHz(count[1]), 
        .rst(1'b0), 
        .Din(disp_value_RGB), 
        .row(pAddrR_Y), 
        .col(pAddrC_X), 
        .R(r), 
        .G(g), 
        .B(b), 
        .HS(hs), 
        .VS(vs)
    );
	 
	
	wire [3: 0] sout;    // connection bus to the board
	Seg7Device segDevice(
        .clkIO(count[3]), 
        .clkScan(count[15:14]),
        .clkBlink(count[25]),
		.data({{1'b0}, wAddrC, {1'b0}, wAddrR, {7{1'b0}}, mode, ps2_byte}),
        .point(8'h0), .LES(8'h0),
		.sout(sout)
    );
	 assign SEGLED_CLK = sout[3];
	 assign SEGLED_DO  = sout[2];
	 assign SEGLED_PEN = sout[1];
	 assign SEGLED_CLR = sout[0];
	
	PS2_driver ps2 (
        .clk(clk), 
        .rst(rst), 
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data), 
        .ps2_byte(ps2_byte), 
        .ps2_state(ps2_state)
    );
	 
    ShiftReg 
	#(.WIDTH(16)) leddirver (
        .clk(count[3]), 
        .pdata({~mode, ~testbits, ~envo_ctrl_cmd[6: 3], ~ps2_byte}), 
        .sout({LED_CLK,LED_DO,LED_PEN,LED_CLR})
    );

endmodule