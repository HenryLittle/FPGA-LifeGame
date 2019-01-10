`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:25:41 01/06/2019 
// Design Name: 
// Module Name:    m10 
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
// the geme cell top (wrapper)
// `define H_DIV K_POW-1:K_POW/2
// `define L_DIV K_POW/2-1:0

// module envolve_logic (
//     clk, rst,
//     write_en,
//     change_state,
//     rAddrR, rAddrC,
//     wAddrR, wAddrC,
//     write_data,
//     read_data
// );
//     parameter K = 6; // the layer indicator
//     parameter K_POW = 1<<K;

//     input clk, rst;
//     input write_en;
//     input change_state;
//     input [K - 1: 0] rAddrR, rAddrC;
//     input [K - 1: 0] wAddrR, wAddrC;
//     input write_data;
//     output read_data;

//     wire [K_POW - 1: 0] u_2_b, b_2_u, l_2_r, r_2_l;
//     cellQuad #(K) cells (
//         .u_in(b_2_u), .b_in(u_2_b), .l_in(r_2_l), .r_in(l_2_r),
//         .ul_in(b_2_u[0]), .ur_in(b_2_u[K_POW - 1]), .bl_in(u_2_b[0]), .br_in(u_2_b[K_POW - 1]),
//         .u_out(u_2_b), .b_out(b_2_u), .l_out(l_2_r), .r_out(r_2_l),
//         .write_en(write_en), .write_data(write_data),
//         .change_state(change_state),
//         .rAddrC(rAddrC), .rAddrR(rAddrR),
//         .wAddrC(wAddrC), .wAddrR(wAddrR),
//         .clk(clk), .rst_c(rst),
//         .read_data(read_data)
//     ); 

// endmodule

// module cellQuad(
//     u_in, // uppper input
//     b_in, // bottom input
//     l_in, // left input
//     r_in, // right input
//     ul_in, // upper left
//     ur_in, // upper right
//     bl_in, // bottom left
//     br_in, // bottom right
//     write_en, // enable write in edit mode
//     change_state, // the clock for the cell iteration
//     rAddrR, rAddrC,
//     wAddrR, wAddrC,
//     write_data, // data to write to the cell when write_en
//     clk, rst_c,
//     read_data, // output the current cell state
//     u_out, b_out, l_out, r_out
// );
//     parameter K = 6; // the layer indicator
//     parameter K_POW = 1<<K;

//     input [K_POW - 1: 0] u_in, b_in, l_in, r_in;
//     input ul_in, ur_in, bl_in, br_in;
//     input write_en, change_state, clk, rst_c;
//     input [K:0] rAddrR, rAddrC;
//     input [K:0] wAddrR, wAddrC;
//     input write_data; // data to write to the cell when write_en
//     output wire read_data; // output the current cell state
//     output wire [K_POW - 1: 0] u_out, b_out, l_out, r_out;
    
//     // this is also a powerful verilog statement
//     // a. create multiple instantiations of modules
//     // b. conditionally instantiate blocks of code
//     generate;
//         if (K == 0) begin
//             baseLyaer base (
//                 .u_in(u_in), .b_in(b_in), .l_in(l_in), .r_in(r_in),
//                 .ul_in(ul_in), .ur_in(ur_in), .bl_in(bl_in), .br_in(br_in),
//                 .u_out(u_out), .b_out(b_out), .l_out(l_out), .r_out(r_out),
//                 .write_en(write_en), .change_state(change_state),
//                 .rAddrR(rAddrR), .rAddrC(rAddrC),
//                 .wAddrR(wAddrR), .wAddrC(wAddrC),
//                 .write_data(write_data),
//                 .clk(clk), .rst_c(rst_c),
//                 .read_data(read_data)
//             );
//         end else begin
//             kLayer #(K) k_layer (
//                 .u_in(u_in), .b_in(b_in), .l_in(l_in), .r_in(r_in),
//                 .ul_in(ul_in), .ur_in(ur_in), .bl_in(bl_in), .br_in(br_in),
//                 .u_out(u_out), .b_out(b_out), .l_out(l_out), .r_out(r_out),
//                 .write_en(write_en), .change_state(change_state),
//                 .rAddrR(rAddrR), .rAddrC(rAddrC),
//                 .wAddrR(wAddrR), .wAddrC(wAddrC),
//                 .write_data(write_data),
//                 .clk(clk), .rst_c(rst_c),
//                 .read_data(read_data)
//             );
//         end
//     endgenerate
// endmodule

