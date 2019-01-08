`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:45 12/29/2018 
// Design Name: 
// Module Name:    envolve_core 
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
module envolve_core(
	input clk,
	input reg has_wall
    );
	 parameter CANVAS_WIDTH = 128;
	 parameter CANVAS_HEIGHT = 96;
	 
	 
	 reg core_num;
	 reg clka;
	 reg write_en;
	 wire addr;
	 reg [ 3: 0] neibor_0;
	 reg [ 3: 0] neibor_1;
	 reg [ 3: 0] neibor_2;
	 reg [127: 0] din1;
	 reg [127: 0] dout1;
	 
	 reg [127: 0] din0;
	 reg [127: 0] dout0;
	 
	 mem_core core_0 (
		.clka(clka), // input clka
		.wea(write_en), // input [0 : 0] wea
		.addra(addr), // input [9 : 0] addra
		.dina(din0), // input [127 : 0] dina
		.douta(dout0) // output [127 : 0] douta
		);
		
	 mem_core core_1 (
		.clka(clka), // input clka
		.wea(write_en), // input [0 : 0] wea
		.addra(addr), // input [9 : 0] addra
		.dina(din1), // input [127 : 0] dina
		.douta(dout1) // output [127 : 0] douta
		);
	 integer x;
	 integer y;
	 initial core_num = 0;
	 always @ (posedge clk) begin
		if (clk == 1) begin
			for (y = 0; y< CANVAS_HEIGHT; y = y + 1) 
				for (x = CANVAS_WIDTH - 1; x >= 0; x = x - 1) begin
					 if (has_wall) begin
					 end else begin
						
					 end
				end
		end
	 end


endmodule
