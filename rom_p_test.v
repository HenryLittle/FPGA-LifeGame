`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:26:45 12/29/2018
// Design Name:   mem_core_parser
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/rom_p_test.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mem_core_parser
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rom_p_test;

	// Inputs
	reg clka;
	reg wea;
	reg [9:0] addra;
	reg [127:0] dina;

	// Outputs
	wire [127:0] dout;
	reg [9: 0] counter;
	// Instantiate the Unit Under Test (UUT)
	mem_core_parser uut (
		.clka(clka), 
		.wea(wea), 
		.addra(counter), 
		.dina(dina), 
		.douta(dout)
	);

	initial begin
		// Initialize Inputs
		clka = 0;
		wea = 0;
		dina = 0;
		counter = 41;

		// Wait 100 ns for global reset to finish
		#100;
		addra = 0;
		#50;
		addra <= addra - 1;
	end
	always begin
	clka = 0;#50;
	clka = 1;#50;
	end
	always @ (posedge clka) begin
		//counter <= counter + 1'b1;
		//addra <= counter;
		if (&counter == 1) begin
			counter <= 0;
		end
	end
      
endmodule

