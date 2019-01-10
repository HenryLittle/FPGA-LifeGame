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
    reg [31: 0] count = 0;
	always @ (posedge clk) begin
        count <= count + 1;
    end 
    reg [2:0] ps2_state_sampling = 3'b0;
    wire ps2_posedge_state;
    assign ps2_posedge_state = ps2_state_sampling[1] & ~ps2_state_sampling[2];
    //assign ps2_posedge_state = ps2_state;
    // constrain all the key input to a specifitc time length
    always @ (posedge count[5]) begin
        ps2_state_sampling <= {ps2_state_sampling[1:0], ps2_state};
    end
    
    assign keys[`KEY_AR_U  ] = count[22] & ps2_state & (ps2_byte == 8'h75); // enable long press
    assign keys[`KEY_AR_D  ] = count[22] & ps2_state & (ps2_byte == 8'h72);
    assign keys[`KEY_AR_L  ] = count[22] & ps2_state & (ps2_byte == 8'h6B);
    assign keys[`KEY_AR_R  ] = count[22] & ps2_state & (ps2_byte == 8'h74);
    assign keys[`KEY_W     ] = ps2_posedge_state & (ps2_byte == 8'h1D);
    assign keys[`KEY_D     ] = ps2_posedge_state & (ps2_byte == 8'h23);
    assign keys[`KEY_SPACE ] = ps2_posedge_state & (ps2_byte == 8'h29);
    assign keys[`KEY_IN    ] = ps2_state & (ps2_byte == 8'h43);
    assign keys[`KEY_OUT   ] = ps2_state & (ps2_byte == 8'h44);
    assign keys[`KEY_C     ] = ps2_state & (ps2_byte == 8'h21);
    assign keys[`KEY_P     ] = ps2_state & (ps2_byte == 8'h4D);
    assign keys[`KEY_R     ] = ps2_state & (ps2_byte == 8'h2D);
    assign keys[`KEY_E     ] = ps2_state & (ps2_byte == 8'h24);
    assign keys[`KEY_ENTER ] = count[23] & ps2_state & (ps2_byte == 8'h5A);
    assign keys[`KEY_S_DOWN] = ps2_posedge_state & (ps2_byte == 8'h54);// [
    assign keys[`KEY_S_UP  ] = ps2_posedge_state & (ps2_byte == 8'h5B);// ]

endmodule