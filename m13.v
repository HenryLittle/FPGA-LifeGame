`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:33:03 01/07/2019 
// Design Name: 
// Module Name:    m13 
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

module ps2_parser(
    input clk,
    input [7: 0] ps2_byte,
	 input ps2_state,
    output `KEYS keys
);
    reg [31: 0] count;
	    always @ (posedge clk) begin
            count <= count + 1;
    end 
    reg [2:0] ps2_state_sampling = 3'b0;
    wire ps2_posedge_state = ps2_state_sampling[1] & ~ps2_state_sampling[2];

    always @ (posedge count[10]) begin
        ps2_state_sampling <= {ps2_state_sampling[1:0], ps2_state};
    end
    
    keys[`KEY_AR_U  ] = ps2_posedge_state && (ps2_byte == 8'h75);
    keys[`KEY_AR_D  ] = ps2_posedge_state && (ps2_byte == 8'h72);
    keys[`KEY_AR_L  ] = ps2_posedge_state && (ps2_byte == 8'h6B);
    keys[`KEY_AR_R  ] = ps2_posedge_state && (ps2_byte == 8'h74);
    keys[`KEY_W     ] = ps2_posedge_state && (ps2_byte == 8'h1D);
    keys[`KEY_A     ] = ps2_posedge_state && (ps2_byte == 8'h1C);
    keys[`KEY_S     ] = ps2_posedge_state && (ps2_byte == 8'h1B);
    keys[`KEY_D     ] = ps2_posedge_state && (ps2_byte == 8'h23);
    keys[`KEY_IN    ] = ps2_posedge_state && (ps2_byte == 8'h43);
    keys[`KEY_OUT   ] = ps2_posedge_state && (ps2_byte == 8'h44);
    keys[`KEY_SPACE ] = ps2_posedge_state && (ps2_byte == 8'h4C);
    keys[`KEY_R     ] = ps2_posedge_state && (ps2_byte == 8'h2D);
    keys[`KEY_E     ] = ps2_posedge_state && (ps2_byte == 8'h24);
    keys[`KEY_ENTER ] = ps2_posedge_state && (ps2_byte == 8'h5A);
    keys[`KEY_S_DOWN] = ps2_posedge_state && (ps2_byte == 8'h54);// [
    keys[`KEY_S_UP  ] = ps2_posedge_state && (ps2_byte == 8'h5B);// ]

endmodule