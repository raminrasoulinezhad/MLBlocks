`timescale 1 ns / 100 ps  
module ALU_T_C3x2_F2_27bits_18bits(

		input [1:0] USE_SIMD,
		
		input [44:0] W,
		input [44:0] Y,
		input [44:0] X,

		input CIN,
		
		output [44:0] S,
		
		input [15:0] result_SIMD_carry_in,
		output [15:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_27x18	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
parameter mode_sum_2x2	= 2'b11;


reg [1:0] CIN_W_X_Y_CIN [7:0];

wire [1:0] COUT_W_X_Y_CIN [7:0];

always@(*)begin
	case (USE_SIMD)
		mode_27x18: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = COUT_W_X_Y_CIN[3];
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = COUT_W_X_Y_CIN[5];
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];
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
		end
	endcase
end
defparam ALU_SIMD_Width_inst0.Width = 13;
ALU_SIMD_Width	ALU_SIMD_Width_inst0(
	.W(W[12:0]),
	.Y(Y[12:0]),
	.X(X[12:0]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	
	.S(S[12:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:0])
);

defparam ALU_SIMD_Width_inst1.Width = 4;
ALU_SIMD_Width	ALU_SIMD_Width_inst1(
	.W(W[16:13]),
	.Y(Y[16:13]),
	.X(X[16:13]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[16:13]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:2])
);

defparam ALU_SIMD_Width_inst2.Width = 6;
ALU_SIMD_Width	ALU_SIMD_Width_inst2(
	.W(W[22:17]),
	.Y(Y[22:17]),
	.X(X[22:17]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	
	.S(S[22:17]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[5:4]),
	.result_SIMD_carry_out(result_SIMD_carry_out[5:4])
);

defparam ALU_SIMD_Width_inst3.Width = 4;
ALU_SIMD_Width	ALU_SIMD_Width_inst3(
	.W(W[26:23]),
	.Y(Y[26:23]),
	.X(X[26:23]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	
	.S(S[26:23]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[7:6]),
	.result_SIMD_carry_out(result_SIMD_carry_out[7:6])
);

defparam ALU_SIMD_Width_inst4.Width = 4;
ALU_SIMD_Width	ALU_SIMD_Width_inst4(
	.W(W[30:27]),
	.Y(Y[30:27]),
	.X(X[30:27]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[4]),
	
	.S(S[30:27]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[4]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[9:8]),
	.result_SIMD_carry_out(result_SIMD_carry_out[9:8])
);

defparam ALU_SIMD_Width_inst5.Width = 4;
ALU_SIMD_Width	ALU_SIMD_Width_inst5(
	.W(W[34:31]),
	.Y(Y[34:31]),
	.X(X[34:31]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[5]),
	
	.S(S[34:31]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[5]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[11:10]),
	.result_SIMD_carry_out(result_SIMD_carry_out[11:10])
);

defparam ALU_SIMD_Width_inst6.Width = 6;
ALU_SIMD_Width	ALU_SIMD_Width_inst6(
	.W(W[40:35]),
	.Y(Y[40:35]),
	.X(X[40:35]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[6]),
	
	.S(S[40:35]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[6]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[13:12]),
	.result_SIMD_carry_out(result_SIMD_carry_out[13:12])
);

defparam ALU_SIMD_Width_inst7.Width = 4;
ALU_SIMD_Width	ALU_SIMD_Width_inst7(
	.W(W[44:41]),
	.Y(Y[44:41]),
	.X(X[44:41]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[7]),
	
	.S(S[44:41]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[7]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[15:14]),
	.result_SIMD_carry_out(result_SIMD_carry_out[15:14])
);


endmodule
