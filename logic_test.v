`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:08:48 01/06/2019
// Design Name:   envolve_logic
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/logic_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: envolve_logic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module logic_test;

	// Inputs
	reg clk;
	reg rst;
	reg write_en;
	reg change_state;
	reg [5:0] rAddrR;
	reg [5:0] rAddrC;
	reg [5:0] wAddrR;
	reg [5:0] wAddrC;
	reg write_data;

	// Outputs
	wire read_data;

	// Instantiate the Unit Under Test (UUT)
	envolve_logic uut (
		.clk(clk), 
		.rst(rst), 
		.write_en(write_en), 
		.change_state(change_state), 
		.rAddrR(rAddrR), 
		.rAddrC(rAddrC), 
		.wAddrR(wAddrR), 
		.wAddrC(wAddrC), 
		.write_data(write_data), 
		.read_data(read_data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		write_en = 0;
		change_state = 0;
		rAddrR = 0;
		rAddrC = 0;
		wAddrR = 0;
		wAddrC = 0;
		write_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

