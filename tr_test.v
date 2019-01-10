`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:21:24 01/09/2019
// Design Name:   travers_boardm
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/tr_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: travers_boardm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tr_test;

	// Inputs
	reg clk;
	reg rst;
	reg en;

	// Outputs
	wire [7:0] addrC;
	wire [7:0] addrR;
	wire finish;

	// Instantiate the Unit Under Test (UUT)
	travers_boardm uut (
		.clk(clk), 
		.rst(rst), 
		.enable(en), 
		.addrC(addrC), 
		.addrR(addrR), 
		.finish(finish)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		en = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#100;
		en = 1;
		
        
		// Add stimulus here

	end
	always begin
		clk = 1; #20;
		clk = 0; # 20;
	end
      
endmodule

