`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:09:49 01/01/2019
// Design Name:   random_gen
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/m3_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: random_gen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module m3_test;

	// Inputs
	reg clk;
	reg rst_b;
	reg random_en;

	// Outputs
	wire random_data;

	// Instantiate the Unit Under Test (UUT)
	random_gen uut (
		.clk(clk), 
		.rst_b(rst_b), 
		.random_en(random_en), 
		.random_data(random_data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_b = 0;
		random_en = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst_b = 1;
		random_en = 1;
        
		// Add stimulus here

	end
	always begin
		clk = 1;#20;
		clk = 0;#20;
	end
      
endmodule

