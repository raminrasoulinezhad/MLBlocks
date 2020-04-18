`timescale 1 ns / 100 ps  
module ALU_T_27bits_18bits_NoSIMD(

		input [47:0] W,
		input [47:0] Y,
		input [47:0] X,

		input CIN,
		
		output [47:0] S,
		output COUT
		
);
reg [1:0] CIN_W_X_Y_CIN;
wire [1:0] COUT_W_X_Y_CIN;

always@(*)begin
	CIN_W_X_Y_CIN = {{1'b0}, {CIN}};
end

defparam ALU_SIMD_Width_baseline_inst0.Width = 48;
ALU_SIMD_Width_baseline	ALU_SIMD_Width_baseline_inst0(
	.W(W[47:0]),
	.Y(Y[47:0]),
	.X(X[47:0]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN),
	
	.S(S[47:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN)
);

assign COUT = COUT_W_X_Y_CIN[0];

endmodule
