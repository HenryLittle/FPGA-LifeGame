`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:55:24 01/01/2019
// Design Name:   Fib_LFSR
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/m4_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Fib_LFSR
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module m4_test;

	// Inputs
	reg clk;
	reg rst;
	reg rand_en;

	// Outputs
	wire rand_out;

	// Instantiate the Unit Under Test (UUT)
	Fib_LFSR uut (
		.clk(clk), 
		.rst(rst), 
		.rand_en(rand_en), 
		.rand_out(rand_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		rand_en = 0;

		// Wait 100 ns for global reset to finish
      #100;
		rst = 1;
		rand_en = 1;
        
		// Add stimulus here

	end
	always begin
		clk = 1;#20;
		clk = 0;#20;
	end
      
endmodule

