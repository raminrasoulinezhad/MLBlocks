`timescale 1 ns / 100 ps 
module Overlay_C3x2_F1_27bits_18bits(
		input clk,
		input reset,
		
		input [1:0] mode,
		
		input [53:0] a,
		input [53:0] b,
		
		input a_sign,
		input b_sign,
		
		input [44:0] result_2,
		input CIN,
		
		output reg [44:0] S_reg,
		output reg [7:0] result_SIMD_carry_out_reg
);

wire [44:0] result_0;
wire [44:0] result_1;
wire [7:0] result_SIMD_carry;

reg [44:0] result_0_reg;
reg [44:0] result_1_reg;
reg [7:0] result_SIMD_carry_reg;

wire [44:0] S;
wire [7:0] result_SIMD_carry_out;

ALU_T_C3x2_F1_27bits_18bits	ALU_T_C3x2_F1_27bits_18bits_inst(
		
		.USE_SIMD(mode),
		
		.W(result_0_reg),
		.Y(result_1_reg),
		.X(result_2),

		.CIN(CIN),
		
		.S(S),
		
		.result_SIMD_carry_in(result_SIMD_carry_reg),
		.result_SIMD_carry_out(result_SIMD_carry_out)
);

multiplier_T_C3x2_F1_27bits_18bits_HighLevelDescribed_auto	multiplier_T_C3x2_F1_27bits_18bits_HighLevelDescribed_auto_inst(
		.clk(clk),
		.reset(reset),
		
		.a(a),
		.b(b),
		
		.a_sign(a_sign),
		.b_sign(b_sign),
		
		.mode(mode),
		
		.result_0(result_0),
		.result_1(result_1),
		.result_SIMD_carry(result_SIMD_carry)
	);

always @ (posedge clk)begin
	if(reset)begin
		result_0_reg <= 0;
		result_1_reg <= 0;
		result_SIMD_carry_reg <= 0;
		S_reg <= 0;
		result_SIMD_carry_out_reg <= 0;
	end
	else begin
		result_0_reg <= result_0;
		result_1_reg <= result_1;
		result_SIMD_carry_reg <= result_SIMD_carry;
		S_reg <= S;
		result_SIMD_carry_out_reg <= result_SIMD_carry_out;
	end
end
endmodule
