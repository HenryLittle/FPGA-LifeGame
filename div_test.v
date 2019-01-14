`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:14:36 01/12/2019
// Design Name:   divide
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/div_test.v
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

module div_test;

	// Inputs
	reg [7:0] nu;
	reg [7:0] de;

	// Outputs
	wire [7:0] quotient;
	wire [7:0] remain;

	// Instantiate the Unit Under Test (UUT)
	divide #(8, 8)uut (
		.numerator(nu), 
		.denominator(de), 
		.quotient(quotient), 
		.remain(remain)
	);

	initial begin
		// Initialize Inputs
		nu = 0;
		de = 0;

		// Wait 100 ns for global reset to finish
		#100;
      nu = 3;
		de = 8;
		#100;
		nu = 11;
		// Add stimulus here

	end
      
endmodule

