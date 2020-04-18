`timescale 1 ns / 100 ps  
module multiplier_T_C2x1_F1_16bits_4bits_HighLevelDescribed_auto(
		input [15:0] a,
		input [7:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [19:0] result_0,
		output reg [19:0] result_1,
		output reg [1:0] result_SIDM_carry
	);

// functionality modes 
parameter mode_16x4	= 2'b00;
parameter mode_sum_8x4	= 2'b1;
parameter mode_sum_4x2	= 2'b10;
// internal signal for half mode detection
wire HALF_0;
wire HALF_1;

// input of partial multipliers
reg [7:0] A_0;
reg [7:0] A_1;

reg [3:0] B_0;
reg [3:0] B_1;

wire [11:0] C_0;
wire [11:0] C_1;

reg A_sign_0;
reg A_sign_1;

reg B_sign_0;
reg B_sign_1;

// to assign the input to sub multipliers 
always @(*) begin
	case (mode_SIMD)
		1'b0: begin
			A_0 = a[7:0];
			A_1 = a[15:8];

			B_0 = b[3:0];
			B_1 = b[3:0];
		end
		1'b1: begin
			A_0 = a[7:0];
			A_1 = a[15:8];

			B_0 = b[3:0];
			B_1 = b[7:4];
		end
	endcase
end

//sign controller
reg mode_SIMD;
always @(*) begin
	case (mode)
		mode_16x4: begin
			mode_SIMD = 1'b0;
			A_sign_0 = 1'b0;
			A_sign_1 = a_sign;

			B_sign_0 = b_sign;
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
assign FULL = (mode == mode_16x4);
assign HALF_0 = (mode == mode_sum_8x4);
assign HALF_1 = (mode == mode_sum_4x2);

multiplier_S_C2x1_F1_8bits_4bits_HighLevelDescribed_auto		multiplier_S_C2x1_F1_8bits_4bits_HighLevelDescribed_auto_inst0(
	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_0)
);

multiplier_S_C2x1_F1_8bits_4bits_HighLevelDescribed_auto		multiplier_S_C2x1_F1_8bits_4bits_HighLevelDescribed_auto_inst1(
	.A(A_1),
	.B(B_1),

	.A_sign(A_sign_1),
	.B_sign(B_sign_1),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_1)
);


// to implement shifters for SIMD modes
reg [19:0] C_0_shifted;
reg [19:0] C_1_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{8{(C_0[11])&((A_sign_0)|(B_sign_0))}}, {C_0}};
			C_1_shifted = {{C_1}, {8{1'b0}}};
		end
		1'b1: begin
			C_0_shifted = {{C_0}, {C_0[7:0]}};
			C_1_shifted = {{C_1}, {8{1'b0}}};
		end
	endcase
end

// to assign output pairs 
reg [19:0] result_temp_0;
reg [20:0] result_temp_1;
always @ (*) begin
	result_temp_1 [13:0] = 14'b0;
	result_1 [13:0] = result_temp_1 [13:0];
	result_temp_0 [19:0] = {{1{((C_0_shifted[13])&(HALF_1))&((a_sign|b_sign))}},{C_0_shifted [13:0]}} + {{1{((C_1_shifted[13])&(HALF_1))&((a_sign|b_sign))}},{C_1_shifted [13:0]}};
	result_0 [19:0] = {{(result_temp_0 [19:14])&(~({6{HALF_1}}))},{result_temp_0 [13:0]}};
	result_SIDM_carry[0:0] = result_temp_0 [14:14];
	result_temp_1 [20:14] = {{1{((C_0_shifted[19])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_0_shifted [19:14]}} + {{1{((C_1_shifted[19])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_1_shifted [19:14]}};
	result_1 [19:14] = result_temp_1 [19:14];
	result_SIDM_carry[1:1] = result_temp_1 [20:20];
end


endmodule
