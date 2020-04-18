`timescale 1 ns / 100 ps  
module multiplier_T_C2x2_F2_16bits_16bits_HighLevelDescribed_auto(
		input clk,
		input reset,
		
		input [31:0] a,
		input [31:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [31:0] result_0,
		output reg [31:0] result_1,
		output reg [7:0] result_SIMD_carry
	);

		reg [31:0] a_reg;
		reg [31:0] b_reg;
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
parameter mode_16x16	= 2'b00;
parameter mode_sum_8x8	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
parameter mode_sum_2x2	= 2'b11;
// internal signal for half mode detection
wire HALF_0;
wire HALF_1;
wire HALF_2;

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
			A_0 = a_reg[7:0];
			A_1 = a_reg[15:8];
			A_2 = a_reg[7:0];
			A_3 = a_reg[15:8];

			B_0 = b_reg[7:0];
			B_1 = b_reg[7:0];
			B_2 = b_reg[15:8];
			B_3 = b_reg[15:8];
		end
		1'b1: begin
			A_0 = a_reg[7:0];
			A_1 = a_reg[15:8];
			A_2 = a_reg[23:16];
			A_3 = a_reg[31:24];

			B_0 = b_reg[7:0];
			B_1 = b_reg[15:8];
			B_2 = b_reg[23:16];
			B_3 = b_reg[31:24];
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
			A_sign_1 = a_sign_reg;
			A_sign_2 = 1'b0;
			A_sign_3 = a_sign_reg;

			B_sign_0 = 1'b0;
			B_sign_1 = 1'b0;
			B_sign_2 = b_sign_reg;
			B_sign_3 = b_sign_reg;
		end
		default: begin
			mode_SIMD = 1'b1;
			A_sign_0 = a_sign_reg;
			A_sign_1 = a_sign_reg;
			A_sign_2 = a_sign_reg;
			A_sign_3 = a_sign_reg;

			B_sign_0 = b_sign_reg;
			B_sign_1 = b_sign_reg;
			B_sign_2 = b_sign_reg;
			B_sign_3 = b_sign_reg;
		end
	endcase
end

// Assigning half mode signals
assign FULL = (mode == mode_16x16);
assign HALF_0 = (mode == mode_sum_8x8);
assign HALF_1 = (mode == mode_sum_4x4);
assign HALF_2 = (mode == mode_sum_2x2);

multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto_inst0(
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

multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto_inst1(
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

multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto_inst2(
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

multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto		multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto_inst3(
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
	result_temp_1 [3:0] = 4'b0;
	result_1 [3:0] = result_temp_1 [3:0];
	result_temp_0 [7:0] = {{1{((C_0_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [3:0]}} + {{1{((C_1_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [3:0]}} + {{1{((C_2_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [3:0]}} + {{1{((C_3_shifted[3])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [3:0]}};
	result_0 [7:0] = {{(result_temp_0 [7:4])&(~({4{HALF_2}}))},{result_temp_0 [3:0]}};
	result_SIMD_carry[0:0] = result_temp_0 [4:4];
	result_temp_1 [11:4] = {{1{((C_0_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [7:4]}} + {{1{((C_1_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [7:4]}} + {{1{((C_2_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [7:4]}} + {{1{((C_3_shifted[7])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [7:4]}};
	result_1 [11:4] = {{(result_temp_1 [11:8])&(~({4{(HALF_1)|(HALF_2)}}))},{result_temp_1 [7:4]}};
	result_SIMD_carry[1:1] = result_temp_1 [8:8];
	result_temp_0 [15:8] = {{1{((C_0_shifted[11])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [11:8]}} + {{1{((C_1_shifted[11])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [11:8]}} + {{1{((C_2_shifted[11])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [11:8]}} + {{1{((C_3_shifted[11])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [11:8]}};
	result_0 [15:8] = {{(result_temp_0 [15:12])&(~({4{HALF_2}}))},{result_temp_0 [11:8]}};
	result_SIMD_carry[2:2] = result_temp_0 [12:12];
	result_temp_1 [19:12] = {{1{((C_0_shifted[15])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [15:12]}} + {{1{((C_1_shifted[15])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [15:12]}} + {{1{((C_2_shifted[15])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [15:12]}} + {{1{((C_3_shifted[15])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [15:12]}};
	result_1 [19:12] = {{(result_temp_1 [19:16])&(~({4{((HALF_0)|(HALF_1))|(HALF_2)}}))},{result_temp_1 [15:12]}};
	result_SIMD_carry[3:3] = result_temp_1 [16:16];
	result_temp_0 [23:16] = {{1{((C_0_shifted[19])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [19:16]}} + {{1{((C_1_shifted[19])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [19:16]}} + {{1{((C_2_shifted[19])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [19:16]}} + {{1{((C_3_shifted[19])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [19:16]}};
	result_0 [23:16] = {{(result_temp_0 [23:20])&(~({4{HALF_2}}))},{result_temp_0 [19:16]}};
	result_SIMD_carry[4:4] = result_temp_0 [20:20];
	result_temp_1 [27:20] = {{1{((C_0_shifted[23])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [23:20]}} + {{1{((C_1_shifted[23])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [23:20]}} + {{1{((C_2_shifted[23])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [23:20]}} + {{1{((C_3_shifted[23])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [23:20]}};
	result_1 [27:20] = {{(result_temp_1 [27:24])&(~({4{(HALF_1)|(HALF_2)}}))},{result_temp_1 [23:20]}};
	result_SIMD_carry[5:5] = result_temp_1 [24:24];
	result_temp_0 [31:24] = {{1{((C_0_shifted[27])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [27:24]}} + {{1{((C_1_shifted[27])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [27:24]}} + {{1{((C_2_shifted[27])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [27:24]}} + {{1{((C_3_shifted[27])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [27:24]}};
	result_0 [31:24] = {{(result_temp_0 [31:28])&(~({4{HALF_2}}))},{result_temp_0 [27:24]}};
	result_SIMD_carry[6:6] = result_temp_0 [28:28];
	result_temp_1 [32:28] = {{1{((C_0_shifted[31])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [31:28]}} + {{1{((C_1_shifted[31])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [31:28]}} + {{1{((C_2_shifted[31])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [31:28]}} + {{1{((C_3_shifted[31])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [31:28]}};
	result_1 [31:28] = result_temp_1 [31:28];
	result_SIMD_carry[7:7] = result_temp_1 [32:32];
end


endmodule