// // when k is 0
// module baseLyaer(
//     u_in, // uppper input
//     b_in, // bottom input
//     l_in, // left input
//     r_in, // right input
//     ul_in, // upper left
//     ur_in, // upper right
//     bl_in, // bottom left
//     br_in, // bottom right
//     write_en, // enable write in edit mode
//     change_state, // the clock for the cell iteration
//     rAddrR, rAddrC,
//     wAddrR, wAddrC,
//     write_data, // data to write to the cell when write_en
//     clk, rst_c,
//     read_data, // output the current cell state
//     u_out, b_out, l_out, r_out
// );
//     // this is the base cell
//     // contains the basic envolve logic
//     input u_in, b_in, l_in, r_in;
//     input ul_in, ur_in, bl_in, br_in;
//     input write_en, change_state, clk, rst_c;
//     input rAddrR, rAddrC; // not used in this module
//     input wAddrR, wAddrC; // not used in this module
//     input write_data; // data to write to the cell when write_en
//     output reg read_data; // output the current cell state
//     output reg u_out, b_out, l_out, r_out;

//     reg [1: 0] neighbor_c_01, neighbor_c_02, neighbor_c_03, neighbor_c_04;
//     reg [2: 0] neighbor_c_11, neighbor_c_12;
//     reg [3: 0] neighbor_num;

//     reg Current_State, Next_State;

//     // the true logic of GAME OF LIFE
//     always @ (*) begin
//         // jsut sum up the neighbors of the cell
//         neighbor_c_01 = {1'b0, u_in} + {1'b0, ul_in};
//         neighbor_c_02 = {1'b0, r_in} + {1'b0, ur_in};
//         neighbor_c_03 = {1'b0, b_in} + {1'b0, bl_in};
//         neighbor_c_04 = {1'b0, l_in} + {1'b0, bl_in};

//         neighbor_c_11 = {1'b0, neighbor_c_01} + {1'b0, neighbor_c_02};
//         neighbor_c_12 = {1'b0, neighbor_c_03} + {1'b0, neighbor_c_04};

//         neighbor_num = {1'b0, neighbor_c_11} + {1'b0, neighbor_c_12};

//         read_data = Current_State;
//         u_out = Current_State;
//         b_out = Current_State;
//         l_out = Current_State;
//         r_out = Current_State;
//     end

//     always @ (*) begin
//         if (write_en) Next_State = write_data;
//         else if (change_state) Next_State = (neighbor_num == 3'h3) || (Current_State & (neighbor_num == 2));
//         else Next_State = Current_State;
//     end

//     // reset the cell
//     always @ (posedge clk or negedge rst_c) begin
//         if (~rst_c) Current_State <= 1'b0;
//         else Current_State <= Next_State;
//     end

// endmodule

// module kLayer(
//     u_in, // uppper input
//     b_in, // bottom input
//     l_in, // left input
//     r_in, // right input
//     ul_in, // upper left
//     ur_in, // upper right
//     bl_in, // bottom left
//     br_in, // bottom right
//     write_en, // enable write in edit mode
//     change_state, // the clock for the cell iteration
//     rAddrR, rAddrC,
//     wAddrR, wAddrC,
//     write_data, // data to write to the cell when write_en
//     clk, rst_c,
//     read_data, // output the current cell state
//     u_out, b_out, l_out, r_out
// );
//     parameter K = 6; // the layer indicator
//     parameter K_POW = 1<<K;

//     input [K_POW - 1: 0] u_in, b_in, l_in, r_in;
//     input ul_in, ur_in, bl_in, br_in;
//     input write_en, change_state, clk, rst_c;
//     input [K: 0] rAddrR, rAddrC;
//     input [K: 0] wAddrR, wAddrC;
//     input write_data; // data to write to the cell when write_en
//     output reg read_data; // output the current cell state
//     output wire [K_POW - 1: 0] u_out, b_out, l_out, r_out;

//     reg we00, we01, we10, we11;
//     wire read_data00, read_data01, read_data10, read_data11;

//     // four contact edges, connect both way with 8 wires
//     wire [K_POW/2 - 1: 0] cell00_to_01, cell01_to_00;
//     wire [K_POW/2 - 1: 0] cell00_to_10, cell10_to_00;
//     wire [K_POW/2 - 1: 0] cell01_to_11, cell11_to_01;
//     wire [K_POW/2 - 1: 0] cell10_to_11, cell11_to_10;
//     // contact conners
//     // conners are aquired from the edges

