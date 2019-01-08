`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:44:35 12/31/2018
// Design Name:   addr_walkthrough
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/m1_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: addr_walkthrough
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module m1_test;

	// Inputs
	reg clk;
	reg rst_b;
	reg en;

	// Outputs
	wire [6:0] addrR;
	wire [6:0] addrC;
	wire done;
	reg [13: 0] test_val;

	// Instantiate the Unit Under Test (UUT)
	addr_walkthrough uut (
		.clk(clk), 
		.rst_b(rst_b), 
		.en(en), 
		.addrR(addrR), 
		.addrC(addrC), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_b = 0;
		en = 0;

		// Wait 100 ns for global reset to finish
		#100;
       en = 1;
		 rst_b = 1;
		 test_val = ~{14{1'b0}};
		 
		// Add stimulus here

	end
	always begin
		clk = 1;#30;
		clk = 0;#30;
	end
      
endmodule

