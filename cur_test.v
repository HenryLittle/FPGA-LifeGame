`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:25:28 01/07/2019
// Design Name:   cursor_ctrl
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/cur_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cursor_ctrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cur_test;

	// Inputs
	reg clk;
	reg rst;
	reg mode;
	reg [6:0] win_ctrl_cmd;
	reg [7:0] view_width;

	// Outputs
	wire [3:0] win_x;
	wire [3:0] win_y;
	wire [3:0] cur_x;
	wire [3:0] cur_y;

	// Instantiate the Unit Under Test (UUT)
	cursor_ctrl uut (
		.clk(clk), 
		.rst(rst), 
		.mode(mode), 
		.win_ctrl_cmd(win_ctrl_cmd), 
		.win_x(win_x), 
		.win_y(win_y), 
		.cur_x(cur_x), 
		.cur_y(cur_y), 
		.view_width(view_width)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		mode = 0;
		win_ctrl_cmd = 0;
		view_width = 8;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		win_ctrl_cmd[3] = 1;
		# 20;
		win_ctrl_cmd[3] = 0;
		#20;
		win_ctrl_cmd[4] = 1;
		#20;
		win_ctrl_cmd[4] = 0;
        
		// Add stimulus here

	end
	always begin
		clk = ~clk;#20;
	end
      
endmodule

