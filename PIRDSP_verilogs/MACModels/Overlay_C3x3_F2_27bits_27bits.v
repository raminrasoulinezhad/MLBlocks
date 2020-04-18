`timescale 1 ns / 100 ps 
module Overlay_C3x3_F2_27bits_27bits(
		input clk,
		input reset,
		
		input [1:0] mode,
		
		input [80:0] a,
		input [80:0] b,
		
		input a_sign,
		input b_sign,
		
		input [53:0] result_2,
		input CIN,
		
		output reg [53:0] S_reg,
		output reg [23:0] result_SIMD_carry_out_reg
);

wire [53:0] result_0;
wire [53:0] result_1;
wire [23:0] result_SIMD_carry;

reg [53:0] result_0_reg;
reg [53:0] result_1_reg;
reg [23:0] result_SIMD_carry_reg;

wire [53:0] S;
wire [23:0] result_SIMD_carry_out;

ALU_T_C3x3_F2_27bits_27bits	ALU_T_C3x3_F2_27bits_27bits_inst(

		.USE_SIMD(mode),
		
		.W(result_0_reg),
		.Y(result_1_reg),
		.X(result_2),

		.CIN(CIN),
		
		.S(S),
		
		.result_SIMD_carry_in(result_SIMD_carry_reg),
		.result_SIMD_carry_out(result_SIMD_carry_out)
);

multiplier_T_C3x3_F2_27bits_27bits_HighLevelDescribed_auto	multiplier_T_C3x3_F2_27bits_27bits_HighLevelDescribed_auto_inst(
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
