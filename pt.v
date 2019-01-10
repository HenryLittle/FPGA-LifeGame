`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:57:06 01/10/2019
// Design Name:   patterns
// Module Name:   C:/Users/32882/Documents/ISE/GameOfLife/pt.v
// Project Name:  GameOfLife
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: patterns
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pt;

	// Inputs
	reg clka;
	reg [0:0] wea;
	reg [9:0] addra;
	reg [127:0] dina;

	// Outputs
	wire [127:0] douta;

	// Instantiate the Unit Under Test (UUT)
	patterns uut (
		.clka(clka), 
		.wea(wea), 
		.addra(addra), 
		.dina(dina), 
		.douta(douta)
	);

	initial begin
		// Initialize Inputs
		clka = 0;
		wea = 0;
		addra = 0;
		dina = 0;

		// Wait 100 ns for global reset to finish
		#100;
		addra = 0;
        
		// Add stimulus here

	end
	always begin
		clka = 1;# 20;
		clka = 0;# 20;
	end
      
endmodule

