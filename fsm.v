//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/18/2024 10:08:32 AM
// Design Name:
// Module Name: pipeFSM design
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module pipeFSM (
    input wire 		 CLK,        // clock
    input wire [1:0] ONOFF,      // on/off
    input wire [7:0] LCN_0,      // starting location [4b_x, 4b_y]
    input wire [3:0] MTN_SENSOR, // maintenance sensor
    input wire [3:0] CMPS,       // compass
    input wire [3:0] WLL,        // wall locations
    
    output reg [1:0] TURN,
    output reg 		 DRIVING,
    output reg [7:0] LOCATION,
    output reg [2:0] ACTION
);

// state registers
reg [4:0] CS; // current State
reg [4:0] NS; // Next State

// internal register to save the compass
reg [3:0] facing_dir; // [N E S W]
reg       get_init_dir; // get the starting location signal

localparam OFF 	  	   = 5'b0_0000;
localparam IDLE        = 5'b0_0001;
localparam TURN_LEFT   = 5'b0_0010;
localparam TURN_RIGHT  = 5'b0_0011;
localparam COMP_PASS   = 5'b0_0100;
localparam COMP_LSHIFT = 5'b0_0101;
localparam COMP_RSHIFT = 5'b0_0110;
localparam MOVE  	   = 5'b0_0111;
localparam PLG0  	   = 5'b0_1000;
localparam PLG1  	   = 5'b0_1001;
localparam PLG2  	   = 5'b0_1010;
localparam PLG3  	   = 5'b0_1011;
localparam HOT0  	   = 5'b0_1100;
localparam HOT1  	   = 5'b0_1101;
localparam HOT2  	   = 5'b0_1110;
localparam FZN0  	   = 5'b0_1111;
localparam FZN1  	   = 5'b1_0000;
localparam FZN2  	   = 5'b1_0001;
localparam FZN3  	   = 5'b1_0010;
localparam FZN4  	   = 5'b1_0011;

// Regsitering state
always @(posedge CLK) begin
	CS <= NS;
end

// facing direction regsiter
always @(posedge CLK) begin
	if (CS == COMP_PASS) begin
		facing_dir <= CMPS;
	end
	else if (CS == COMP_LSHIFT) begin
		facing_dir <= {CMPS[2:0],CMPS[3]};
	end
	else if (CS == COMP_RSHIFT) begin
		facing_dir <= {CMPS[0],CMPS[3:1]};
	end
end

// current location register
always @(posedge CLK) begin
	if (CS == OFF) begin
		get_init_dir <= 1'b0;
	end
	else if (CS == IDLE && !get_init_dir) begin
		LOCATION <= LCN_0;
		get_init_dir <= 1'b1;
	end
	else if (CS == MOVE) begin
		// [N E S W]
		// robot is going North
		if (facing_dir == 4'b1000) begin
			LOCATION[3:0] <= LOCATION[3:0] + 1'b1;
		end
		// robot is going East
		else if (facing_dir == 4'b0100) begin
			LOCATION[7:4] <= LOCATION[7:4] + 1'b1;
		end 
		// robot is going South
		else if (facing_dir == 4'b0010) begin
			LOCATION[3:0] <= LOCATION[3:0] - 1'b1;
		end
		// robot is going West
		else if (facing_dir == 4'b0001) begin
			LOCATION[7:4] <= LOCATION[7:4] - 1'b1;
		end
	end
end

// States Logic
always @(*) begin
	case (CS)
		OFF: begin
			if (ONOFF == 2'b01) begin
				NS = IDLE;
			end
			else begin
				NS = OFF;
			end
		end
		IDLE: begin
			if (ONOFF == 2'b10) begin
				NS = OFF;
			end
			else if (WLL == 3'b011) begin
				NS = TURN_LEFT;
			end
			else if (WLL == 3'b101) begin
				NS = TURN_RIGHT;
			end
			else if (WLL == 3'b110) begin
				NS = COMP_PASS;
			end
			else if (WLL == 3'b000) begin
				NS = IDLE;
			end
			else begin
				NS = IDLE;
			end
		end
		TURN_LEFT: begin
			NS = COMP_LSHIFT;
		end
		TURN_RIGHT: begin
			NS = COMP_RSHIFT;
		end
		COMP_PASS: begin
			NS = MOVE;
		end
		COMP_LSHIFT: begin
			NS = MOVE;
		end
		COMP_RSHIFT: begin
			NS = MOVE;
		end
		MOVE: begin
			if (MTN_SENSOR == 4'b0001) begin
				NS = IDLE;
			end
			else if (MTN_SENSOR == 4'b1000) begin
				NS = FZN0;
			end
			else if (MTN_SENSOR == 4'b0010) begin
				NS = PLG0;
			end
			else if (MTN_SENSOR == 4'b0100) begin
				NS = HOT0;
			end
			else begin
				NS = IDLE;
			end
		end
		FZN0: begin
			NS = FZN1;
		end
		FZN1: begin
			NS = FZN2;
		end
		FZN2: begin
			NS = FZN3;
		end
		FZN3: begin
			NS = FZN4;
		end
		FZN4: begin
			NS = IDLE;
		end
		PLG0: begin
			NS = PLG1;
		end
		PLG1: begin
			NS = PLG2;
		end
		PLG2: begin
			NS = PLG3;
		end
		PLG3: begin
			NS = FZN4;
		end
		HOT0: begin
			NS  = HOT1;
		end
		HOT1: begin
			NS = HOT2;
		end
		HOT2: begin
			NS = IDLE;
		end
		default: NS = OFF;
	endcase
end

// State Output
always @(*) begin

    TURN      = 2'b00;
    DRIVING   = 1'b0;
    ACTION    = 3'b000;

	if (CS == OFF) begin
	    TURN      = 2'b00;
	    DRIVING   = 1'b0;
	    ACTION    = 3'b000;
	end
	else if (CS == IDLE) begin
	    DRIVING   = 1'b0;
	    ACTION    = 3'b000;
	end
	else if (CS ==  TURN_LEFT) begin
		TURN      = 2'b10;
	end
	else if (CS ==  TURN_RIGHT) begin
		TURN      = 2'b01;
	end
	else if (CS == MOVE) begin
		DRIVING   = 1'b1;
	end
	else if (CS == FZN0 || CS == FZN1 || CS == FZN3 || CS == FZN4) begin
	    ACTION    = 3'b100;
	end
	else if (CS == PLG0 || CS == PLG2) begin
		ACTION    = 3'b001;
	end
	else if (CS == HOT0 || CS == HOT1 || CS == HOT2) begin
		ACTION    = 3'b010;
	end
	else begin
	    TURN      = 2'b00;
	    DRIVING   = 1'b0;
	    ACTION    = 3'b000;
	end
end

endmodule