`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:06:30 01/06/2019 
// Design Name: 
// Module Name:    m8 
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
module envolve_ctrl (
    clk, rst,
    envo_ctrl_cmd,
    change_state,
    mode, // 1 for edit 0 for run
    wAddrR, wAddrC, // the target address
    write_en,
    write_data, // the data to be witten to the cell board
    cur_x,
    cur_y,
    random_en, clear_en, pattern_en
);
    parameter K = 6;
    parameter MAP_HEIGHT = 8;
    parameter MAP_WIDTH = 8;
    input wire clk, rst;
    input wire `ADDR_WIDTH cur_x, cur_y;
    input wire mode;
    input wire `ENVO_CTRL_CMD envo_ctrl_cmd;
    output wire change_state;
    output wire `ADDR_WIDTH wAddrC, wAddrR;
    output wire write_en;
    output wire write_data;

    ////////////////////////////////////////////////////////
    //                   mode triggers                    //
    ////////////////////////////////////////////////////////
    wire clear_start; 
    wire random_start;
    wire pattern_start;

    // outputs from envo_state_ctrl
    output wire random_en, clear_en, pattern_en; 

    ////////////////////////////////////////////////////////
    //                  unpack controls                   //
    ////////////////////////////////////////////////////////
    wire inc_v; 
    wire dec_v; 
    wire cur_user_data;
    wire cur_user_set;
    assign inc_v = envo_ctrl_cmd[`INC_V];
    assign dec_v = envo_ctrl_cmd[`DEC_V];

    assign clear_start = envo_ctrl_cmd[`CLR];
    assign random_start = envo_ctrl_cmd[`RANDOM];
    assign pattern_start = envo_ctrl_cmd[`PATTERN];
    assign cur_user_set = envo_ctrl_cmd[`CUR_USER_SET];

    assign cur_user_data = envo_ctrl_cmd[`CUR_USER_DATA];
    ///////////////////////////////////////////////////////
    wire random_out;
    wire `ADDR_WIDTH traversal_x;
    wire `ADDR_WIDTH traversal_y;
    
    ////////////
    // output //
    ////////////
    assign write_en = clear_en | random_en | pattern_en | cur_user_set;
    assign write_data = cur_user_set ? cur_user_data : 
         (clear_en ? 1'b0 : (random_en ? random_out : (pattern_en ? 1'b1 : 1'b0)));
    assign wAddrC = cur_user_set ? cur_x : traversal_x;
    assign wAddrR = cur_user_set ? cur_y : traversal_y;

    // testing //
    //assign write_data = cur_user_data;
    //assign wAddrC = cur_x;
    //assign wAddrR = cur_y;


    wire traverse_end;
    travers_board #(.MAP_WIDTH(MAP_WIDTH),.MAP_HEIGHT(MAP_HEIGHT)) trav_core (
        .clk(clk), .rst(rst),
        .enable(clear_en | random_en | pattern_en),
        .addrC(traversal_x),
        .addrR(traversal_y),
        .finish(traverse_end)
    );

    wire random_end;
    Fib_LFSR random_generator (
        .clk(clk), .rst(rst),
        .rand_en(random_en),// take in the signal
        .rand_out(random_out)
    );

    envolve_state_ctrl evo_s_ctrl (
        .clk(clk), .rst(rst),
        .mode(mode),
        .clear_start(clear_start),
        .clear_end(traverse_end),
        .random_start(random_start),
        .random_end(traverse_end),
        .pattern_start(pattern_start),
        .pattern_end(traverse_end),
        .clear_en(clear_en),
        .random_en(random_en),
        .pattern_en(pattern_en)
    );


    wire evo_controlled_speed;
    envolve_v_ctrl evo_ctrl(
        .clk(clk), .rst(rst),
        .mode(mode),
        .inc_v(inc_v),
        .dec_v(dec_v),
        .envolve_v(evo_controlled_speed)
    );
    assign change_state = evo_controlled_speed;

endmodule


// verified @ passed
module envolve_v_ctrl (
    clk,
    rst,
    mode,
    inc_v,
    dec_v,
    envolve_v,
	test_p1
);
    parameter U_BOUND = 20'b10000_0000_0000_0000;

    input wire clk, mode,rst;
    input wire inc_v, dec_v;
    output wire envolve_v;
		
		output [24: 0] test_p1;
		assign test_p1 = count;
		
    reg [24: 0] count;
    reg [20: 0] step;
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
	 reg has_prsd_i = 0;
	 reg has_prsd_d = 0;
	always @ (posedge clk or negedge rst) begin
	    if (~rst) begin
			   step <= 20'b1;
        end else begin
				if (inc_v & ~has_prsd_i) begin
				    step <= (step < U_BOUND) ? step << 1 : step;
					 has_prsd_i <= 1;
				end else if (~inc_v) begin
					 has_prsd_i <= 0;
				end
				if (dec_v & ~has_prsd_d) begin
				    step <= (step > 1'b1) ? {1'b0, step[20: 1]} : step;
					 has_prsd_d <= 1;
				end else if (~dec_v) begin
					 has_prsd_d <= 0;
				end
        end
	end
endmodule


module travers_board (
    clk, rst,
    enable,
    addrC,
    addrR,
    finish
);
    parameter MAP_HEIGHT = 8;
    parameter MAP_WIDTH = 8;
    input clk,rst;
    input enable;
    output reg [7: 0] addrC; // the max width won't excced 128
    output reg [7: 0] addrR;
    output finish;

    assign finish = (addrC == MAP_WIDTH - 1) & (addrR == MAP_HEIGHT - 1);

    always @ (posedge clk or negedge rst) begin
        if (~rst | finish) begin
            addrC <= 8'b0;
            addrR <= 8'b0;
        end else if (enable) begin
            if (addrC < MAP_WIDTH - 1) begin
                addrC <= addrC + 8'b1;
            end else if (addrC == MAP_WIDTH - 1) begin
                addrC <= 8'b0;
                addrR <= addrR + 8'b1;
            end
        end
    end

endmodule

// @v
// Linear Feedback Shift register for random pulse generation
module Fib_LFSR (
    clk, rst,
    rand_en,
    rand_out
);
    parameter SEED = 'd825;
    // the feedback polynomial
    // x^{16}+x^{14}+x^{13}+x^{11}+1
    // period = 65535
    input clk, rst;
    input rand_en;
	 output rand_out;
	 
    reg [16: 0] LFSR;
    wire feedbk;
	 
    assign feedbk = LFSR[15] ^ LFSR[13] ^ LFSR[12] ^ LFSR[10];
    assign rand_out = LFSR[0];
	 
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

module envolve_state_ctrl (
    clk, rst,
    mode, // envolve or edit
    random_start,
    random_end,
    clear_start,
    clear_end,
    pattern_start,
    pattern_end,
    random_en,// indicates the current state
    clear_en,
    pattern_en
);
    input clk, rst;
    input mode;
    input random_start;
    input random_end;
    input clear_start;
    input clear_end;
    input pattern_start;
    input pattern_end;
    output wire random_en;
    output wire clear_en;
    output wire pattern_en;

    // EDIT is the default mode
    reg `ENVO_STATE current_state = `STATE_EDIT;
    reg `ENVO_STATE next_state;

    // when in the corresponde mode stays high
    assign random_en  = current_state == `STATE_RANDOM;
    assign clear_en   = current_state == `STATE_CLEAR;
    assign pattern_en = current_state == `STATE_PATTERN;

    always @ (posedge clk or negedge rst) begin
        if (~rst) begin
            current_state <= `STATE_EDIT;
        end else begin
            current_state <= next_state;
        end
    end
    // sequential logic and blocking assignment for combinational logic
    always @ (*) begin
        case (current_state)
            `STATE_ENVOLVE : begin
                next_state = mode ? `STATE_ENVOLVE : `STATE_EDIT;
            end
            `STATE_EDIT : begin
                next_state = mode ? `STATE_ENVOLVE :
                    (clear_start ? `STATE_CLEAR : 
                    (random_start ? `STATE_RANDOM : 
                    (pattern_start ? `STATE_PATTERN : `STATE_EDIT))); 
            end
            `STATE_RANDOM : begin
                next_state = random_end ? `STATE_EDIT : `STATE_RANDOM;
            end
            `STATE_CLEAR : begin
                next_state = clear_end ? `STATE_EDIT : `STATE_CLEAR;
            end
            `STATE_PATTERN : begin
                next_state = pattern_end ? `STATE_EDIT : `STATE_PATTERN;
            end
          default: next_state = `STATE_EDIT;
        endcase
    end
endmodule
