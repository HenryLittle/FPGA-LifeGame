`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:45:39 12/29/2018
// Design Name:   hvsync_generator
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/hs_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: hvsync_generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module hs_test;

	// Inputs
	reg clk;

	// Outputs
	wire vga_h_sync;
	wire vga_v_sync;
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [8:0] CounterY;

	// Instantiate the Unit Under Test (UUT)
	hvsync_generator uut (
		.clk(clk), 
		.vga_h_sync(vga_h_sync), 
		.vga_v_sync(vga_v_sync), 
		.inDisplayArea(inDisplayArea), 
		.CounterX(CounterX), 
		.CounterY(CounterY)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always begin
	clk = 1;#10;
	clk = 0;#10;
	end
      
endmodule