//     always @ (*) begin
//       we00 = 1'b0;
//       we01 = 1'b0;
//       we10 = 1'b0;
//       we11 = 1'b0;
//       if (write_en) begin
//         case({wAddrR[K], wAddrC[K]})
//             2'b00: we00 = 1'b1;
//             2'b01: we01 = 1'b1;
//             2'b10: we10 = 1'b1;
//             2'b11: we11 = 1'b1;
//         endcase
//       end
//       case ({rAddrR[K], rAddrC[K]})
//             2'b00: read_data = read_data00;
//             2'b01: read_data = read_data01;
//             2'b10: read_data = read_data10;
//             2'b11: read_data = read_data11;
//       endcase
//     end
//     // there are four cell block in one layer
//     //
//     //    ______________  _______________
//     //  |               |                |
//     //  |               |                |
//     //  |       00      |       01       |
//     //  |               |                |
//     //  |               |                |
//     //    ______________  _______________
//     //  |               |                |
//     //  |               |                |
//     //  |       10      |       11       |
//     //  |               |                |
//     //  |               |                |
//     //    ______________  _______________
//     //
//     cellQuad #(.K(K - 1))
//         cell00(
//             .u_in(u_in[`H_DIV]), // uppper input
//             .b_in(cell10_to_00), // bottom input
//             .l_in(l_in[`H_DIV]), // left input
//             .r_in(cell01_to_00), // right input
//             .ul_in(ul_in), // upper left
//             .ur_in(u_in[K_POW / 2 - 1]), // upper right
//             .bl_in(l_in[K_POW / 2 - 1]), // bottom left
//             .br_in(cell11_to_01[K_POW / 2 - 1]), // bottom right
//             .write_en(we00), // enable write in edit mode
//             .change_state(change_state), // the clock for the cell iteration
//             .rAddrR(rAddrR[K - 1: 0]), .rAddrC(rAddrC[K - 1: 0]),
//             .wAddrR(wAddrR[K - 1: 0]), .wAddrC(wAddrC[K - 1: 0]),
//             .write_data(write_data), // data to write to the cell when write_en
//             .clk(clk), .rst_c(rst_c),
//             .read_data(read_data00), // output the current cell state
//             .u_out(u_out[`H_DIV]), 
//             .b_out(cell00_to_10), 
//             .l_out(l_out[`H_DIV]), 
//             .r_out(cell00_to_01)
//         );

//     cellQuad #(.K(K - 1))
//         cell01(
//             .u_in(u_in[`L_DIV]), // uppper input
//             .b_in(cell11_to_01), // bottom input
//             .l_in(cell00_to_01), // left input
//             .r_in(r_in[L_DIV]), // right input
//             .ul_in(u_in[K_POW / 2]), // upper left
//             .ur_in(ur_in), // upper right
//             .bl_in(cell10_to_00[0]), // bottom left
//             .br_in(r_in[K_POW / 2 - 1]), // bottom right
//             .write_en(we01), // enable write in edit mode
//             .change_state(change_state), // the clock for the cell iteration
//             .rAddrR(rAddrR[K - 1: 0]), .rAddrC(rAddrC[K - 1: 0]),
//             .wAddrR(wAddrR[K - 1: 0]), .wAddrC(wAddrC[K - 1: 0]),
//             .write_data(write_data), // data to write to the cell when write_en
//             .clk(clk), .rst_c(rst_c),
//             .read_data(read_data01), // output the current cell state
//             .u_out(u_out[`L_DIV]), 
//             .b_out(cell01_to_11), 
//             .l_out(cell01_to_00), 
//             .r_out(r_out[`H_DIV])
//         );

//     cellQuad #(.K(K - 1))
//         cell10(
//             .u_in(cell00_to_10), // uppper input
//             .b_in(b_in[`H_DIV]), // bottom input
//             .l_in(l_in[`L_DIV]), // left input
//             .r_in(cell11_to_10), // right input
//             .ul_in(l_in[K_POW / 2]), // upper left
//             .ur_in(cell01_to_11[K_POW / 2 - 1]), // upper right
//             .bl_in(bl_in), // bottom left
//             .br_in(b_in[K_POW / 2 - 1]), // bottom right
//             .write_en(we10), // enable write in edit mode
//             .change_state(change_state), // the clock for the cell iteration
//             .rAddrR(rAddrR[K - 1: 0]), .rAddrC(rAddrC[K - 1: 0]),
//             .wAddrR(wAddrR[K - 1: 0]), .wAddrC(wAddrC[K - 1: 0]),
//             .write_data(write_data), // data to write to the cell when write_en
//             .clk(clk), .rst_c(rst_c),
//             .read_data(read_data10), // output the current cell state
//             .u_out(cell10_to_00), 
//             .b_out(b_out[`H_DIV]), 
//             .l_out(l_out[`L_DIV]), 
//             .r_out(cell10_to_11)
//         );

