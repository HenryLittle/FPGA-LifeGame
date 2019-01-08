`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:03:49 01/08/2019
// Design Name:   envolve_v_ctrl
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/v_ctrl_test.v
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

module v_ctrl_test;

	// Inputs
	reg clk;
	reg rst;
	reg mode;
	reg inc_v;
	reg dec_v;

	// Outputs
	wire envolve_v;
	wire [24: 0] step;

	// Instantiate the Unit Under Test (UUT)
	envolve_v_ctrl uut (
		.clk(clk), 
		.rst(rst), 
		.mode(mode), 
		.inc_v(inc_v), 
		.dec_v(dec_v), 
		.envolve_v(envolve_v),
		.test_p1(step)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		mode = 1;
		inc_v = 0;
		dec_v = 0;

		// Wait 100 ns for global reset to finish
		#10;
		rst = 1;
		#1000;
		mode = 1;
		inc_v = 1;#100;
		inc_v = 0;
        
		// Add stimulus here

	end
	always begin
		clk = 1; #20;
		clk = 0; #20;
	end
      
endmodule

