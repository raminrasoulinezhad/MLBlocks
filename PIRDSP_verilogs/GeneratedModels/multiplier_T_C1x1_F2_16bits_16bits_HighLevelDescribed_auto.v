`timescale 1 ns / 100 ps  
module multiplier_T_C1x1_F2_16bits_16bits_HighLevelDescribed_auto(
		input [15:0] a,
		input [15:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [31:0] result_0,
		output reg [31:0] result_1,
		output reg [3:0] result_SIDM_carry
	);

// functionality modes 
parameter mode_16x16	= 2'b00;
parameter mode_sum_16x16	= 2'b1;
parameter mode_sum_8x8	= 2'b10;
parameter mode_sum_4x4	= 2'b11;
// internal signal for half mode detection
wire HALF_0;
wire HALF_1;
wire HALF_2;

// input of partial multipliers
reg [15:0] A_0;

reg [15:0] B_0;

wire [31:0] C_0;

reg A_sign_0;

reg B_sign_0;

// to assign the input to sub multipliers 
always @(*) begin
	case (mode_SIMD)
		1'b0: begin
			A_0 = a[15:0];

			B_0 = b[15:0];
		end
		1'b1: begin
			A_0 = a[15:0];

			B_0 = b[15:0];
		end
	endcase
end

//sign controller
reg mode_SIMD;
always @(*) begin
	case (mode)
		mode_16x16: begin
			mode_SIMD = 1'b0;
			A_sign_0 = a_sign;

			B_sign_0 = b_sign;
		end
		default: begin
			mode_SIMD = 1'b1;
			A_sign_0 = a_sign;

			B_sign_0 = b_sign;
		end
	endcase
end

// Assigning half mode signals
assign FULL = (mode == mode_16x16);
assign HALF_0 = (mode == mode_sum_16x16);
assign HALF_1 = (mode == mode_sum_8x8);
assign HALF_2 = (mode == mode_sum_4x4);

multiplier_S_C1x1_F2_16bits_16bits_HighLevelDescribed_auto		multiplier_S_C1x1_F2_16bits_16bits_HighLevelDescribed_auto_inst0(
	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_0)
);


// to implement shifters for SIMD modes
reg [31:0] C_0_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{C_0}};
		end
		1'b1: begin
			C_0_shifted = {{C_0}};
		end
	endcase
end

// to assign output pairs 
reg [31:0] result_temp_0;
reg [32:0] result_temp_1;
always @ (*) begin
	result_temp_1 [7:0] = 8'b0;
	result_1 [7:0] = result_temp_1 [7:0];
	result_temp_0 [15:0] = {{1{((C_0_shifted[7])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [7:0]}};
	result_0 [15:0] = {{(result_temp_0 [15:8])&(~({8{HALF_2}}))},{result_temp_0 [7:0]}};
	result_SIDM_carry[0:0] = result_temp_0 [8:8];
	result_temp_1 [23:8] = {{1{((C_0_shifted[15])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [15:8]}};
	result_1 [23:8] = {{(result_temp_1 [23:16])&(~({8{(HALF_1)|(HALF_2)}}))},{result_temp_1 [15:8]}};
	result_SIDM_carry[1:1] = result_temp_1 [16:16];
	result_temp_0 [31:16] = {{1{((C_0_shifted[23])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [23:16]}};
	result_0 [31:16] = {{(result_temp_0 [31:24])&(~({8{HALF_2}}))},{result_temp_0 [23:16]}};
	result_SIDM_carry[2:2] = result_temp_0 [24:24];
	result_temp_1 [32:24] = {{1{((C_0_shifted[31])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [31:24]}};
	result_1 [31:24] = result_temp_1 [31:24];
	result_SIDM_carry[3:3] = result_temp_1 [32:32];
end


endmodule
