`timescale 1 ns / 100 ps  
module ALU_T_C3x3_F0_27bits_27bits(

		input [0:0] USE_SIMD,
		
		input [53:0] W,
		input [53:0] Y,
		input [53:0] X,

		input CIN,
		
		output [53:0] S,
		
		input [5:0] result_SIMD_carry_in,
		output [5:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_27x27	= 1'b00;
parameter mode_sum_9x9	= 1'b1;

reg [1:0] CIN_W_X_Y_CIN [2:0];

wire [1:0] COUT_W_X_Y_CIN [2:0];

always@(*)begin
	case (USE_SIMD)
		mode_27x27: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
		end
		mode_sum_9x9: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
		end
		2'b10, 2'b11: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
		end
	endcase
end

defparam ALU_SIMD_Width_inst0.Width = 18;
ALU_SIMD_Width	ALU_SIMD_Width_inst0(
	.W(W[17:0]),
	.Y(Y[17:0]),
	.X(X[17:0]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	
	.S(S[17:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:0])
);

defparam ALU_SIMD_Width_inst1.Width = 18;
ALU_SIMD_Width	ALU_SIMD_Width_inst1(
	.W(W[35:18]),
	.Y(Y[35:18]),
	.X(X[35:18]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[35:18]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:2])
);

defparam ALU_SIMD_Width_inst2.Width = 18;
ALU_SIMD_Width	ALU_SIMD_Width_inst2(
	.W(W[53:36]),
	.Y(Y[53:36]),
	.X(X[53:36]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	
	.S(S[53:36]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[5:4]),
	.result_SIMD_carry_out(result_SIMD_carry_out[5:4])
);


endmodule
