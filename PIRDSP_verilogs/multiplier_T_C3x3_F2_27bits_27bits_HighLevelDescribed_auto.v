`timescale 1 ns / 100 ps  
module multiplier_T_C3x3_F2_27bits_27bits_HighLevelDescribed_auto(
		input clk,
		input reset,
		
		input [80:0] a,
		input [80:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [53:0] result_0,
		output reg [53:0] result_1,
		output reg [23:0] result_SIMD_carry
	);

		reg [80:0] a_reg;
		reg [80:0] b_reg;
		reg a_sign_reg;
		reg b_sign_reg;
always @ (posedge clk) begin
	if (reset) begin
		a_reg <= 0;
		b_reg <= 0;
		a_sign_reg <= 0;
		b_sign_reg <= 0;
	end
	else begin 
		a_reg <= a;
		b_reg <= b;
		a_sign_reg <= a_sign;
		b_sign_reg <= b_sign;
	end
end

// functionality modes 
parameter mode_27x27	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
parameter mode_sum_2x2	= 2'b11;
// internal signal for half mode detection
wire HALF_0;
wire HALF_1;
wire HALF_2;

// input of partial multipliers
reg [8:0] A_0;
reg [8:0] A_1;
reg [8:0] A_2;
reg [8:0] A_3;
reg [8:0] A_4;
reg [8:0] A_5;
reg [8:0] A_6;
reg [8:0] A_7;
reg [8:0] A_8;

reg [8:0] B_0;
reg [8:0] B_1;
reg [8:0] B_2;
reg [8:0] B_3;
reg [8:0] B_4;
reg [8:0] B_5;
reg [8:0] B_6;
reg [8:0] B_7;
reg [8:0] B_8;

wire [17:0] C_0;
wire [17:0] C_1;
wire [17:0] C_2;
wire [17:0] C_3;
wire [17:0] C_4;
wire [17:0] C_5;
wire [17:0] C_6;
wire [17:0] C_7;
wire [17:0] C_8;

reg A_sign_0;
reg A_sign_1;
reg A_sign_2;
reg A_sign_3;
reg A_sign_4;
reg A_sign_5;
reg A_sign_6;
reg A_sign_7;
reg A_sign_8;

reg B_sign_0;
reg B_sign_1;
reg B_sign_2;
reg B_sign_3;
reg B_sign_4;
reg B_sign_5;
reg B_sign_6;
reg B_sign_7;
reg B_sign_8;

// to assign the input to sub multipliers 
always @(*) begin
	case (mode_SIMD)
		1'b0: begin
			A_0 = a_reg[8:0];
			A_1 = a_reg[17:9];
			A_4 = a_reg[26:18];
			A_2 = a_reg[8:0];
			A_3 = a_reg[17:9];
			A_6 = a_reg[26:18];
			A_5 = a_reg[8:0];
			A_7 = a_reg[17:9];
			A_8 = a_reg[26:18];

			B_0 = b_reg[8:0];
			B_1 = b_reg[8:0];
			B_4 = b_reg[8:0];
			B_2 = b_reg[17:9];
			B_3 = b_reg[17:9];
			B_6 = b_reg[17:9];
			B_5 = b_reg[26:18];
			B_7 = b_reg[26:18];
			B_8 = b_reg[26:18];
		end
		1'b1: begin
			A_0 = a_reg[8:0];
			A_1 = a_reg[17:9];
			A_4 = a_reg[44:36];
			A_2 = a_reg[26:18];
			A_3 = a_reg[35:27];
			A_6 = a_reg[62:54];
			A_5 = a_reg[53:45];
			A_7 = a_reg[71:63];
			A_8 = a_reg[80:72];

			B_0 = b_reg[8:0];
			B_1 = b_reg[17:9];
			B_4 = b_reg[44:36];
			B_2 = b_reg[26:18];
			B_3 = b_reg[35:27];
			B_6 = b_reg[62:54];
			B_5 = b_reg[53:45];
			B_7 = b_reg[71:63];
			B_8 = b_reg[80:72];
		end
	endcase
end

//sign controller
reg mode_SIMD;
always @(*) begin
	case (mode)
		mode_27x27: begin
			mode_SIMD = 1'b0;
			A_sign_0 = 1'b0;
			A_sign_1 = 1'b0;
			A_sign_4 = a_sign_reg;
			A_sign_2 = 1'b0;
			A_sign_3 = 1'b0;
			A_sign_6 = a_sign_reg;
			A_sign_5 = 1'b0;
			A_sign_7 = 1'b0;
			A_sign_8 = a_sign_reg;

			B_sign_0 = 1'b0;
			B_sign_1 = 1'b0;
			B_sign_4 = 1'b0;
			B_sign_2 = 1'b0;
			B_sign_3 = 1'b0;
			B_sign_6 = 1'b0;
			B_sign_5 = b_sign_reg;
			B_sign_7 = b_sign_reg;
			B_sign_8 = b_sign_reg;
		end
		default: begin
			mode_SIMD = 1'b1;
			A_sign_0 = a_sign_reg;
			A_sign_1 = a_sign_reg;
			A_sign_4 = a_sign_reg;
			A_sign_2 = a_sign_reg;
			A_sign_3 = a_sign_reg;
			A_sign_6 = a_sign_reg;
			A_sign_5 = a_sign_reg;
			A_sign_7 = a_sign_reg;
			A_sign_8 = a_sign_reg;

			B_sign_0 = b_sign_reg;
			B_sign_1 = b_sign_reg;
			B_sign_4 = b_sign_reg;
			B_sign_2 = b_sign_reg;
			B_sign_3 = b_sign_reg;
			B_sign_6 = b_sign_reg;
			B_sign_5 = b_sign_reg;
			B_sign_7 = b_sign_reg;
			B_sign_8 = b_sign_reg;
		end
	endcase
end

// Assigning half mode signals
assign FULL = (mode == mode_27x27);
assign HALF_0 = (mode == mode_sum_9x9);
assign HALF_1 = (mode == mode_sum_4x4);
assign HALF_2 = (mode == mode_sum_2x2);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst0(
	.clk(clk),
	.reset(reset),

	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_0)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst1(
	.clk(clk),
	.reset(reset),

	.A(A_1),
	.B(B_1),

	.A_sign(A_sign_1),
	.B_sign(B_sign_1),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_1)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst2(
	.clk(clk),
	.reset(reset),

	.A(A_2),
	.B(B_2),

	.A_sign(A_sign_2),
	.B_sign(B_sign_2),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_2)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst3(
	.clk(clk),
	.reset(reset),

	.A(A_3),
	.B(B_3),

	.A_sign(A_sign_3),
	.B_sign(B_sign_3),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_3)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst4(
	.clk(clk),
	.reset(reset),

	.A(A_4),
	.B(B_4),

	.A_sign(A_sign_4),
	.B_sign(B_sign_4),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_4)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst5(
	.clk(clk),
	.reset(reset),

	.A(A_5),
	.B(B_5),

	.A_sign(A_sign_5),
	.B_sign(B_sign_5),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_5)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst6(
	.clk(clk),
	.reset(reset),

	.A(A_6),
	.B(B_6),

	.A_sign(A_sign_6),
	.B_sign(B_sign_6),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_6)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst7(
	.clk(clk),
	.reset(reset),

	.A(A_7),
	.B(B_7),

	.A_sign(A_sign_7),
	.B_sign(B_sign_7),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_7)
);

multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x3_F2_9bits_9bits_HighLevelDescribed_auto_inst8(
	.clk(clk),
	.reset(reset),

	.A(A_8),
	.B(B_8),

	.A_sign(A_sign_8),
	.B_sign(B_sign_8),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_8)
);


// to implement shifters for SIMD modes
reg [53:0] C_0_shifted;
reg [53:0] C_1_shifted;
reg [53:0] C_2_shifted;
reg [53:0] C_3_shifted;
reg [53:0] C_4_shifted;
reg [53:0] C_5_shifted;
reg [53:0] C_6_shifted;
reg [53:0] C_7_shifted;
reg [53:0] C_8_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{36{(C_0[17])&((A_sign_0)|(B_sign_0))}}, {C_0}};
			C_1_shifted = {{27{(C_1[17])&((A_sign_1)|(B_sign_1))}}, {C_1}, {9{1'b0}}};
			C_4_shifted = {{18{(C_4[17])&((A_sign_4)|(B_sign_4))}}, {C_4}, {18{1'b0}}};
			C_2_shifted = {{27{(C_2[17])&((A_sign_2)|(B_sign_2))}}, {C_2}, {9{1'b0}}};
			C_3_shifted = {{18{(C_3[17])&((A_sign_3)|(B_sign_3))}}, {C_3}, {18{1'b0}}};
			C_6_shifted = {{9{(C_6[17])&((A_sign_6)|(B_sign_6))}}, {C_6}, {27{1'b0}}};
			C_5_shifted = {{18{(C_5[17])&((A_sign_5)|(B_sign_5))}}, {C_5}, {18{1'b0}}};
			C_7_shifted = {{9{(C_7[17])&((A_sign_7)|(B_sign_7))}}, {C_7}, {27{1'b0}}};
			C_8_shifted = {{C_8}, {36{1'b0}}};
		end
		1'b1: begin
			C_0_shifted = {{36{1'b0}}, {C_0}};
			C_1_shifted = {{27{1'b0}}, {9{1'b0}} ,{C_1}};
			C_4_shifted = {{18{1'b0}}, {C_4}, {18{1'b0}}};
			C_2_shifted = {{27{1'b0}}, {9{1'b0}} ,{C_2}};
			C_3_shifted = {{18{1'b0}}, {C_3}, {18{1'b0}}};
			C_6_shifted = {{C_6}, {9{1'b0}}, {27{1'b0}}};
			C_5_shifted = {{18{1'b0}}, {C_5}, {18{1'b0}}};
			C_7_shifted = {{C_7}, {9{1'b0}}, {27{1'b0}}};
			C_8_shifted = {{C_8}, {36{1'b0}}};
		end
	endcase
end

// to assign output pairs 
reg [53:0] result_temp_0;
reg [55:0] result_temp_1;
always @ (*) begin
	result_temp_1 [3:0] = 4'b0;
	result_1 [3:0] = result_temp_1 [3:0];
	result_temp_0 [7:0] = {{2{((C_0_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [3:0]}} + {{2{((C_1_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [3:0]}} + {{2{((C_2_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [3:0]}} + {{2{((C_3_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [3:0]}} + {{2{((C_4_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [3:0]}} + {{2{((C_5_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [3:0]}} + {{2{((C_6_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_6_shifted [3:0]}} + {{2{((C_7_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_7_shifted [3:0]}} + {{2{((C_8_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_8_shifted [3:0]}};
	result_0 [7:0] = {{(result_temp_0 [7:4])&(~({4{HALF_2}}))},{result_temp_0 [3:0]}};
	result_SIMD_carry[1:0] = result_temp_0 [5:4];
	result_temp_1 [13:4] = {{2{((C_0_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [7:4]}} + {{2{((C_1_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [7:4]}} + {{2{((C_2_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [7:4]}} + {{2{((C_3_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [7:4]}} + {{2{((C_4_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [7:4]}} + {{2{((C_5_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [7:4]}} + {{2{((C_6_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_6_shifted [7:4]}} + {{2{((C_7_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_7_shifted [7:4]}} + {{2{((C_8_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_8_shifted [7:4]}};
	result_1 [13:4] = {{(result_temp_1 [13:8])&(~({6{(HALF_1)|(HALF_2)}}))},{result_temp_1 [7:4]}};
	result_SIMD_carry[3:2] = result_temp_1 [9:8];
	result_temp_0 [17:8] = {{2{((C_0_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [13:8]}} + {{2{((C_1_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [13:8]}} + {{2{((C_2_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [13:8]}} + {{2{((C_3_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [13:8]}} + {{2{((C_4_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [13:8]}} + {{2{((C_5_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [13:8]}} + {{2{((C_6_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_6_shifted [13:8]}} + {{2{((C_7_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_7_shifted [13:8]}} + {{2{((C_8_shifted[13])&(HALF_2))&((a_sign|b_sign))}},{C_8_shifted [13:8]}};
	result_0 [17:8] = {{(result_temp_0 [17:14])&(~({4{HALF_2}}))},{result_temp_0 [13:8]}};
	result_SIMD_carry[5:4] = result_temp_0 [15:14];
	result_temp_1 [21:14] = {{2{((C_0_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [17:14]}} + {{2{((C_1_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [17:14]}} + {{2{((C_2_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [17:14]}} + {{2{((C_3_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [17:14]}} + {{2{((C_4_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [17:14]}} + {{2{((C_5_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [17:14]}} + {{2{((C_6_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_6_shifted [17:14]}} + {{2{((C_7_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_7_shifted [17:14]}} + {{2{((C_8_shifted[17])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_8_shifted [17:14]}};
	result_1 [21:14] = {{(result_temp_1 [21:18])&(~({4{((HALF_0)|(HALF_1))|(HALF_2)}}))},{result_temp_1 [17:14]}};
	result_SIMD_carry[7:6] = result_temp_1 [19:18];
	result_temp_0 [25:18] = {{2{((C_0_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [21:18]}} + {{2{((C_1_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [21:18]}} + {{2{((C_2_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [21:18]}} + {{2{((C_3_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [21:18]}} + {{2{((C_4_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [21:18]}} + {{2{((C_5_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [21:18]}} + {{2{((C_6_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_6_shifted [21:18]}} + {{2{((C_7_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_7_shifted [21:18]}} + {{2{((C_8_shifted[21])&(HALF_2))&((a_sign|b_sign))}},{C_8_shifted [21:18]}};
	result_0 [25:18] = {{(result_temp_0 [25:22])&(~({4{HALF_2}}))},{result_temp_0 [21:18]}};
	result_SIMD_carry[9:8] = result_temp_0 [23:22];
	result_temp_1 [31:22] = {{2{((C_0_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [25:22]}} + {{2{((C_1_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [25:22]}} + {{2{((C_2_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [25:22]}} + {{2{((C_3_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [25:22]}} + {{2{((C_4_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [25:22]}} + {{2{((C_5_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [25:22]}} + {{2{((C_6_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_6_shifted [25:22]}} + {{2{((C_7_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_7_shifted [25:22]}} + {{2{((C_8_shifted[25])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_8_shifted [25:22]}};
	result_1 [31:22] = {{(result_temp_1 [31:26])&(~({6{(HALF_1)|(HALF_2)}}))},{result_temp_1 [25:22]}};
	result_SIMD_carry[11:10] = result_temp_1 [27:26];
	result_temp_0 [35:26] = {{2{((C_0_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [31:26]}} + {{2{((C_1_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [31:26]}} + {{2{((C_2_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [31:26]}} + {{2{((C_3_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [31:26]}} + {{2{((C_4_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [31:26]}} + {{2{((C_5_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [31:26]}} + {{2{((C_6_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_6_shifted [31:26]}} + {{2{((C_7_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_7_shifted [31:26]}} + {{2{((C_8_shifted[31])&(HALF_2))&((a_sign|b_sign))}},{C_8_shifted [31:26]}};
	result_0 [35:26] = {{(result_temp_0 [35:32])&(~({4{HALF_2}}))},{result_temp_0 [31:26]}};
	result_SIMD_carry[13:12] = result_temp_0 [33:32];
	result_temp_1 [39:32] = {{2{((C_0_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [35:32]}} + {{2{((C_1_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [35:32]}} + {{2{((C_2_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [35:32]}} + {{2{((C_3_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [35:32]}} + {{2{((C_4_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [35:32]}} + {{2{((C_5_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [35:32]}} + {{2{((C_6_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_6_shifted [35:32]}} + {{2{((C_7_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_7_shifted [35:32]}} + {{2{((C_8_shifted[35])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_8_shifted [35:32]}};
	result_1 [39:32] = {{(result_temp_1 [39:36])&(~({4{((HALF_0)|(HALF_1))|(HALF_2)}}))},{result_temp_1 [35:32]}};
	result_SIMD_carry[15:14] = result_temp_1 [37:36];
	result_temp_0 [43:36] = {{2{((C_0_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [39:36]}} + {{2{((C_1_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [39:36]}} + {{2{((C_2_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [39:36]}} + {{2{((C_3_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [39:36]}} + {{2{((C_4_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [39:36]}} + {{2{((C_5_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [39:36]}} + {{2{((C_6_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_6_shifted [39:36]}} + {{2{((C_7_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_7_shifted [39:36]}} + {{2{((C_8_shifted[39])&(HALF_2))&((a_sign|b_sign))}},{C_8_shifted [39:36]}};
	result_0 [43:36] = {{(result_temp_0 [43:40])&(~({4{HALF_2}}))},{result_temp_0 [39:36]}};
	result_SIMD_carry[17:16] = result_temp_0 [41:40];
	result_temp_1 [49:40] = {{2{((C_0_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [43:40]}} + {{2{((C_1_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [43:40]}} + {{2{((C_2_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [43:40]}} + {{2{((C_3_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [43:40]}} + {{2{((C_4_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [43:40]}} + {{2{((C_5_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [43:40]}} + {{2{((C_6_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_6_shifted [43:40]}} + {{2{((C_7_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_7_shifted [43:40]}} + {{2{((C_8_shifted[43])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_8_shifted [43:40]}};
	result_1 [49:40] = {{(result_temp_1 [49:44])&(~({6{(HALF_1)|(HALF_2)}}))},{result_temp_1 [43:40]}};
	result_SIMD_carry[19:18] = result_temp_1 [45:44];
	result_temp_0 [53:44] = {{2{((C_0_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [49:44]}} + {{2{((C_1_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [49:44]}} + {{2{((C_2_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [49:44]}} + {{2{((C_3_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [49:44]}} + {{2{((C_4_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [49:44]}} + {{2{((C_5_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [49:44]}} + {{2{((C_6_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_6_shifted [49:44]}} + {{2{((C_7_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_7_shifted [49:44]}} + {{2{((C_8_shifted[49])&(HALF_2))&((a_sign|b_sign))}},{C_8_shifted [49:44]}};
	result_0 [53:44] = {{(result_temp_0 [53:50])&(~({4{HALF_2}}))},{result_temp_0 [49:44]}};
	result_SIMD_carry[21:20] = result_temp_0 [51:50];
	result_temp_1 [55:50] = {{2{((C_0_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [53:50]}} + {{2{((C_1_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [53:50]}} + {{2{((C_2_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [53:50]}} + {{2{((C_3_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [53:50]}} + {{2{((C_4_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [53:50]}} + {{2{((C_5_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [53:50]}} + {{2{((C_6_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_6_shifted [53:50]}} + {{2{((C_7_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_7_shifted [53:50]}} + {{2{((C_8_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_8_shifted [53:50]}};
	result_1 [53:50] = result_temp_1 [53:50];
	result_SIMD_carry[23:22] = result_temp_1 [55:54];
end


endmodule
