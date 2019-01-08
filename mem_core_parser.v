`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:42:32 12/29/2018 
// Design Name: 
// Module Name:    mem_core_parser 
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
module mem_core_parser(
	input clka,
	input wea,
   input [9: 0]addra,
   input [127: 0] dina,
	output [127: 0] douta
);

mem_core core (
  .clka(clka), // input clka
  .wea(wea), // input [0 : 0] wea
  .addra(addra), // input [9 : 0] addra
  .dina(dina), // input [127 : 0] dina
  .douta(douta) // output [127 : 0] douta
);

endmodule
