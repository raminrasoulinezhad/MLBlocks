/*****************************************************************
*	Configuration bits order : Nothing
*****************************************************************/
`timescale 1 ns / 100 ps  
module ALU_T_C1x1_F0_16bits_16bits_HighLevelDescribed_auto(
		input clk,

		input [3:0] ALUMODE,
		input [8:0] OPMODE,

		input [0:0] USE_SIMD
		
		input [31:0] W,
		input [31:0] Z,
		input [31:0] Y,
		input [31:0] X,

		input CIN,
		
		output [31:0] S,
		
		input [0:0] result_SIDM_carry_in,
		output [0:0] result_SIDM_carry_out
);
//Mode parameters
// functionality modes 
parameter mode_16x16	= 1'b00;
parameter mode_sum_16x16	= 1'b1;
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

reg [1:0] CIN_W_X_Y_CIN [0:0];
reg [1:0] CIN_Z_W_X_Y_CIN [0:0];

wire [1:0] COUT_W_X_Y_CIN [0:0];
wire [1:0] COUT_Z_W_X_Y_CIN [0:0];

always@(*)begin
	case (USE_SIMD)
		mode_16x16: begin
			CIN_W_X_Y_CIN[0] = {{1'b0}, {CIN}};

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {CIN}};
		end
		mode_sum_16x16: begin
			CIN_W_X_Y_CIN[0] = {2'b0};

			CIN_Z_W_X_Y_CIN[0] = {{1'b0}, {W_X_Y_controller}};
		end
	endcase
end
defparam ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0.Width = 32;
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto	ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst0(
	.W(W[31:0]),
	.Z(Z[31:0]),
	.Y(Y[31:0]),
	.X(X[31:0]),
	
	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN[0]),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN[0]),
	
	.S(S[31:0]),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN[0]),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN[0]),
	
	.result_SIDM_carry_in(result_SIDM_carry_in[0:0]),
	.result_SIDM_carry_out(result_SIDM_carry_out[0:0])
);


endmodule
