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
	wire [7:0] envo_ctrl_cmd;
	wire [7:0] view_width;
	wire mode;

	// Instantiate the Unit Under Test (UUT)
	main_ctrl uut (
		.clk(clk), 
		.rst(rst), 
		.keys(keys), 
		.win_ctrl_cmd(win_ctrl_cmd), 
		.envo_ctrl_cmd(envo_ctrl_cmd), 
		.view_width(view_width), 
		.mode(mode)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		keys = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		keys[10] = 1;
		#100;
		keys[10] = 0;
		#200;
		keys[10] = 1;
		#100;
		keys[10] = 0;
        
		// Add stimulus here

	end
	always begin
	clk = 1;#20;
	clk = 0;#20;
	end
      
endmodule

