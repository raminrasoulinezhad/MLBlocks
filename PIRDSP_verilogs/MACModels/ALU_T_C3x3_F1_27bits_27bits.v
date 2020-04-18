`timescale 1 ns / 100 ps  
module ALU_T_C3x3_F1_27bits_27bits(

		input [1:0] USE_SIMD,
		
		input [53:0] W,
		input [53:0] Y,
		input [53:0] X,

		input CIN,
		
		output [53:0] S,
		
		input [11:0] result_SIMD_carry_in,
		output [11:0] result_SIMD_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_27x27	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;


reg [1:0] CIN_W_X_Y_CIN [5:0];

wire [1:0] COUT_W_X_Y_CIN [5:0];

always@(*)begin
	case (USE_SIMD)
		mode_27x27: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = COUT_W_X_Y_CIN[3];
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
		end
		mode_sum_9x9: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
		end
		mode_sum_4x4: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = {2'b0};
		end
		2'b11: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = {2'b0};
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
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:0])
);

defparam ALU_SIMD_Width_inst1.Width = 10;
ALU_SIMD_Width	ALU_SIMD_Width_inst1(
	.W(W[17:8]),
	.Y(Y[17:8]),
	.X(X[17:8]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[17:8]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:2])
);

defparam ALU_SIMD_Width_inst2.Width = 8;
ALU_SIMD_Width	ALU_SIMD_Width_inst2(
	.W(W[25:18]),
	.Y(Y[25:18]),
	.X(X[25:18]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	
	.S(S[25:18]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[5:4]),
	.result_SIMD_carry_out(result_SIMD_carry_out[5:4])
);

defparam ALU_SIMD_Width_inst3.Width = 10;
ALU_SIMD_Width	ALU_SIMD_Width_inst3(
	.W(W[35:26]),
	.Y(Y[35:26]),
	.X(X[35:26]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	
	.S(S[35:26]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[7:6]),
	.result_SIMD_carry_out(result_SIMD_carry_out[7:6])
);

defparam ALU_SIMD_Width_inst4.Width = 8;
ALU_SIMD_Width	ALU_SIMD_Width_inst4(
	.W(W[43:36]),
	.Y(Y[43:36]),
	.X(X[43:36]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[4]),
	
	.S(S[43:36]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[4]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[9:8]),
	.result_SIMD_carry_out(result_SIMD_carry_out[9:8])
);

defparam ALU_SIMD_Width_inst5.Width = 10;
ALU_SIMD_Width	ALU_SIMD_Width_inst5(
	.W(W[53:44]),
	.Y(Y[53:44]),
	.X(X[53:44]),

	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[5]),
	
	.S(S[53:44]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[5]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[11:10]),
	.result_SIMD_carry_out(result_SIMD_carry_out[11:10])
);


endmodule
