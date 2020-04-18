`timescale 1 ns / 100 ps  
module ALU_T_C3x2_F0_27bits_18bits(
		
		input [0:0] USE_SIMD,
		
		input [44:0] W,
		input [44:0] Y,
		input [44:0] X,

		input CIN,
		
		output [44:0] S,
		
		input [3:0] result_SIMD_carry_in,
		output [3:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_27x18	= 1'b00;
parameter mode_sum_9x9	= 1'b1;

reg [1:0] CIN_W_X_Y_CIN [1:0];

wire [1:0] COUT_W_X_Y_CIN [1:0];

always@(*)begin
	case (USE_SIMD)
		mode_27x18: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
		end
		mode_sum_9x9: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
		end
		2'b10, 2'b11: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
		end
	endcase
end

defparam ALU_SIMD_Width_inst0.Width = 27;
ALU_SIMD_Width	ALU_SIMD_Width_inst0(
	.W(W[26:0]),
	.Y(Y[26:0]),
	.X(X[26:0]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	
	.S(S[26:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:0])
);

defparam ALU_SIMD_Width_inst1.Width = 18;
ALU_SIMD_Width	ALU_SIMD_Width_inst1(
	.W(W[44:27]),
	.Y(Y[44:27]),
	.X(X[44:27]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[44:27]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:2])
);


endmodule
