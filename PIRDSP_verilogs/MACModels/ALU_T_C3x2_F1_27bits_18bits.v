`timescale 1 ns / 100 ps  
module ALU_T_C3x2_F1_27bits_18bits(

		input [1:0] USE_SIMD,
		
		input [44:0] W,
		input [44:0] Y,
		input [44:0] X,

		input CIN,
		
		output [44:0] S,
		
		input [7:0] result_SIMD_carry_in,
		output [7:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_27x18	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;

reg [1:0] CIN_W_X_Y_CIN [3:0];

wire [1:0] COUT_W_X_Y_CIN [3:0];

always@(*)begin
	case (USE_SIMD)
		mode_27x18: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
		end
		mode_sum_9x9: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
		end
		mode_sum_4x4: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};
		end
		2'b11: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};
		end
	endcase
end
defparam ALU_SIMD_Width_inst0.Width = 17;
ALU_SIMD_Width	ALU_SIMD_Width_inst0(
	.W(W[16:0]),
	.Y(Y[16:0]),
	.X(X[16:0]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	
	.S(S[16:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:0])
);

defparam ALU_SIMD_Width_inst1.Width = 10;
ALU_SIMD_Width	ALU_SIMD_Width_inst1(
	.W(W[26:17]),
	.Y(Y[26:17]),
	.X(X[26:17]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[26:17]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:2])
);

defparam ALU_SIMD_Width_inst2.Width = 8;
ALU_SIMD_Width	ALU_SIMD_Width_inst2(
	.W(W[34:27]),
	.Y(Y[34:27]),
	.X(X[34:27]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	
	.S(S[34:27]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[5:4]),
	.result_SIMD_carry_out(result_SIMD_carry_out[5:4])
);

defparam ALU_SIMD_Width_inst3.Width = 10;
ALU_SIMD_Width	ALU_SIMD_Width_inst3(
	.W(W[44:35]),
	.Y(Y[44:35]),
	.X(X[44:35]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	
	.S(S[44:35]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[7:6]),
	.result_SIMD_carry_out(result_SIMD_carry_out[7:6])
);


endmodule
