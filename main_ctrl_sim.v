`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:40:24 01/07/2019
// Design Name:   main_ctrl
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/main_ctrl_sim.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main_ctrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_ctrl_sim;

	// Inputs
	reg clk;
	reg rst;
	reg [15:0] keys;

	// Outputs
	wire [6:0] win_ctrl_cmd;
	wire [6:0] envo_ctrl_cmd;
	wire [7:0] view_width;
	wire mode;
	reg [7: 0] pby;
	reg psta;

	// Instantiate the Unit Under Test (UUT)
	main_ctrl uut (
		.clk(clk), 
		.rst(rst), 
		.ps2_byte(pby),
	   .ps2_state(psta),
		.win_ctrl_cmd(win_ctrl_cmd), 
		.envo_ctrl_cmd(envo_ctrl_cmd), 
		.view_width(view_width), 
		.mode(mode)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		keys = 0;
		psta = 0;

		// Wait 100 ns for global reset to finish
		#200;
		rst = 1;
		pby = 8'h23;
		psta = 1;
		#100;
		psta = 0;
        
		// Add stimulus here

	end
	always begin
	clk = 1;#20;
	clk = 0;#20;
	end
      
endmodule

