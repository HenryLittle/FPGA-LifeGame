`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:51:57 01/01/2019 
// Design Name: 
// Module Name:    m4 
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
module Fib_LFSR2 (
    clk, rst,
    rand_en,
    rand_out
);
    parameter SEED = 3'd825;
    // the feedback polynomial
    // x^{16}+x^{14}+x^{13}+x^{11}+1
    input clk, rst;
    input rand_en;
	 output rand_out;
	 
    reg [16: 0] LFSR;
    wire feedbk;
	 
    assign feedbk = LFSR[15] ^ LFSR[13] ^ LFSR[12] ^ LFSR[10];
    //assign rand_out = LFSR[0];
	 assign rand_out = feedbk;
	 
    always @ (posedge clk or negedge rst) begin
        if (~rst) begin
            LFSR <= SEED;
        end else if (rand_en) begin
            LFSR <= {LFSR[14: 0], feedbk};
        end else begin
			   LFSR <= LFSR;
		  end
    end
endmodule