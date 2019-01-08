`ifndef _GOL_HEADER_
`define _GOL_HEADER_

`define MODE_ENVOLVE 1
`define MODE_EDIT 0

// window and cursor control commands
`define WIN_CTRL_CMD [6: 0]
`define M_UP 0
`define M_DOWN 1
`define M_LEFT 2
`define M_RIGHT 3
`define Z_IN 4
`define Z_OUT 5
`define M_MODE 6

// envolve control related commands
`define ENVO_CTRL_CMD [7: 0]
`define CLR 0
`define INC_V 1
`define DEC_V 2
`define CUR_USER_DATA 3
`define CUR_USER_SET 4
`define RANDOM 5

`define ENVO_STATE [2: 0]
`define STATE_ENVOLVE 3'b000
`define STATE_EDIT 3'b001
`define STATE_RANDOM 3'b010
`define STATE_CLEAR 3'b011

`define KEYS [15: 0]
`define KEY_AR_U    0
`define KEY_AR_D    1
`define KEY_AR_L    2
`define KEY_AR_R    3
`define KEY_W       4
`define KEY_A       5
`define KEY_S       6
`define KEY_D       7
`define KEY_IN      8
`define KEY_OUT     9
`define KEY_SPACE  10
`define KEY_R      11
`define KEY_E      12
`define KEY_S_DOWN 13
`define KEY_S_UP   14
`define KEY_ENTER  15


`endif