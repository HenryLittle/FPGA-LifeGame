`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:18:51 01/10/2019
// Design Name:   envolve_ctrl
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/ev_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: envolve_ctrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ev_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] envo_ctrl_cmd;
	reg mode;
	reg [7:0] cur_x;
	reg [7:0] cur_y;

	// Outputs
	wire change_state;
	wire [7:0] wAddrR;
	wire [7:0] wAddrC;
	wire write_en;
	wire write_data;
	wire random_en;
	wire clear_en;
	wire pattern_en;

	// Instantiate the Unit Under Test (UUT)
	envolve_ctrl uut (
		.clk(clk), 
		.rst(rst), 
		.envo_ctrl_cmd(envo_ctrl_cmd), 
		.change_state(change_state), 
		.mode(mode), 
		.wAddrR(wAddrR), 
		.wAddrC(wAddrC), 
		.write_en(write_en), 
		.write_data(write_data), 
		.cur_x(cur_x), 
		.cur_y(cur_y), 
		.random_en(random_en), 
		.clear_en(clear_en), 
		.pattern_en(pattern_en)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		envo_ctrl_cmd = 0;
		mode = 0;
		cur_x = 0;
		cur_y = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		mode = 0;
		envo_ctrl_cmd[6] = 1;
		#50;
		envo_ctrl_cmd[6] = 0;
        
		// Add stimulus here

	end
	always begin
		clk = 1;# 20;
		clk = 0;# 20;
	end
      
endmodule

