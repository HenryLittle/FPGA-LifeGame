`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:52 12/31/2018 
// Design Name: 
// Module Name:    m1 
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
`include "defines.v"
module addr_walkthrough(clk, rst_b, en, addrR, addrC, done);
  parameter K = 7;
  input clk, rst_b;
  input en;
  output wire [K-1:0] addrR;
  output wire [K-1:0] addrC;
  output wire done;

  reg [2*K-1:0] count;  

  assign addrR = count[2*K-1:K];
  assign addrC = count[K-1:0];
  //assign done = (count == (~{{2*K}{1'b0}}) );
  assign done = (1'b1 == &count);
  //assign done = `K_DEF;
  always @(posedge clk, negedge rst_b) begin
    if(~rst_b) count <= 'h0;
    else if(en) begin
      count <= count + 1'b1;
    end
  end

//TODO Assertion check (walkthrough)
// while ~enable, count ==0
endmodule