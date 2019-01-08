`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:55 01/02/2019 
// Design Name: 
// Module Name:    m6 
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
module divide2 (
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

    reg[D_WIDTH: 0] cmp[N_WIDTH - 1: 0];
    reg[D_WIDTH: 0] sub[N_WIDTH - 1: 0];
    
    // got it from the web with small modification
    // delete this later
    integer i;
    always @ (*) begin
        cmp[N_WIDTH - 1] = {{D_WIDTH{1'b0}}, numerator[N_WIDTH - 1]};
        for (i = N_WIDTH - 1; i > 0; i = i - 1) begin
            sub[i] = cmp[i] - {1'b0, denominator};
            quotient[i] = ~sub[i][D_WIDTH];
            if (~sub[i][D_WIDTH]) cmp[i - 1] = {sub[i][D_WIDTH - 1: 0], numerator[i - 1]};
            else cmp[i - 1] = {cmp[i][D_WIDTH - 1: 0], numerator[i - 1]};
        end
        sub[0] = cmp[0] - {1'b0, denominator};
        quotient[0] = ~sub[0][D_WIDTH];
        remain = (quotient[0]) ? sub[0][D_WIDTH - 1: 0] : cmp[0][D_WIDTH - 1: 0];
    end
endmodule
