/*****************************************************************
*	Configuration bits order : Nothing
*****************************************************************/
`timescale 1 ns / 100 ps  
module ALU_T_C3x2_F1_18bits_12bits_HighLevelDescribed_auto(
		input clk,

		input [3:0] ALUMODE,
		input [8:0] OPMODE,

		input [1:0] USE_SIMD
		
		input [29:0] W,
		input [29:0] Z,
		input [29:0] Y,
		input [29:0] X,

		input CIN,
		
		output [29:0] S,
		
		input [7:0] result_SIDM_carry_in,
		output [7:0] result_SIDM_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_18x12	= 2'b00;
parameter mode_sum_6x6	= 2'b1;
parameter mode_sum_3x3	= 2'b10;
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

reg [1:0] CIN_W_X_Y_CIN [3:0];
reg [1:0] CIN_Z_W_X_Y_CIN [3:0];

wire [1:0] COUT_W_X_Y_CIN [3:0];
wire [1:0] COUT_Z_W_X_Y_CIN [3:0];

always@(*)begin
	case (USE_SIMD)
		mode_18x12: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
		end
		mode_sum_6x6: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
		end
		mode_sum_3x3: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[1] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[2] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[3] = {{1'b0}, {W_X_Y_controller}};
		end
	endcase
end
defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0.Width = 12;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0(
	.W(W[11:0]),
	.Z(Z[11:0]),
	.Y(Y[11:0]),
	.X(X[11:0]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[0]),
	
	.S(S[11:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[0]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[1:0]),
	.result_SIDM_carry_out(result_SIDM_carry_out[1:0])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1.Width = 6;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1(
	.W(W[17:12]),
	.Z(Z[17:12]),
	.Y(Y[17:12]),
	.X(X[17:12]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[1]),
	
	.S(S[17:12]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[1]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[3:2]),
	.result_SIDM_carry_out(result_SIDM_carry_out[3:2])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2.Width = 6;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2(
	.W(W[23:18]),
	.Z(Z[23:18]),
	.Y(Y[23:18]),
	.X(X[23:18]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[2]),
	
	.S(S[23:18]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[2]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[5:4]),
	.result_SIDM_carry_out(result_SIDM_carry_out[5:4])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3.Width = 6;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3(
	.W(W[29:24]),
	.Z(Z[29:24]),
	.Y(Y[29:24]),
	.X(X[29:24]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[3]),
	
	.S(S[29:24]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[3]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[7:6]),
	.result_SIDM_carry_out(result_SIDM_carry_out[7:6])
);


endmodule
