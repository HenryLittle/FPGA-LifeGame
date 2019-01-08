`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:36:06 01/01/2019
// Design Name:   envolve_v_ctrl
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/m2_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: envolve_v_ctrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module m2_test;

	// Inputs
	reg clk;
	reg rst;
	reg mode;
	reg inc_v;
	reg dec_v;

	// Outputs
	wire envolve_v;
	wire [20:0] step;
	wire [24:0] count;

	// Instantiate the Unit Under Test (UUT)
	envolve_v_ctrl uut (
		.clk(clk), 
		.rst(rst), 
		.mode(mode), 
		.inc_v(inc_v), 
		.dec_v(dec_v), 
		.envolve_v(envolve_v), 
		.step(step), 
		.count(count)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		mode = 0;
		inc_v = 0;
		dec_v = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 1;
		mode = 1;
		// Add stimulus here
		inc_v = 1;#1000;
		inc_v = 0;
		dec_v = 1;#1000;
		dec_v = 0;

	end
	always begin
		clk = 1;#20;
		clk = 0;#20;
	end
      
endmodule

