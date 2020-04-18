/*****************************************************************
*	Configuration bits order : Nothing
*****************************************************************/
`timescale 1 ns / 100 ps  
module ALU_T_C3x2_F2_54bits_36bits_HighLevelDescribed_auto(
		input clk,

		input [3:0] ALUMODE,
		input [8:0] OPMODE,

		input [1:0] USE_SIMD
		
		input [89:0] W,
		input [89:0] Z,
		input [89:0] Y,
		input [89:0] X,

		input CIN,
		
		output [89:0] S,
		
		input [15:0] result_SIDM_carry_in,
		output [15:0] result_SIDM_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_54x36	= 2'b00;
parameter mode_sum_18x18	= 2'b1;
parameter mode_sum_9x9	= 2'b10;
parameter mode_sum_4x4	= 2'b11;
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

reg [1:0] CIN_W_X_Y_CIN [7:0];
reg [1:0] CIN_Z_W_X_Y_CIN [7:0];

wire [1:0] COUT_W_X_Y_CIN [7:0];
wire [1:0] COUT_Z_W_X_Y_CIN [7:0];

always@(*)begin
	case (USE_SIMD)
		mode_54x36: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = COUT_W_X_Y_CIN[3];
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = COUT_W_X_Y_CIN[5];
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = COUT_Z_W_X_Y_CIN[3];
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = COUT_Z_W_X_Y_CIN[5];
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
		end
		mode_sum_18x18: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = COUT_W_X_Y_CIN[1];
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = COUT_W_X_Y_CIN[5];
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = COUT_Z_W_X_Y_CIN[1];
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = COUT_Z_W_X_Y_CIN[5];
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
		end
		mode_sum_9x9: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = COUT_W_X_Y_CIN[0];
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = COUT_W_X_Y_CIN[2];
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = COUT_W_X_Y_CIN[4];
			CIN_W_X_Y_CIN[6] = {2'b0};
			CIN_W_X_Y_CIN[7] = COUT_W_X_Y_CIN[6];

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[1] = COUT_Z_W_X_Y_CIN[0];
			CIN_Z_W_X_Y_CIN[2] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[3] = COUT_Z_W_X_Y_CIN[2];
			CIN_Z_W_X_Y_CIN[4] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[5] = COUT_Z_W_X_Y_CIN[4];
			CIN_Z_W_X_Y_CIN[6] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[7] = COUT_Z_W_X_Y_CIN[6];
		end
		mode_sum_4x4: begin
			CIN_W_X_Y_CIN[0] = {2'b0};
			CIN_W_X_Y_CIN[1] = {2'b0};
			CIN_W_X_Y_CIN[2] = {2'b0};
			CIN_W_X_Y_CIN[3] = {2'b0};
			CIN_W_X_Y_CIN[4] = {2'b0};
			CIN_W_X_Y_CIN[5] = {2'b0};
			CIN_W_X_Y_CIN[6] = {2'b0};
			CIN_W_X_Y_CIN[7] = {2'b0};

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[1] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[2] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[3] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[4] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[5] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[6] = {{1'b0}, {W_X_Y_controller}};
			CIN_Z_W_X_Y_CIN[7] = {{1'b0}, {W_X_Y_controller}};
		end
	endcase
end
defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0.Width = 26;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0(
	.W(W[25:0]),
	.Z(Z[25:0]),
	.Y(Y[25:0]),
	.X(X[25:0]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[0]),
	
	.S(S[25:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[0]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[1:0]),
	.result_SIDM_carry_out(result_SIDM_carry_out[1:0])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1.Width = 10;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst1(
	.W(W[35:26]),
	.Z(Z[35:26]),
	.Y(Y[35:26]),
	.X(X[35:26]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[1]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[1]),
	
	.S(S[35:26]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[1]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[1]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[3:2]),
	.result_SIDM_carry_out(result_SIDM_carry_out[3:2])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2.Width = 8;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst2(
	.W(W[43:36]),
	.Z(Z[43:36]),
	.Y(Y[43:36]),
	.X(X[43:36]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[2]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[2]),
	
	.S(S[43:36]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[2]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[2]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[5:4]),
	.result_SIDM_carry_out(result_SIDM_carry_out[5:4])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3.Width = 10;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst3(
	.W(W[53:44]),
	.Z(Z[53:44]),
	.Y(Y[53:44]),
	.X(X[53:44]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[3]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[3]),
	
	.S(S[53:44]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[3]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[3]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[7:6]),
	.result_SIDM_carry_out(result_SIDM_carry_out[7:6])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst4.Width = 8;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst4(
	.W(W[61:54]),
	.Z(Z[61:54]),
	.Y(Y[61:54]),
	.X(X[61:54]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[4]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[4]),
	
	.S(S[61:54]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[4]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[4]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[9:8]),
	.result_SIDM_carry_out(result_SIDM_carry_out[9:8])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst5.Width = 10;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst5(
	.W(W[71:62]),
	.Z(Z[71:62]),
	.Y(Y[71:62]),
	.X(X[71:62]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[5]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[5]),
	
	.S(S[71:62]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[5]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[5]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[11:10]),
	.result_SIDM_carry_out(result_SIDM_carry_out[11:10])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst6.Width = 8;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst6(
	.W(W[79:72]),
	.Z(Z[79:72]),
	.Y(Y[79:72]),
	.X(X[79:72]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[6]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[6]),
	
	.S(S[79:72]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[6]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[6]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[13:12]),
	.result_SIDM_carry_out(result_SIDM_carry_out[13:12])
);

defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst7.Width = 10;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst7(
	.W(W[89:80]),
	.Z(Z[89:80]),
	.Y(Y[89:80]),
	.X(X[89:80]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[7]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[7]),
	
	.S(S[89:80]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[7]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[7]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[15:14]),
	.result_SIDM_carry_out(result_SIDM_carry_out[15:14])
);


endmodule
