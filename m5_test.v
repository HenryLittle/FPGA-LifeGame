`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:00:39 01/02/2019
// Design Name:   divide
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/m5_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: divide
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module m5_test;

	// Inputs
	reg [7:0] numerator;
	reg [3:0] denominator;

	// Outputs
	wire [7:0] quotient;
	wire [3:0] remain;

	// Instantiate the Unit Under Test (UUT)
	divide #(8, 4) uut (
		.numerator(numerator), 
		.denominator(denominator), 
		.quotient(quotient), 
		.remain(remain)
	);

	initial begin
		// Initialize Inputs
		numerator = 0;
		denominator = 0;

		// Wait 100 ns for global reset to finish
		#100;
		numerator = 19;
		denominator = 5;
		#100;
		numerator = 3;
		denominator = 8;
      #100;
		numerator = 20;
		denominator = 5;
		#100;
		numerator = 0;
		denominator = 5;
		// Add stimulus here

	end
      
endmodule

