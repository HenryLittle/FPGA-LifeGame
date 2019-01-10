`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:31:56 01/10/2019 
// Design Name: 
// Module Name:    m16 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module color_generator(
	input [4:0] x_index,
	input [4:0] y_index,
	output [7:0] color
	);

	wire [3:0] h;
	wire [2:0] s;

	// TODO: h = 2 * h for variance.
	assign h = x_index * 12 / 32;
	assign s = y_index / 6 + 4;
	
	hsv_to_rgb hsv_to_rgb(h, s, 3'b111, color[7:5], color[4:2], color[1:0]);

endmodule


module hsv_to_rgb(
	// h belongs to [0, 11]
	input [3:0] h,
	input [2:0] s,
	input [2:0] v,
	output [3:0] r,
	output [3:0] g,
	output [3:0] b
	);

	wire [2:0] max = v;
	wire [2:0] _temp = v * s / 7;
	wire [2:0] min = v - _temp;
	wire [2:0] mid = v - _temp / 2;
	wire [2:0] b_;

	assign r = h == 0 || h == 1 || h == 2 || h == 10 || h == 11 ? max :
			h == 3 || h == 9 ? mid :
			min;
	assign g = h == 2 || h == 3 || h == 4 || h == 5 || h == 6 ? max :
			h == 1 || h == 7 ? mid :
			min;
	assign b_ = h == 6 || h == 7 || h == 8 || h == 9 || h == 10 ? max :
			h == 5 || h == 11 ? mid :
			min;
	assign b = b_ / 2;

endmodule