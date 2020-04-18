/*****************************************************************
*	Configuration bits order : Nothing
*****************************************************************/
`timescale 1 ns / 100 ps  
module ALU_T_C3x3_F0_27bits_27bits_HighLevelDescribed_auto(
		input [3:0] ALUMODE,
		input [8:0] OPMODE,

		input [0:0] USE_SIMD,
		
		input [53:0] W,
		input [53:0] Z,
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

reg [1:0] CIN_W_X_Y_CIN [2:0];
reg [2:0] CIN_Z_W_X_Y_CIN;

wire [1:0] COUT_W_X_Y_CIN [2:0];
wire [2:0] COUT_Z_W_X_Y_CIN;

always@(*)begin
	case (USE_SIMD)
		mode_27x27: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
		end
		mode_sum_9x9: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};

			CIN_Z_W_X_Y_CIN[0] = Z_controller;
			CIN_Z_W_X_Y_CIN[1] = Z_controller;
			CIN_Z_W_X_Y_CIN[2] = Z_controller;
		end
		default: begin
			CIN_W_X_Y_CIN[0] = 2'bx;
			CIN_W_X_Y_CIN[1] = 2'bx;
			CIN_W_X_Y_CIN[2] = 2'bx;

			CIN_Z_W_X_Y_CIN[0] = 1'bx;
			CIN_Z_W_X_Y_CIN[1] = 1'bx;
			CIN_Z_W_X_Y_CIN[2] = 1'bx;
		end
	endcase
end
defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0.Width = 18;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0(
	.W(W[17:0]),
	.Z(Z[17:0]),
	.Y(Y[17:0]),
	.X(X[17:0]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[0]),
	
	.S(S[17:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[0]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[1:0]),
	.result_SIMD_carry_out(result_SIMD_carry_out[1:0])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1.Width = 18;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1(
	.W(W[35:18]),
	.Z(Z[35:18]),
	.Y(Y[35:18]),
	.X(X[35:18]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[1]),
	
	.S(S[35:18]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[1]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[3:2]),
	.result_SIMD_carry_out(result_SIMD_carry_out[3:2])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2.Width = 18;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2(
	.W(W[53:36]),
	.Z(Z[53:36]),
	.Y(Y[53:36]),
	.X(X[53:36]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[2]),
	
	.S(S[53:36]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[2]),
	
	.result_SIMD_carry_in(result_SIMD_carry_in[5:4]),
	.result_SIMD_carry_out(result_SIMD_carry_out[5:4])
);


endmodule
