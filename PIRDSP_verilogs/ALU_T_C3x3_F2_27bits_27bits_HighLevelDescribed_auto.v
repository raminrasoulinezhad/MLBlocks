/*****************************************************************
*	Configuration bits order : Nothing
*****************************************************************/
`timescale 1 ns / 100 ps  
module ALU_T_C3x3_F2_27bits_27bits_HighLevelDescribed_auto(
		input [3:0] ALUMODE,
		input [8:0] OPMODE,

		input [1:0] USE_SIMD,
		
		input [53:0] W,
		input [53:0] Z,
		input [53:0] Y,
		input [53:0] X,

		input CIN,
		
		output [53:0] S,
		
		input [23:0] result_SIMD_carry_in,
		output [23:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_27x27	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
parameter mode_sum_2x2	= 2'b11;
// ALU
parameter op_sum 	= 2'b00;
parameter op_xor 	= 2'b01;
parameter op_and 	= 2'b10;
parameter op_or 	= 2'b11;

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

reg [1:0] CIN_W_X_Y_CIN [11:0];
reg [11:0] CIN_Z_W_X_Y_CIN;

wire [1:0] COUT_W_X_Y_CIN [11:0];
wire [11:0] COUT_Z_W_X_Y_CIN;

always@(*)begin
	case (USE_SIMD)
		mode_27x27: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = COUT_W_X_Y_CIN[3];
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = COUT_W_X_Y_CIN[5];
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];
			CIN_W_X_Y_CIN[8] = COUT_W_X_Y_CIN[7];
			CIN_W_X_Y_CIN[9] = COUT_W_X_Y_CIN[8];
			CIN_W_X_Y_CIN[10] = COUT_W_X_Y_CIN[9];
			CIN_W_X_Y_CIN[11] = COUT_W_X_Y_CIN[10];

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = COUT_Z_W_X_Y_CIN[3];
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = COUT_Z_W_X_Y_CIN[5];
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
			CIN_Z_W_X_Y_CIN[8] = COUT_Z_W_X_Y_CIN[7];
			CIN_Z_W_X_Y_CIN[9] = COUT_Z_W_X_Y_CIN[8];
			CIN_Z_W_X_Y_CIN[10] = COUT_Z_W_X_Y_CIN[9];
			CIN_Z_W_X_Y_CIN[11] = COUT_Z_W_X_Y_CIN[10];
		end
		mode_sum_9x9: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = COUT_W_X_Y_CIN[5];
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];
			CIN_W_X_Y_CIN[8] = {2'b0};
			CIN_W_X_Y_CIN[9] = COUT_W_X_Y_CIN[8];
			CIN_W_X_Y_CIN[10] = COUT_W_X_Y_CIN[9];
			CIN_W_X_Y_CIN[11] = COUT_W_X_Y_CIN[10];

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = Z_controller;
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = COUT_Z_W_X_Y_CIN[5];
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
			CIN_Z_W_X_Y_CIN[8] = Z_controller;
			CIN_Z_W_X_Y_CIN[9] = COUT_Z_W_X_Y_CIN[8];
			CIN_Z_W_X_Y_CIN[10] = COUT_Z_W_X_Y_CIN[9];
			CIN_Z_W_X_Y_CIN[11] = COUT_Z_W_X_Y_CIN[10];
		end
		mode_sum_4x4: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = {2'b0};
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];
			CIN_W_X_Y_CIN[8] = {2'b0};
			CIN_W_X_Y_CIN[9] = COUT_W_X_Y_CIN[8];
			CIN_W_X_Y_CIN[10] = {2'b0};
			CIN_W_X_Y_CIN[11] = COUT_W_X_Y_CIN[10];

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = Z_controller;
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = Z_controller;
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = Z_controller;
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
			CIN_Z_W_X_Y_CIN[8] = Z_controller;
			CIN_Z_W_X_Y_CIN[9] = COUT_Z_W_X_Y_CIN[8];
			CIN_Z_W_X_Y_CIN[10] = Z_controller;
			CIN_Z_W_X_Y_CIN[11] = COUT_Z_W_X_Y_CIN[10];
		end
		mode_sum_2x2: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = {2'b0};
			CIN_W_X_Y_CIN[6] = {2'b0};
			CIN_W_X_Y_CIN[7] = {2'b0};
			CIN_W_X_Y_CIN[8] = {2'b0};
			CIN_W_X_Y_CIN[9] = {2'b0};
			CIN_W_X_Y_CIN[10] = {2'b0};
			CIN_W_X_Y_CIN[11] = {2'b0};

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = Z_controller;
			CIN_Z_W_X_Y_CIN[2] = Z_controller;
			CIN_Z_W_X_Y_CIN[3] = Z_controller;
			CIN_Z_W_X_Y_CIN[4] = Z_controller;
			CIN_Z_W_X_Y_CIN[5] = Z_controller;
			CIN_Z_W_X_Y_CIN[6] = Z_controller;
			CIN_Z_W_X_Y_CIN[7] = Z_controller;
			CIN_Z_W_X_Y_CIN[8] = Z_controller;
			CIN_Z_W_X_Y_CIN[9] = Z_controller;
			CIN_Z_W_X_Y_CIN[10] = Z_controller;
			CIN_Z_W_X_Y_CIN[11] = Z_controller;
		end
		default: begin
			CIN_W_X_Y_CIN[0] = 2'bx;
			CIN_W_X_Y_CIN[1] = 2'bx;
			CIN_W_X_Y_CIN[2] = 2'bx;
			CIN_W_X_Y_CIN[3] = 2'bx;
			CIN_W_X_Y_CIN[4] = 2'bx;
			CIN_W_X_Y_CIN[5] = 2'bx;
			CIN_W_X_Y_CIN[6] = 2'bx;
			CIN_W_X_Y_CIN[7] = 2'bx;
			CIN_W_X_Y_CIN[8] = 2'bx;
			CIN_W_X_Y_CIN[9] = 2'bx;
			CIN_W_X_Y_CIN[10] = 2'bx;
			CIN_W_X_Y_CIN[11] = 2'bx;

			CIN_Z_W_X_Y_CIN[0] = 1'bx;
			CIN_Z_W_X_Y_CIN[1] = 1'bx;
			CIN_Z_W_X_Y_CIN[2] = 1'bx;
			CIN_Z_W_X_Y_CIN[3] = 1'bx;
			CIN_Z_W_X_Y_CIN[4] = 1'bx;
			CIN_Z_W_X_Y_CIN[5] = 1'bx;
			CIN_Z_W_X_Y_CIN[6] = 1'bx;
			CIN_Z_W_X_Y_CIN[7] = 1'bx;
			CIN_Z_W_X_Y_CIN[8] = 1'bx;
			CIN_Z_W_X_Y_CIN[9] = 1'bx;
			CIN_Z_W_X_Y_CIN[10] = 1'bx;
			CIN_Z_W_X_Y_CIN[11] = 1'bx;
		end
	endcase
end
defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0(
	.W(W[3:0]),
	.Z(Z[3:0]),
	.Y(Y[3:0]),
	.X(X[3:0]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[0]),
	
	.S(S[3:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:0])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1(
	.W(W[7:4]),
	.Z(Z[7:4]),
	.Y(Y[7:4]),
	.X(X[7:4]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[1]),
	
	.S(S[7:4]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:2])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2.Width = 6;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2(
	.W(W[13:8]),
	.Z(Z[13:8]),
	.Y(Y[13:8]),
	.X(X[13:8]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[2]),
	
	.S(S[13:8]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[5:4]),
	.result_SIMD_carry_out(result_SIMD_carry_out[5:4])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3(
	.W(W[17:14]),
	.Z(Z[17:14]),
	.Y(Y[17:14]),
	.X(X[17:14]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[3]),
	
	.S(S[17:14]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[3]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[7:6]),
	.result_SIMD_carry_out(result_SIMD_carry_out[7:6])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst4.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst4(
	.W(W[21:18]),
	.Z(Z[21:18]),
	.Y(Y[21:18]),
	.X(X[21:18]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[4]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[4]),
	
	.S(S[21:18]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[4]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[4]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[9:8]),
	.result_SIMD_carry_out(result_SIMD_carry_out[9:8])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst5.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst5(
	.W(W[25:22]),
	.Z(Z[25:22]),
	.Y(Y[25:22]),
	.X(X[25:22]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[5]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[5]),
	
	.S(S[25:22]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[5]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[5]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[11:10]),
	.result_SIMD_carry_out(result_SIMD_carry_out[11:10])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst6.Width = 6;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst6(
	.W(W[31:26]),
	.Z(Z[31:26]),
	.Y(Y[31:26]),
	.X(X[31:26]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[6]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[6]),
	
	.S(S[31:26]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[6]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[6]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[13:12]),
	.result_SIMD_carry_out(result_SIMD_carry_out[13:12])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst7.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst7(
	.W(W[35:32]),
	.Z(Z[35:32]),
	.Y(Y[35:32]),
	.X(X[35:32]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[7]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[7]),
	
	.S(S[35:32]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[7]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[7]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[15:14]),
	.result_SIMD_carry_out(result_SIMD_carry_out[15:14])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst8.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst8(
	.W(W[39:36]),
	.Z(Z[39:36]),
	.Y(Y[39:36]),
	.X(X[39:36]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[8]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[8]),
	
	.S(S[39:36]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[8]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[8]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[17:16]),
	.result_SIMD_carry_out(result_SIMD_carry_out[17:16])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst9.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst9(
	.W(W[43:40]),
	.Z(Z[43:40]),
	.Y(Y[43:40]),
	.X(X[43:40]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[9]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[9]),
	
	.S(S[43:40]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[9]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[9]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[19:18]),
	.result_SIMD_carry_out(result_SIMD_carry_out[19:18])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst10.Width = 6;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst10(
	.W(W[49:44]),
	.Z(Z[49:44]),
	.Y(Y[49:44]),
	.X(X[49:44]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[10]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[10]),
	
	.S(S[49:44]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[10]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[10]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[21:20]),
	.result_SIMD_carry_out(result_SIMD_carry_out[21:20])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst11.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst11(
	.W(W[53:50]),
	.Z(Z[53:50]),
	.Y(Y[53:50]),
	.X(X[53:50]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[11]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[11]),
	
	.S(S[53:50]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[11]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[11]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[23:22]),
	.result_SIMD_carry_out(result_SIMD_carry_out[23:22])
);


endmodule
