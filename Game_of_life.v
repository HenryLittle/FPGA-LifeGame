`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:39:12 12/29/2018 
// Design Name: 
// Module Name:    Game_of_life 
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
module Game_of_life(
	input clk,
	input rstn,
	input [15:0]SW,
	output hs,
	output vs,
	output [3:0] r,
	output [3:0] g,
	output [3:0] b,
	output SEGLED_CLK,
	output SEGLED_CLR,
	output SEGLED_DO,
	output SEGLED_PEN,
   output LED_CLK,
	output LED_CLR,
	output LED_DO,
	output LED_PEN,
	inout [4:0]BTN_X,
	inout [3:0]BTN_Y,
	output buzzer
    );
	reg testreg;
	wire testwire;
	always @ (*) begin
		testwire = testreg;
	end

endmodule
