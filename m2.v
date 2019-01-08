`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:04 01/01/2019 
// Design Name: 
// Module Name:    m2 
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
module envolve_v_ctrl2 (
    clk,
    rst,
    mode,
    inc_v,
    dec_v,
    envolve_v
);
    parameter U_BOUND = 20'b1000_0000_0000_0000_0000;

    input wire clk, mode,rst;
    input wire inc_v, dec_v;
    output wire envolve_v;

    output reg [24: 0] count;
    output reg [20: 0] step;
    wire [31: 0] count_next;
    assign count_next = mode ? (count + step) : 1'b1;
    assign envolve_v = count > U_BOUND;
	
    always @ (posedge clk or negedge rst) begin
        if (~rst) begin
            count <= 32'b0;
        end else begin
            count <= count_next;
        end
    end
	 always @ (posedge clk or negedge rst) begin
	     if (~rst) begin
				step <= 20'b1;
		      next_step <= 20'b1;
		  end if (inc_v) begin
            step <= (step < U_BOUND) ? step << 1 : step;
        end else if (dec_v) begin
            step <= (step > 1'b1) ? {1'b0, step[20: 1]} : step;
		  end
	 end
endmodule
