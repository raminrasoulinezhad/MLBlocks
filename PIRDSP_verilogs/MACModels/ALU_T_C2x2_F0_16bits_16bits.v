`timescale 1 ns / 100 ps  
module ALU_T_C2x2_F0_16bits_16bits(

		input [0:0] USE_SIMD,
		
		input [31:0] W,
		input [31:0] Y,
		input [31:0] X,

		input CIN,
		
		output [31:0] S,
		
		input [1:0] result_SIMD_carry_in,
		output [1:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_16x16	= 1'b00;
parameter mode_sum_8x8	= 1'b1;

reg [1:0] CIN_W_X_Y_CIN [1:0];

wire [1:0] COUT_W_X_Y_CIN [1:0];

always@(*)begin
	case (USE_SIMD)
		mode_16x16: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
		end
		mode_sum_8x8: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
		end
	endcase
end
defparam ALU_SIMD_Width_inst0.Width = 16;
ALU_SIMD_Width	ALU_SIMD_Width_inst0(
	.W(W[15:0]),
	.Y(Y[15:0]),
	.X(X[15:0]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	
	.S(S[15:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[0:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[0:0])
);

defparam ALU_SIMD_Width_inst1.Width = 16;
ALU_SIMD_Width	ALU_SIMD_Width_inst1(
	.W(W[31:16]),
	.Y(Y[31:16]),
	.X(X[31:16]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[31:16]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:1]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:1])
);


endmodule
