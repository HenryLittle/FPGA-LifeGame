`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:59:44 01/02/2019 
// Design Name: 
// Module Name:    m5 
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
module divide (
    numerator,
    denominator,
    quotient,
    remain 
);
    parameter N_WIDTH = 8;
    parameter D_WIDTH = 2;

    input  [N_WIDTH - 1: 0] numerator;
    input  [D_WIDTH - 1: 0] denominator;
    output reg [N_WIDTH - 1: 0] quotient;
    output reg [D_WIDTH - 1: 0] remain;

    reg [N_WIDTH - 1: 0] res = 0;
    reg [N_WIDTH - 1: 0] a1;
    reg [D_WIDTH - 1: 0] b1;
    reg [N_WIDTH - 1: 0] p1;

    // got it from the web with small modification
    // delete this later
    integer i;
    always @ (*) begin
        a1 = numerator;
        b1 = denominator;
		  p1 = 1;
        for (i = 0; i < N_WIDTH; i = i + 1) begin
            p1 = {p1[N_WIDTH - 2: 0], a1[N_WIDTH - 1]};
            a1[N_WIDTH - 1: 1] = a1[N_WIDTH - 2: 0];
            p1 = p1  - b1;
            if (p1[N_WIDTH - 1] == 1) begin
                a1[0] = 0;
                p1 = p1 + b1;
            end else begin
                a1[0] = 1;
            end
        end
        quotient = a1;
        remain = p1;
    end
endmodule