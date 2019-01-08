`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:58:10 01/07/2019
// Design Name:   envolve_logic
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/envo_logi_text.v
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

module envo_logi_text;

	// Inputs
	reg clk;
	reg rst;
	reg write_en;
	reg change_state;
	reg [6:0] rAddrR;// be sure to match the port size
	reg [6:0] rAddrC;
	reg [6:0] wAddrR;
	reg [6:0] wAddrC;
	reg write_data;

	// Outputs
	wire read_data;
	wire map_a00;

	// Instantiate the Unit Under Test (UUT)
	envolve_logic #(.K(7)) uut (
		.clk_envo(clk), 
		.rst(rst), 
		.write_en(write_en), 
		.change_state(change_state), 
		.rAddrR(rAddrR), 
		.rAddrC(rAddrC), 
		.wAddrR(wAddrR), 
		.wAddrC(wAddrC), 
		.write_data(write_data), 
		.read_data(read_data),
		.test_bit(map_a00)
	);
	integer i;
	integer j;
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
		rst = 1;
		//change_state = 1;
       rAddrC = 1;
		 rAddrR = 2;
		 # 100;
		 write_en = 1;
		 wAddrC = 1;
		 wAddrR = 2;
		 write_data = 0;
		
		
		
		
		// Add stimulus here

	end
	always begin
		clk = 1; # 10;
		clk = 0; # 10;
		
	end
      
endmodule

