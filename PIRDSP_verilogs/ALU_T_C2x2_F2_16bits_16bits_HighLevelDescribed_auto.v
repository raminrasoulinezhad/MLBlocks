/*****************************************************************
*	Configuration bits order : Nothing
*****************************************************************/
`timescale 1 ns / 100 ps  
module ALU_T_C2x2_F2_16bits_16bits_HighLevelDescribed_auto(
		input [3:0] ALUMODE,
		input [8:0] OPMODE,

		input [1:0] USE_SIMD,
		
		input [31:0] W,
		input [31:0] Z,
		input [31:0] Y,
		input [31:0] X,

		input CIN,
		
		output [31:0] S,
		
		input [7:0] result_SIMD_carry_in,
		output [7:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_16x16	= 2'b00;
parameter mode_sum_8x8	= 2'b1;
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

reg [1:0] CIN_W_X_Y_CIN [7:0];
reg [7:0] CIN_Z_W_X_Y_CIN;

wire [1:0] COUT_W_X_Y_CIN [7:0];
wire [7:0] COUT_Z_W_X_Y_CIN;

always@(*)begin
	case (USE_SIMD)
		mode_16x16: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = COUT_W_X_Y_CIN[3];
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = COUT_W_X_Y_CIN[5];
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = COUT_Z_W_X_Y_CIN[3];
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = COUT_Z_W_X_Y_CIN[5];
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
		end
		mode_sum_8x8: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = COUT_W_X_Y_CIN[5];
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = Z_controller;
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = COUT_Z_W_X_Y_CIN[5];
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
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

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = Z_controller;
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = Z_controller;
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = Z_controller;
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
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

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = Z_controller;
			CIN_Z_W_X_Y_CIN[2] = Z_controller;
			CIN_Z_W_X_Y_CIN[3] = Z_controller;
			CIN_Z_W_X_Y_CIN[4] = Z_controller;
			CIN_Z_W_X_Y_CIN[5] = Z_controller;
			CIN_Z_W_X_Y_CIN[6] = Z_controller;
			CIN_Z_W_X_Y_CIN[7] = Z_controller;
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

			CIN_Z_W_X_Y_CIN[0] = 1'bx;
			CIN_Z_W_X_Y_CIN[1] = 1'bx;
			CIN_Z_W_X_Y_CIN[2] = 1'bx;
			CIN_Z_W_X_Y_CIN[3] = 1'bx;
			CIN_Z_W_X_Y_CIN[4] = 1'bx;
			CIN_Z_W_X_Y_CIN[5] = 1'bx;
			CIN_Z_W_X_Y_CIN[6] = 1'bx;
			CIN_Z_W_X_Y_CIN[7] = 1'bx;
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
	
	.result_SIMD_carry_in(result_SIMD_carry_in[0:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[0:0])
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
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:1]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:1])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2(
	.W(W[11:8]),
	.Z(Z[11:8]),
	.Y(Y[11:8]),
	.X(X[11:8]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[2]),
	
	.S(S[11:8]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[2:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[2:2])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3(
	.W(W[15:12]),
	.Z(Z[15:12]),
	.Y(Y[15:12]),
	.X(X[15:12]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[3]),
	
	.S(S[15:12]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[3]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:3]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:3])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst4.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst4(
	.W(W[19:16]),
	.Z(Z[19:16]),
	.Y(Y[19:16]),
	.X(X[19:16]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[4]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[4]),
	
	.S(S[19:16]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[4]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[4]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[4:4]),
	.result_SIMD_carry_out(result_SIMD_carry_out[4:4])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst5.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst5(
	.W(W[23:20]),
	.Z(Z[23:20]),
	.Y(Y[23:20]),
	.X(X[23:20]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[5]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[5]),
	
	.S(S[23:20]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[5]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[5]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[5:5]),
	.result_SIMD_carry_out(result_SIMD_carry_out[5:5])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst6.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst6(
	.W(W[27:24]),
	.Z(Z[27:24]),
	.Y(Y[27:24]),
	.X(X[27:24]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[6]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[6]),
	
	.S(S[27:24]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[6]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[6]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[6:6]),
	.result_SIMD_carry_out(result_SIMD_carry_out[6:6])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst7.Width = 4;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst7(
	.W(W[31:28]),
	.Z(Z[31:28]),
	.Y(Y[31:28]),
	.X(X[31:28]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[7]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[7]),
	
	.S(S[31:28]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[7]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[7]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[7:7]),
	.result_SIMD_carry_out(result_SIMD_carry_out[7:7])
);


endmodule
