`timescale 1 ns / 100 ps  
module multiplier_T_C1x2_F1_16bits_16bits_HighLevelDescribed_auto(
		input [31:0] a,
		input [15:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [31:0] result_0,
		output reg [31:0] result_1,
		output reg [1:0] result_SIDM_carry
	);

// functionality modes 
parameter mode_16x16	= 2'b00;
parameter mode_sum_16x8	= 2'b1;
parameter mode_sum_8x4	= 2'b10;
// internal signal for half mode detection
wire HALF_0;
wire HALF_1;

// input of partial multipliers
reg [15:0] A_0;
reg [15:0] A_1;

reg [7:0] B_0;
reg [7:0] B_1;

wire [23:0] C_0;
wire [23:0] C_1;

reg A_sign_0;
reg A_sign_1;

reg B_sign_0;
reg B_sign_1;

// to assign the input to sub multipliers 
always @(*) begin
	case (mode_SIMD)
		1'b0: begin
			A_0 = a[15:0];
			A_1 = a[15:0];

			B_0 = b[7:0];
			B_1 = b[15:8];
		end
		1'b1: begin
			A_0 = a[15:0];
			A_1 = a[31:16];

			B_0 = b[7:0];
			B_1 = b[15:8];
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
			A_sign_1 = a_sign;

			B_sign_0 = 1'b0;
			B_sign_1 = b_sign;
		end
		default: begin
			mode_SIMD = 1'b1;
			A_sign_0 = a_sign;
			A_sign_1 = a_sign;

			B_sign_0 = b_sign;
			B_sign_1 = b_sign;
		end
	endcase
end

// Assigning half mode signals
assign FULL = (mode == mode_16x16);
assign HALF_0 = (mode == mode_sum_16x8);
assign HALF_1 = (mode == mode_sum_8x4);

multiplier_S_C1x2_F1_16bits_8bits_HighLevelDescribed_auto		multiplier_S_C1x2_F1_16bits_8bits_HighLevelDescribed_auto_inst0(
	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_0)
);

multiplier_S_C1x2_F1_16bits_8bits_HighLevelDescribed_auto		multiplier_S_C1x2_F1_16bits_8bits_HighLevelDescribed_auto_inst1(
	.A(A_1),
	.B(B_1),

	.A_sign(A_sign_1),
	.B_sign(B_sign_1),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_1)
);


// to implement shifters for SIMD modes
reg [31:0] C_0_shifted;
reg [31:0] C_1_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{8{(C_0[23])&((A_sign_0)|(B_sign_0))}}, {C_0}};
			C_1_shifted = {{C_1}, {8{1'b0}}};
		end
		1'b1: begin
			C_0_shifted = {{C_0}, {C_0[7:0]}};
			C_1_shifted = {{C_1}, {8{1'b0}}};
		end
	endcase
end

// to assign output pairs 
reg [31:0] result_temp_0;
reg [32:0] result_temp_1;
always @ (*) begin
	result_temp_1 [19:0] = 20'b0;
	result_1 [19:0] = result_temp_1 [19:0];
	result_temp_0 [31:0] = {{1{((C_0_shifted[19])&(HALF_1))&((a_sign|b_sign))}},{C_0_shifted [19:0]}} + {{1{((C_1_shifted[19])&(HALF_1))&((a_sign|b_sign))}},{C_1_shifted [19:0]}};
	result_0 [31:0] = {{(result_temp_0 [31:20])&(~({12{HALF_1}}))},{result_temp_0 [19:0]}};
	result_SIDM_carry[0:0] = result_temp_0 [20:20];
	result_temp_1 [32:20] = {{1{((C_0_shifted[31])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_0_shifted [31:20]}} + {{1{((C_1_shifted[31])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_1_shifted [31:20]}};
	result_1 [31:20] = result_temp_1 [31:20];
	result_SIDM_carry[1:1] = result_temp_1 [32:32];
end


endmodule
