`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:17:27 01/07/2019
// Design Name:   ps2_parser
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/ps2_parse_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ps2_parser
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ps2_parse_test;

	// Inputs
	reg clk;
	reg [7:0] ps2_byte;
	reg ps2_state;

	// Outputs
	wire [15:0] keys;

	// Instantiate the Unit Under Test (UUT)
	ps2_parser uut (
		.clk(clk), 
		.ps2_byte(ps2_byte), 
		.ps2_state(ps2_state), 
		.keys(keys)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		ps2_byte = 0;
		ps2_state = 0;

		// Wait 100 ns for global reset to finish
		#50;
		ps2_byte = 8'h23;
		#40;
		ps2_state = 1;
		//ps2_byte = 0;
        
		// Add stimulus here

	end
	always begin
	clk = 1;#20;
	clk = 0;#20;
	end
      
endmodule