//     cellQuad #(.K(K - 1))
//         cell11(
//             .u_in(cell01_to_11), // uppper input
//             .b_in(b_in[`L_DIV]), // bottom input
//             .l_in(cell10_to_11), // left input
//             .r_in(r_in[`L_DIV]), // right input
//             .ul_in(cell00_to_10[0]), // upper left
//             .ur_in(r_in[K_POW / 2]), // upper right
//             .bl_in(b_in[K_POE / 2]), // bottom left
//             .br_in(bl_in), // bottom right
//             .write_en(we11), // enable write in edit mode
//             .change_state(change_state), // the clock for the cell iteration
//             .rAddrR(rAddrR[K - 1: 0]), .rAddrC(rAddrC[K - 1: 0]),
//             .wAddrR(wAddrR[K - 1: 0]), .wAddrC(wAddrC[K - 1: 0]),
//             .write_data(write_data), // data to write to the cell when write_en
//             .clk(clk), .rst_c(rst_c),
//             .read_data(read_data11), // output the current cell state
//             .u_out(cell11_to_01), 
//             .b_out(b_out[`L_DIV]), 
//             .l_out(cell11_to_10), 
//             .r_out(r_out[`L_DIV])
//         );

// endmodule

`include "defines.v"
// It works !! feel the tears in my heart
module envolve_logic (
    clk, clk_envo, rst,
    write_en,
    change_state,
    rAddrR, rAddrC,
    wAddrR, wAddrC,
    write_data,
    read_data,
    test_bit
);
    parameter MAP_WIDTH = 32; // 2 ^ 7
    parameter MAP_HEIGHT = 32; // 2 ^ 7

    input clk, clk_envo, rst;
    input write_en;
    input change_state;
    input `ADDR_WIDTH rAddrR, rAddrC;
    input `ADDR_WIDTH wAddrR, wAddrC;
    input write_data;
    output read_data;
	 output test_bit;

    reg map_index = 0;
    reg map_a [0: MAP_WIDTH - 1][0: MAP_HEIGHT - 1];
    reg map_b [0: MAP_WIDTH - 1][0: MAP_HEIGHT - 1];
    reg pre_evo_clk [0: MAP_WIDTH - 1][0: MAP_HEIGHT - 1];
    wire [3: 0] neighbor_counter_a [0: MAP_WIDTH - 1][0: MAP_HEIGHT - 1];// neighbor count won't excced 8
    wire [3: 0] neighbor_counter_b [0: MAP_WIDTH - 1][0: MAP_HEIGHT - 1]; 

    initial begin
		map_a[1][0] = 1;
		map_a[2][1] = 1;
		map_a[0][2] = 1;
		map_a[1][2] = 1;
		map_a[2][2] = 1;
	end

    always @ (posedge clk_envo) begin
        if (change_state) begin
            map_index <= ~map_index;
        end
    end
    genvar i, j;
    generate
        for (i = 0; i < MAP_WIDTH; i = i + 1) begin : column_loop // this is a block identifier
            for (j = 0; j < MAP_HEIGHT; j = j + 1) begin : row_loop
                assign neighbor_counter_a[i][j] = map_a[(i - 1 + MAP_WIDTH) % MAP_WIDTH][(j - 1 + MAP_HEIGHT) % MAP_HEIGHT] // upper left
                                                + map_a[i][(j - 1 + MAP_HEIGHT) % MAP_HEIGHT]                               // up
                                                + map_a[(i + 1) % MAP_WIDTH][(j - 1 + MAP_HEIGHT) % MAP_HEIGHT]             // upper right
                                                + map_a[(i - 1 + MAP_WIDTH) % MAP_WIDTH][j]                                 // left
                                                + map_a[(i + 1) % MAP_WIDTH][j]                                             // right
                                                + map_a[(i - 1 + MAP_WIDTH) % MAP_WIDTH][(j + 1) % MAP_HEIGHT]              // down left
                                                + map_a[i][(j + 1) % MAP_HEIGHT]                                            // down
                                                + map_a[(i + 1) % MAP_WIDTH][(j + 1) % MAP_HEIGHT];                         // down right
                    
                assign neighbor_counter_b[i][j] = map_b[(i - 1 + MAP_WIDTH) % MAP_WIDTH][(j - 1 + MAP_HEIGHT) % MAP_HEIGHT] // upper left
                                                + map_b[i][(j - 1 + MAP_HEIGHT) % MAP_HEIGHT]                               // up
                                                + map_b[(i + 1) % MAP_WIDTH][(j - 1 + MAP_HEIGHT) % MAP_HEIGHT]             // upper right
                                                + map_b[(i - 1 + MAP_WIDTH) % MAP_WIDTH][j]                                 // left
                                                + map_b[(i + 1) % MAP_WIDTH][j]                                             // right
                                                + map_b[(i - 1 + MAP_WIDTH) % MAP_WIDTH][(j + 1) % MAP_HEIGHT]              // down left
                                                + map_b[i][(j + 1) % MAP_HEIGHT]                                            // down
                                                + map_b[(i + 1) % MAP_WIDTH][(j + 1) % MAP_HEIGHT];                         // down right

                // always @ (posedge clk_envo) begin
                //    if (change_state) begin
                //         if (map_index == 0) begin
                //         // read from map a and wirte to map b
                //             //         else if (change_state) Next_State = (neighbor_num == 3'h3) || (Current_State & (neighbor_num == 2));
                //             //map_b[i][j] <= (neighbor_counter_a[i][j] == 4'd3) || (map_a[i][j] & (neighbor_counter_a == 4'd2));
                //             if (map_a[i][j]) begin
                //                 map_b[i][j] <= neighbor_counter_a[i][j] == 2 | neighbor_counter_a[i][j] == 3;
                //             end else begin
                //                 map_b[i][j] <= neighbor_counter_a[i][j] == 3;
                //             end
                //         end else begin
                //             //map_a[i][j] <= (neighbor_counter_b[i][j] == 4'd3) || (map_b[i][j] & (neighbor_counter_b == 4'd2));
                //             if (map_b[i][j]) begin
                //                 map_a[i][j] <= neighbor_counter_b[i][j] == 2 | neighbor_counter_b[i][j] == 3;
                //             end else begin
                //                 map_a[i][j] <= neighbor_counter_b[i][j] == 3;
                //             end
                //         end
                //     end else begin
                //         if (map_index == 0) begin
                //             map_a[i][j] <= ((write_en) & (wAddrC == i) & (wAddrR == j)) ? write_data : map_a[i][j];
                //         end else begin
                //             map_b[i][j] <= ((write_en) & (wAddrC == i) & (wAddrR == j)) ? write_data : map_b[i][j];
                //         end
                //     end
                // end
                always @ (posedge clk) begin
                    if (~ pre_evo_clk[i][j] & clk_envo) begin
                        if (map_index == 0) begin
                        // read from map a and wirte to map b
                            
                            //         else if (change_state) Next_State = (neighbor_num == 3'h3) || (Current_State & (neighbor_num == 2));
                            //map_b[i][j] <= (neighbor_counter_a[i][j] == 4'd3) || (map_a[i][j] & (neighbor_counter_a == 4'd2));
                            if (map_a[i][j]) begin
                                map_b[i][j] <= neighbor_counter_a[i][j] == 2 | neighbor_counter_a[i][j] == 3;
                            end else begin
                                map_b[i][j] <= neighbor_counter_a[i][j] == 3;
                            end
                        end else begin
                            //map_a[i][j] <= (neighbor_counter_b[i][j] == 4'd3) || (map_b[i][j] & (neighbor_counter_b == 4'd2));
                            if (map_b[i][j]) begin
                                map_a[i][j] <= neighbor_counter_b[i][j] == 2 | neighbor_counter_b[i][j] == 3;
                            end else begin
                                map_a[i][j] <= neighbor_counter_b[i][j] == 3;
                            end
                        end
                    end else begin
                        map_b[i][j] <= ((write_en) & (wAddrC == i) & (wAddrR == j)) ? write_data : map_b[i][j];
                        map_a[i][j] <= ((write_en) & (wAddrC == i) & (wAddrR == j)) ? write_data : map_a[i][j];
                    end
                    pre_evo_clk[i][j] = clk_envo;
                end
            end
        end
    endgenerate

    assign read_data = (map_index == 0) ? map_a[rAddrC][rAddrR] : map_b[rAddrC][rAddrR];
    assign test_bit = map_b[rAddrC][rAddrR];

endmodule