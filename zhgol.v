`timescale 1ns / 1ps

module life_game(
	input clock,
	input enable,
	input circlize,
	input pointer_ready,
	input [8:0] pointer_delta_x,
	input [8:0] pointer_delta_y,
	input pointer_select,
	input [9:0] x_position,
	input [8:0] y_position,
	input inside_video,
	output reg [7:0] color
	);

	parameter BLOCK_SIZE = 20;
	parameter BLOCK_COUNT_X = 640 / BLOCK_SIZE;
	parameter BLOCK_COUNT_Y = 480 / BLOCK_SIZE;

	parameter COLOR_POINTER = 8'b110_110_10;
	parameter COLOR_EMPTY = 8'b111_111_11;
	parameter COLOR_BLACK = 8'b000_000_00;

	reg [9:0] pointer_x = 320;
	reg [8:0] pointer_y = 240;
	wire [4:0] pointer_x_index;
	wire [4:0] pointer_y_index;
	wire pointer_select_on [0:BLOCK_COUNT_X - 1] [0:BLOCK_COUNT_Y - 1];
	reg map_0 [0:BLOCK_COUNT_X - 1] [0:BLOCK_COUNT_Y - 1];
	reg map_1 [0:BLOCK_COUNT_X - 1] [0:BLOCK_COUNT_Y - 1];
	reg map_index = 0;
	wire [3:0] neighbor_count_0 [0:BLOCK_COUNT_X - 1] [0:BLOCK_COUNT_Y - 1];
	wire [3:0] neighbor_count_1 [0:BLOCK_COUNT_X - 1] [0:BLOCK_COUNT_Y - 1];
	wire [4:0] x_index;
	wire [4:0] y_index;
	wire block_current;
	wire [7:0] color_life;
	wire [7:0] color_empty;
	wire [7:0] color_block;
	wire [7:0] color_block_circlized;

	initial begin
		map_0[1][0] = 1;
		map_0[2][1] = 1;
		map_0[0][2] = 1;
		map_0[1][2] = 1;
		map_0[2][2] = 1;
	end

	// FIXME: Should use system clock here.
	always @(posedge clock) begin
		if (pointer_ready) begin
			if (pointer_delta_x[8]) begin
				pointer_x <= pointer_x - pointer_delta_x[7:0];
			end else begin
				pointer_x <= pointer_x + pointer_delta_x[7:0];
			end
			if (pointer_delta_y[8]) begin
				pointer_y <= pointer_y - pointer_delta_y[7:0];
			end else begin
				pointer_y <= pointer_y + pointer_delta_y[7:0];
			end
		end
	end

	assign pointer_x_index = pointer_x / BLOCK_SIZE;
	assign pointer_y_index = pointer_y / BLOCK_SIZE;

	always @(posedge clock) begin
		if (enable) begin
			map_index <= ~map_index;
		end
	end

genvar i, j;
generate
	for (i = 0; i < BLOCK_COUNT_X; i = i + 1) begin
		for (j = 0; j < BLOCK_COUNT_Y; j = j + 1) begin

	assign pointer_select_on[i][j] = i == pointer_x_index && j == pointer_y_index && pointer_select;
	assign neighbor_count_0[i][j] = map_0[(i - 1 + BLOCK_COUNT_X) % BLOCK_COUNT_X][(j - 1 + BLOCK_COUNT_Y) % BLOCK_COUNT_Y] 
								  + map_0[i][(j - 1 + BLOCK_COUNT_Y) % BLOCK_COUNT_Y] 
								  + map_0[(i + 1) % BLOCK_COUNT_X][(j - 1 + BLOCK_COUNT_Y) % BLOCK_COUNT_Y]
			 					  + map_0[(i - 1 + BLOCK_COUNT_X) % BLOCK_COUNT_X][j] 
								  + map_0[(i + 1) % BLOCK_COUNT_X][j]
			   					  + map_0[(i - 1 + BLOCK_COUNT_X) % BLOCK_COUNT_X][(j + 1) % BLOCK_COUNT_Y] 
								  + map_0[i][(j + 1) % BLOCK_COUNT_Y]
								  + map_0[(i + 1) % BLOCK_COUNT_X][(j + 1) % BLOCK_COUNT_Y];

	assign neighbor_count_1[i][j] = map_1[(i - 1 + BLOCK_COUNT_X) % BLOCK_COUNT_X][(j - 1 + BLOCK_COUNT_Y) % BLOCK_COUNT_Y]
	        					  + map_1[i][(j - 1 + BLOCK_COUNT_Y) % BLOCK_COUNT_Y] 
								  + map_1[(i + 1) % BLOCK_COUNT_X][(j - 1 + BLOCK_COUNT_Y) % BLOCK_COUNT_Y]
								  + map_1[(i - 1 + BLOCK_COUNT_X) % BLOCK_COUNT_X][j] 
								  + map_1[(i + 1) % BLOCK_COUNT_X][j]
								  + map_1[(i - 1 + BLOCK_COUNT_X) % BLOCK_COUNT_X][(j + 1) % BLOCK_COUNT_Y] 
								  + map_1[i][(j + 1) % BLOCK_COUNT_Y] 
								  + map_1[(i + 1) % BLOCK_COUNT_X][(j + 1) % BLOCK_COUNT_Y];

	always @(posedge clock) begin
		if (map_index == 0) begin
			map_0[i][j] <= pointer_select_on[i][j] ^ map_0[i][j];
			if (map_0[i][j]) begin
				map_1[i][j] <= neighbor_count_0[i][j] == 2 | neighbor_count_0[i][j] == 3;
			end else begin
				map_1[i][j] <= neighbor_count_0[i][j] == 3;
			end
		end else begin
			map_1[i][j] <= pointer_select_on[i][j] ^ map_1[i][j];
			if (map_1[i][j]) begin
				map_0[i][j] <= neighbor_count_1[i][j] == 2 | neighbor_count_1[i][j] == 3;
			end else begin
				map_0[i][j] <= neighbor_count_1[i][j] == 3;
			end
		end
//		map_0[i][j] <= 1;
//		map_1[i][j] <= 1;
	end

		end
	end
endgenerate

	assign x_index = x_position / BLOCK_SIZE;
	assign y_index = y_position / BLOCK_SIZE;
	assign block_current = map_index == 0 ? map_0[x_index][y_index] : map_1[x_index][y_index];
	//color_generator color_generator(x_index, y_index, color_life);
	assign color_empty = x_index == pointer_x_index && y_index == pointer_y_index ? COLOR_POINTER : COLOR_EMPTY;
	assign color_block = block_current ? color_life : color_empty;
	//color_circlizer #(BLOCK_SIZE) color_circlizer (x_position - x_index * BLOCK_SIZE, y_position - y_index * BLOCK_SIZE, color_block, color_empty, color_block_circlized);

	always @(*) begin
		if (inside_video) begin
			if (x_position <= BLOCK_SIZE * BLOCK_COUNT_X) begin
				color = circlize ? color_block : color_block_circlized;
			end else begin
				color = COLOR_BLACK;
			end
		end else begin
			color = 0;
		end
	end

endmodule
