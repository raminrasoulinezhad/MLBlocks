`timescale 1 ns / 100 ps  
module ALU_T_C2x2_F1_16bits_16bits(

		input [1:0] USE_SIMD,
		
		input [31:0] W,
		input [31:0] Y,
		input [31:0] X,

		input CIN,
		
		output [31:0] S,
		
		input [3:0] result_SIMD_carry_in,
		output [3:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_16x16	= 2'b00;
parameter mode_sum_8x8	= 2'b1;
parameter mode_sum_4x4	= 2'b10;

reg [1:0] CIN_W_X_Y_CIN [3:0];

wire [1:0] COUT_W_X_Y_CIN [3:0];

always@(*)begin
	case (USE_SIMD)
		mode_16x16: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
		end
		mode_sum_8x8: begin
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
defparam ALU_SIMD_Width_inst0.Width = 8;
ALU_SIMD_Width	ALU_SIMD_Width_inst0(
	.W(W[7:0]),
	.Y(Y[7:0]),
	.X(X[7:0]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	
	.S(S[7:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[0:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[0:0])
);

defparam ALU_SIMD_Width_inst1.Width = 8;
ALU_SIMD_Width	ALU_SIMD_Width_inst1(
	.W(W[15:8]),
	.Y(Y[15:8]),
	.X(X[15:8]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[15:8]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:1]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:1])
);

defparam ALU_SIMD_Width_inst2.Width = 8;
ALU_SIMD_Width	ALU_SIMD_Width_inst2(
	.W(W[23:16]),
	.Y(Y[23:16]),
	.X(X[23:16]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	
	.S(S[23:16]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[2:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[2:2])
);

defparam ALU_SIMD_Width_inst3.Width = 8;
ALU_SIMD_Width	ALU_SIMD_Width_inst3(
	.W(W[31:24]),
	.Y(Y[31:24]),
	.X(X[31:24]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	
	.S(S[31:24]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:3]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:3])
);


endmodule
