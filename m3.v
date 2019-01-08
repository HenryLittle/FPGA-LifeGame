`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:51 01/01/2019 
// Design Name: 
// Module Name:    m3 
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
module random_gen(clk, rst_b, random_en, random_data);
  parameter SEED = 18'h1;
  input clk, rst_b;
  input random_en;
  output random_data;

  reg [17:0] shift_reg;
  wire msb;

  assign random_data = shift_reg[17];
  // Check wikipedia for values  (x^18 + x^11 + 1)
  assign msb = shift_reg[17] ^ shift_reg[10] ^ shift_reg[0];

  always @(posedge clk, negedge rst_b) begin
    if(~rst_b) shift_reg <= SEED;
    else if(random_en) shift_reg <= {msb, shift_reg[17:1]};
    else shift_reg <= shift_reg ;
  end

endmodule
