`timescale 1 ns / 100 ps  
module ALU_T_27bits_18bits(
		
		input [1:0] mode,
		
		input [47:0] W,
		input [47:0] Y,
		input [47:0] X,

		input CIN,
		
		output [47:0] S,
		output COUT
		
);
//Mode parameters
// functionality modes 
parameter mode_27x18	= 1'b00;
parameter mode_48			= 1'b01;
parameter mode_24			= 1'b10;
parameter mode_12			= 1'b11;

reg [1:0] CIN_W_X_Y_CIN [3:0];
wire [1:0] COUT_W_X_Y_CIN [3:0];

always@(*)begin
	case (mode)
		mode_27x18: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
		end
		mode_48: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
		end
		mode_24: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
		end
		mode_12: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};
		end
	endcase
end

defparam ALU_SIMD_Width_baseline_inst0.Width = 12;
ALU_SIMD_Width_baseline	ALU_SIMD_Width_baseline_inst0(
	.W(W[11:0]),
	.Y(Y[11:0]),
	.X(X[11:0]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	
	.S(S[11:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0])
);

defparam ALU_SIMD_Width_baseline_inst1.Width = 12;
ALU_SIMD_Width_baseline	ALU_SIMD_Width_baseline_inst1(
	.W(W[23:12]),
	.Y(Y[23:12]),
	.X(X[23:12]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	
	.S(S[23:12]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1])
);

defparam ALU_SIMD_Width_baseline_inst2.Width = 12;
ALU_SIMD_Width_baseline	ALU_SIMD_Width_baseline_inst2(
	.W(W[35:24]),
	.Y(Y[35:24]),
	.X(X[35:24]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	
	.S(S[35:24]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2])
);

defparam ALU_SIMD_Width_baseline_inst3.Width = 12;
ALU_SIMD_Width_baseline	ALU_SIMD_Width_baseline_inst3(
	.W(W[47:36]),
	.Y(Y[47:36]),
	.X(X[47:36]),
	
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	
	.S(S[47:36]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3])
);

assign COUT = COUT_W_X_Y_CIN[3][0];

endmodule
