/*****************************************************************
*	Configuration bits order :
*			USE_SIMD[0] <= configuration_input;
*			USE_SIMD[1] <= USE_SIMD[0];
*			configuration_output = USE_SIMD[1];
*****************************************************************/
`timescale 1 ns / 100 ps   
module ALU (
		input clk,
		
		input [3:0] ALUMODE,
		input [8:0] OPMODE,

		input [47:0] W,
		input [47:0] Z,
		input [47:0] Y,
		input [47:0] X,
		
		input CIN,
		
		output [47:0] S,
		
		output [3:0] CARRYOUT,

		input configuration_input,
		input configuration_enable,
		output configuration_output
	);	
	
	// configuring bits
	reg [1:0] USE_SIMD;
		
	always@(posedge clk)begin
		if (configuration_enable)begin
			USE_SIMD[0] <= configuration_input;
			USE_SIMD[1] <= USE_SIMD[0];
		end
	end
	assign configuration_output = USE_SIMD[1];
	
	
	// ALU
	parameter op_sum 	= 2'b00;
	parameter op_xor 	= 2'b01;
	parameter op_and 	= 2'b10;
	parameter op_or 		= 2'b11;
	
	parameter ONE48 = 2'b00;
	parameter TWO24 = 2'b01;
	parameter FOUR12 = 2'b10;
	
	reg Z_controller;
	always@(*)begin
		case (ALUMODE)
			4'b0011: Z_controller = 0;
			default: Z_controller = ALUMODE[0];
		endcase
	end
	
	
	reg S_controller;
	always@(*)begin
		case (ALUMODE)
			4'b0011: S_controller = 0;
			default: S_controller = ALUMODE[1];
		endcase
	end
	
	
	wire W_X_Y_controller;
	assign W_X_Y_controller = ALUMODE[1] && ALUMODE[0];
	
	
	reg [1:0] op;
	
	always@(*)begin
		case (ALUMODE[3:2])
			2'b00: op = op_sum;
			2'b01: op = op_xor;
			2'b11: begin 
				if (OPMODE[3])
					op = op_or;
				else 
					op = op_and;
			end
			default: op = 2'bxx;
		endcase
	end
	
	reg [3:0] CARRYIN_W_X_Y_CIN_3to2;
	reg [3:0] CARRYIN_W_X_Y_CIN_3to2_s_c_shifted;
	reg [3:0] CARRYIN_W_X_Y_CIN_2to1;
	reg [3:0] CARRYIN_Z_W_X_Y_CIN_2to1;
	
	wire [3:0] CARRYOUT_W_X_Y_CIN_3to2;
	wire [3:0] CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted;
	wire [3:0] CARRYOUT_W_X_Y_CIN_2to1;
	wire [3:0] CARRYOUT_W_Z_W_X_Y_CIN_2to1;
	
	assign CARRYOUT[0] = CARRYOUT_W_X_Y_CIN_3to2[0] || CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[0] || CARRYOUT_W_X_Y_CIN_2to1[0] || CARRYOUT_W_Z_W_X_Y_CIN_2to1[0];
	assign CARRYOUT[1] = CARRYOUT_W_X_Y_CIN_3to2[1] || CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[1] || CARRYOUT_W_X_Y_CIN_2to1[1] || CARRYOUT_W_Z_W_X_Y_CIN_2to1[1];
	assign CARRYOUT[2] = CARRYOUT_W_X_Y_CIN_3to2[2] || CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[2] || CARRYOUT_W_X_Y_CIN_2to1[2] || CARRYOUT_W_Z_W_X_Y_CIN_2to1[2];
	assign CARRYOUT[3] = CARRYOUT_W_X_Y_CIN_3to2[3] || CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[3] || CARRYOUT_W_X_Y_CIN_2to1[3] || CARRYOUT_W_Z_W_X_Y_CIN_2to1[3];
	
	always@(*)begin
		case (USE_SIMD)
			ONE48: begin
				CARRYIN_W_X_Y_CIN_3to2 = {CARRYOUT_W_X_Y_CIN_3to2[2:0], CIN};
				CARRYIN_W_X_Y_CIN_3to2_s_c_shifted = {CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[2:0], 1'b0};
				CARRYIN_W_X_Y_CIN_2to1 = {CARRYOUT_W_X_Y_CIN_2to1, 1'b0};
				CARRYIN_Z_W_X_Y_CIN_2to1 = {CARRYOUT_W_Z_W_X_Y_CIN_2to1, W_X_Y_controller};
			end	
			TWO24: begin
				CARRYIN_W_X_Y_CIN_3to2 = {CARRYOUT_W_X_Y_CIN_3to2[2], 1'b0, CARRYOUT_W_X_Y_CIN_3to2[0], 1'b0};
				CARRYIN_W_X_Y_CIN_3to2_s_c_shifted = {CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[2], 1'b0, CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[0], 1'b0};
				CARRYIN_W_X_Y_CIN_2to1 ={CARRYOUT_W_X_Y_CIN_2to1[2], 1'b0, CARRYOUT_W_X_Y_CIN_2to1[0], 1'b0};
				CARRYIN_Z_W_X_Y_CIN_2to1 = {CARRYOUT_W_Z_W_X_Y_CIN_2to1[2], W_X_Y_controller, CARRYOUT_W_Z_W_X_Y_CIN_2to1[0], W_X_Y_controller};
			end	
			FOUR12: begin
				CARRYIN_W_X_Y_CIN_3to2 = {4'b0};
				CARRYIN_W_X_Y_CIN_3to2_s_c_shifted = {4'b0};
				CARRYIN_W_X_Y_CIN_2to1 ={4'b0};
				CARRYIN_Z_W_X_Y_CIN_2to1 = {4{W_X_Y_controller}};
			end			
			default: begin // like ONE48
				CARRYIN_W_X_Y_CIN_3to2 = {CARRYOUT_W_X_Y_CIN_3to2[2:0], CIN};
				CARRYIN_W_X_Y_CIN_3to2_s_c_shifted = {CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[2:0], 1'b0};
				CARRYIN_W_X_Y_CIN_2to1 = {CARRYOUT_W_X_Y_CIN_2to1, 1'b0};
				CARRYIN_Z_W_X_Y_CIN_2to1 = {CARRYOUT_W_Z_W_X_Y_CIN_2to1, W_X_Y_controller};
			end
		endcase
	end
	
	ALU_SIMD ALU_SIMD_inst0 (
		.W(W[11:0]),
		.Z(Z[11:0]),
		.Y(Y[11:0]),
		.X(X[11:0]),
		
		.op(op),
		.Z_controller(Z_controller),
		.S_controller(S_controller),
		.W_X_Y_controller(W_X_Y_controller),
		
		.CARRYIN_W_X_Y_CIN_3to2(CARRYIN_W_X_Y_CIN_3to2[0]),
		.CARRYIN_W_X_Y_CIN_3to2_s_c_shifted(CARRYIN_W_X_Y_CIN_3to2_s_c_shifted[0]),
		.CARRYIN_W_X_Y_CIN_2to1(CARRYIN_W_X_Y_CIN_2to1[0]),
		.CARRYIN_Z_W_X_Y_CIN_2to1(CARRYIN_Z_W_X_Y_CIN_2to1[0]),
		
		.S(S[11:0]),
				
		.CARRYOUT_W_X_Y_CIN_3to2(CARRYOUT_W_X_Y_CIN_3to2[0]),
		.CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted(CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[0]),
		.CARRYOUT_W_X_Y_CIN_2to1(CARRYOUT_W_X_Y_CIN_2to1[0]),
		.CARRYOUT_W_Z_W_X_Y_CIN_2to1(CARRYOUT_W_Z_W_X_Y_CIN_2to1[0])
	);	
	
	ALU_SIMD ALU_SIMD_inst1 (
		.W(W[23:12]),
		.Z(Z[23:12]),
		.Y(Y[23:12]),
		.X(X[23:12]),
		
		.op(op),
		.Z_controller(Z_controller),
		.S_controller(S_controller),
		.W_X_Y_controller(W_X_Y_controller),
		
		.CARRYIN_W_X_Y_CIN_3to2(CARRYIN_W_X_Y_CIN_3to2[1]),
		.CARRYIN_W_X_Y_CIN_3to2_s_c_shifted(CARRYIN_W_X_Y_CIN_3to2_s_c_shifted[1]),
		.CARRYIN_W_X_Y_CIN_2to1(CARRYIN_W_X_Y_CIN_2to1[1]),
		.CARRYIN_Z_W_X_Y_CIN_2to1(CARRYIN_Z_W_X_Y_CIN_2to1[1]),
		
		.S(S[23:12]),
				
		.CARRYOUT_W_X_Y_CIN_3to2(CARRYOUT_W_X_Y_CIN_3to2[1]),
		.CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted(CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[1]),
		.CARRYOUT_W_X_Y_CIN_2to1(CARRYOUT_W_X_Y_CIN_2to1[1]),
		.CARRYOUT_W_Z_W_X_Y_CIN_2to1(CARRYOUT_W_Z_W_X_Y_CIN_2to1[1])
	);	
	
	ALU_SIMD ALU_SIMD_inst2 (
		.W(W[35:24]),
		.Z(Z[35:24]),
		.Y(Y[35:24]),
		.X(X[35:24]),
		
		.op(op),
		.Z_controller(Z_controller),
		.S_controller(S_controller),
		.W_X_Y_controller(W_X_Y_controller),
		
		.CARRYIN_W_X_Y_CIN_3to2(CARRYIN_W_X_Y_CIN_3to2[2]),
		.CARRYIN_W_X_Y_CIN_3to2_s_c_shifted(CARRYIN_W_X_Y_CIN_3to2_s_c_shifted[2]),
		.CARRYIN_W_X_Y_CIN_2to1(CARRYIN_W_X_Y_CIN_2to1[2]),
		.CARRYIN_Z_W_X_Y_CIN_2to1(CARRYIN_Z_W_X_Y_CIN_2to1[2]),
		
		.S(S[35:24]),
				
		.CARRYOUT_W_X_Y_CIN_3to2(CARRYOUT_W_X_Y_CIN_3to2[2]),
		.CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted(CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[2]),
		.CARRYOUT_W_X_Y_CIN_2to1(CARRYOUT_W_X_Y_CIN_2to1[2]),
		.CARRYOUT_W_Z_W_X_Y_CIN_2to1(CARRYOUT_W_Z_W_X_Y_CIN_2to1[2])
	);	
	
	ALU_SIMD ALU_SIMD_inst3 (
		.W(W[47:36]),
		.Z(Z[47:36]),
		.Y(Y[47:36]),
		.X(X[47:36]),
		
		.op(op),
		.Z_controller(Z_controller),
		.S_controller(S_controller),
		.W_X_Y_controller(W_X_Y_controller),
		
		.CARRYIN_W_X_Y_CIN_3to2(CARRYIN_W_X_Y_CIN_3to2[3]),
		.CARRYIN_W_X_Y_CIN_3to2_s_c_shifted(CARRYIN_W_X_Y_CIN_3to2_s_c_shifted[3]),
		.CARRYIN_W_X_Y_CIN_2to1(CARRYIN_W_X_Y_CIN_2to1[3]),
		.CARRYIN_Z_W_X_Y_CIN_2to1(CARRYIN_Z_W_X_Y_CIN_2to1[3]),
		
		.S(S[47:36]),
				
		.CARRYOUT_W_X_Y_CIN_3to2(CARRYOUT_W_X_Y_CIN_3to2[3]),
		.CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted(CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted[3]),
		.CARRYOUT_W_X_Y_CIN_2to1(CARRYOUT_W_X_Y_CIN_2to1[3]),
		.CARRYOUT_W_Z_W_X_Y_CIN_2to1(CARRYOUT_W_Z_W_X_Y_CIN_2to1[3])
	);	
	
endmodule
	
	