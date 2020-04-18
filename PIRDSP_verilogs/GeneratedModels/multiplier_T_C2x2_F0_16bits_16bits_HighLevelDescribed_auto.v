`timescale 1 ns / 100 ps  
module multiplier_T_C2x2_F0_16bits_16bits_HighLevelDescribed_auto(
		input [31:0] a,
		input [31:0] b,
		
		input a_sign,
		input b_sign,
		
		input [0:0] mode,
		
		output reg [31:0] result_0,
		output reg [31:0] result_1,
		output reg [1:0] result_SIDM_carry
	);

// functionality modes 
parameter mode_16x16	= 1'b00;
parameter mode_sum_8x8	= 1'b1;
// internal signal for half mode detection
wire HALF_0;

// input of partial multipliers
reg [7:0] A_0;
reg [7:0] A_1;
reg [7:0] A_2;
reg [7:0] A_3;

reg [7:0] B_0;
reg [7:0] B_1;
reg [7:0] B_2;
reg [7:0] B_3;

wire [15:0] C_0;
wire [15:0] C_1;
wire [15:0] C_2;
wire [15:0] C_3;

reg A_sign_0;
reg A_sign_1;
reg A_sign_2;
reg A_sign_3;

reg B_sign_0;
reg B_sign_1;
reg B_sign_2;
reg B_sign_3;

// to assign the input to sub multipliers 
always @(*) begin
	case (mode_SIMD)
		1'b0: begin
			A_0 = a[7:0];
			A_1 = a[15:8];
			A_2 = a[7:0];
			A_3 = a[15:8];

			B_0 = b[7:0];
			B_1 = b[7:0];
			B_2 = b[15:8];
			B_3 = b[15:8];
		end
		1'b1: begin
			A_0 = a[7:0];
			A_1 = a[15:8];
			A_2 = a[23:16];
			A_3 = a[31:24];

			B_0 = b[7:0];
			B_1 = b[15:8];
			B_2 = b[23:16];
			B_3 = b[31:24];
		end
	endcase
end

//sign controller
reg mode_SIMD;
always @(*) begin
	case (mode)
		mode_16x16: begin
			mode_SIMD = 1'b0;
			A_sign_0 = 1'b0;
			A_sign_1 = a_sign;
			A_sign_2 = 1'b0;
			A_sign_3 = a_sign;

			B_sign_0 = 1'b0;
			B_sign_1 = 1'b0;
			B_sign_2 = b_sign;
			B_sign_3 = b_sign;
		end
		default: begin
			mode_SIMD = 1'b1;
			A_sign_0 = a_sign;
			A_sign_1 = a_sign;
			A_sign_2 = a_sign;
			A_sign_3 = a_sign;

			B_sign_0 = b_sign;
			B_sign_1 = b_sign;
			B_sign_2 = b_sign;
			B_sign_3 = b_sign;
		end
	endcase
end

// Assigning half mode signals
assign FULL = (mode == mode_16x16);
assign HALF_0 = (mode == mode_sum_8x8);

multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto_inst0(
	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),

	.C(C_0)
);

multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto_inst1(
	.A(A_1),
	.B(B_1),

	.A_sign(A_sign_1),
	.B_sign(B_sign_1),

	.HALF_0(HALF_0 | FULL),

	.C(C_1)
);

multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto_inst2(
	.A(A_2),
	.B(B_2),

	.A_sign(A_sign_2),
	.B_sign(B_sign_2),

	.HALF_0(HALF_0 | FULL),

	.C(C_2)
);

multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto_inst3(
	.A(A_3),
	.B(B_3),

	.A_sign(A_sign_3),
	.B_sign(B_sign_3),

	.HALF_0(HALF_0 | FULL),

	.C(C_3)
);


// to implement shifters for SIMD modes
reg [31:0] C_0_shifted;
reg [31:0] C_1_shifted;
reg [31:0] C_2_shifted;
reg [31:0] C_3_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{16{(C_0[15])&((A_sign_0)|(B_sign_0))}}, {C_0}};
			C_1_shifted = {{8{(C_1[15])&((A_sign_1)|(B_sign_1))}}, {C_1}, {8{1'b0}}};
			C_2_shifted = {{8{(C_2[15])&((A_sign_2)|(B_sign_2))}}, {C_2}, {8{1'b0}}};
			C_3_shifted = {{C_3}, {16{1'b0}}};
		end
		1'b1: begin
			C_0_shifted = {{16{1'b0}}, {C_0}};
			C_1_shifted = {{8{1'b0}}, {8{1'b0}} ,{C_1}};
			C_2_shifted = {{C_2}, {8{1'b0}}, {8{1'b0}}};
			C_3_shifted = {{C_3}, {16{1'b0}}};
		end
	endcase
end

// to assign output pairs 
reg [31:0] result_temp_0;
reg [32:0] result_temp_1;
always @ (*) begin
	result_temp_1 [15:0] = 16'b0;
	result_1 [15:0] = result_temp_1 [15:0];
	result_temp_0 [31:0] = {{1{((C_0_shifted[15])&(HALF_0))&((a_sign|b_sign))}},{C_0_shifted [15:0]}} + {{1{((C_1_shifted[15])&(HALF_0))&((a_sign|b_sign))}},{C_1_shifted [15:0]}} + {{1{((C_2_shifted[15])&(HALF_0))&((a_sign|b_sign))}},{C_2_shifted [15:0]}} + {{1{((C_3_shifted[15])&(HALF_0))&((a_sign|b_sign))}},{C_3_shifted [15:0]}};
	result_0 [31:0] = {{(result_temp_0 [31:16])&(~({16{HALF_0}}))},{result_temp_0 [15:0]}};
	result_SIDM_carry[0:0] = result_temp_0 [16:16];
	result_temp_1 [32:16] = {{1{((C_0_shifted[31])&(HALF_0))&((a_sign|b_sign))}},{C_0_shifted [31:16]}} + {{1{((C_1_shifted[31])&(HALF_0))&((a_sign|b_sign))}},{C_1_shifted [31:16]}} + {{1{((C_2_shifted[31])&(HALF_0))&((a_sign|b_sign))}},{C_2_shifted [31:16]}} + {{1{((C_3_shifted[31])&(HALF_0))&((a_sign|b_sign))}},{C_3_shifted [31:16]}};
	result_1 [31:16] = result_temp_1 [31:16];
	result_SIDM_carry[1:1] = result_temp_1 [32:32];
end


endmodule
