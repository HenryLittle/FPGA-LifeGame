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
    wAddrR, wAddrC,
    write_en,
    write_data,
    cur_x,
    cur_y
);
    parameter K = 6;
    input wire clk, rst;
    input wire [K - 1: 0] cur_x, cur_y;
    input wire mode;
    input wire `ENVO_CTRL_CMD envo_ctrl_cmd;
    output wire change_state;
    output wire [K - 1: 0] wAddrC, wAddrR;
    output wire write_en;
    output wire write_data;

    ///////////////////////////////////////////////////////
    // unpack controls
    wire clear; 
    wire inc_v; 
    wire dec_v; 
    wire cur_user_data;
    wire cur_user_set;
    wire random;

    assign clear = envo_ctrl_cmd[`CLR];
    assign inc_v = envo_ctrl_cmd[`INC_V];
    assign dec_v = envo_ctrl_cmd[`DEC_V];
    assign cur_user_data = envo_ctrl_cmd[`CUR_USER_DATA];
    assign cur_user_set = envo_ctrl_cmd[`CUR_USER_SET];
    assign random = envo_ctrl_cmd[`RANDOM];
    ///////////////////////////////////////////////////////
    wire random_out;
    wire [K - 1: 0] traversal_x;
    wire [K - 1: 0] traversal_y;
    
    ////////////
    // output //
    ////////////
    assign write_en = clear | random | cur_user_set;
    // assign write_data = cur_user_set ? cur_user_data : 
    //     (clear ? 1'b0 : (random ? random_out : 1'b1));
    //assign wAddrC = cur_user_set ? cur_x : traversal_x;
    //assign wAddrR = cur_user_set ? cur_y : traversal_y;

    // testing
    assign write_data = cur_user_data;
    assign wAddrC = cur_x;
    assign wAddrR = cur_y;

    wire random_en, clear_en;

    wire traverse_end;
    travers_board #(.K(K)) trav_core (
        .clk(clk), .rst(rst),
        .en(clear | random),
        .addrC(traversal_x),
        .addrR(traversal_y),
        .finish(traverse_end)
    );

    wire random_e;
    Fib_LFSR random_generator (
        .clk(clk), .rst(rst),
        .rand_en(random_en),// take in the signal
        .rand_out(random_out)
    );

    envolve_state_ctrl evo_s_ctrl (
        .clk(clk), .rst(rst),
        .mode(mode),
        .clear_s(clear),
        .clear_e(traverse_end),
        .random_s(random),
        .random_e(random_en),
        .clear_en(clear_en),
        .random_en(random_en)
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
    parameter U_BOUND = 20'b1000_0000_0000_0000_0000;

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
	// always @ (posedge inc_v) begin
    //     if (rst) begin
    //         step <= (step < U_BOUND) ? step << 1 : step;
    //     end
	// end
    // always @ (posedge dec_v) begin
    //     if (rst) begin
    //         step <= (step > 1'b1) ? {1'b0, step[20: 1]} : step;
    //     end
    // end
endmodule


module travers_board (
    clk, rst,
    en,
    addrC,
    addrR,
    finish
);
    parameter K = 6;

    input clk,rst;
    input en;
    output wire [K - 1: 0] addrC;
    output wire [K - 1: 0] addrR;
    output finish;

    reg [2 * K - 1: 0] count;
    assign addrC = count[K - 1: 0];
    assign addrR = count[2 * K - 1: K];
    assign finish = (1'b1 == &count);

    always @ (posedge clk or negedge rst) begin
        if (~rst) begin
            count <= 'b0;
        end else begin
            count <= count + 1'b1;
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
    mode,
    random_en,
    random_s,
    random_e,
    clear_en,
    clear_s,
    clear_e
);
    input clk, rst;
    input mode;
    input random_s;
    input random_e;
    input clear_s;
    input clear_e;
    output wire random_en;
    output wire clear_en;

    // EDIT is the default mode
    reg `ENVO_STATE current_state, next_state;

    assign random_en = current_state == `STATE_RANDOM;
    assign clear_en = current_state == `STATE_CLEAR;

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
                    (clear_s ? `STATE_CLEAR : 
                    (random_s ? `STATE_RANDOM : `STATE_EDIT)); 
            end
            `STATE_RANDOM : begin
                next_state = random_e ? `STATE_EDIT : `STATE_RANDOM;
            end
            `STATE_CLEAR : begin
                next_state = clear_e ? `STATE_EDIT : `STATE_CLEAR;
            end
          default: next_state = `STATE_EDIT;
        endcase
    end
endmodule
