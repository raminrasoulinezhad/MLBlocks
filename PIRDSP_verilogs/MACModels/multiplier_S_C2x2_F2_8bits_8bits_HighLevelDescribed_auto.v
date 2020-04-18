`timescale 1 ns / 100 ps  
module multiplier_S_C2x2_F2_8bits_8bits_HighLevelDescribed_auto(
		input clk,
		input reset,

		input [A_chop_size-1:0] A,
		input [B_chop_size-1:0] B,

		input A_sign,
		input B_sign,

		input HALF_0,	// a selector bit to switch computation to half mode level 0
		input HALF_1,	// a selector bit to switch computation to half mode level 1
		input HALF_2,	// a selector bit to switch computation to half mode level 2

		output reg [A_chop_size+B_chop_size-1:0] C
	);

parameter A_chop_size = 8;
parameter B_chop_size = 8;

// to support both signed and unsigned multiplication
// sign extension regarding extra sign identifier
wire A_extended_level0_0;
wire B_extended_level0_0;
assign A_extended_level0_0 = (A[7])&(A_sign);
assign B_extended_level0_0 = (B[7])&(B_sign);

wire A_extended_level1_0;
wire B_extended_level1_0;
assign A_extended_level1_0 = (A[7])&(A_sign);
assign B_extended_level1_0 = (B[7])&(B_sign);
wire A_extended_level1_1;
wire B_extended_level1_1;
assign A_extended_level1_1 = (A[3])&(A_sign);
assign B_extended_level1_1 = (B[3])&(B_sign);

wire A_extended_level2_0;
wire B_extended_level2_0;
assign A_extended_level2_0 = (A[7])&(A_sign);
assign B_extended_level2_0 = (B[7])&(B_sign);
wire A_extended_level2_1;
wire B_extended_level2_1;
assign A_extended_level2_1 = (A[5])&(A_sign);
assign B_extended_level2_1 = (B[5])&(B_sign);
wire A_extended_level2_2;
wire B_extended_level2_2;
assign A_extended_level2_2 = (A[3])&(A_sign);
assign B_extended_level2_2 = (B[3])&(B_sign);
wire A_extended_level2_3;
wire B_extended_level2_3;
assign A_extended_level2_3 = (A[1])&(A_sign);
assign B_extended_level2_3 = (B[1])&(B_sign);


reg [A_chop_size:0] PP [B_chop_size:0];
always @(*) begin
	PP[0][0] = (A[0])&(B[0]);
	PP[0][1] = (A[1])&(B[0]);
	PP[0][2] = ((((A[2])&(~(HALF_2)))|((A_extended_level2_3)&(HALF_2)))&(B[0]))^(HALF_2);
	PP[0][3] = ((A[3])&(B[0]))&(~(HALF_2));
	PP[0][4] = (((((A[4])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[0]))^(HALF_1))&(~(HALF_2));
	PP[0][5] = (((A[5])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][6] = (((A[6])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][7] = (((A[7])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][8] = ((~((A_extended_level0_0)&(B[0])))&(~(HALF_1)))&(~(HALF_2));
	PP[1][0] = (A[0])&(B[1]);
	PP[1][1] = (A[1])&(B[1]);
	PP[1][2] = ((((A[2])&(~(HALF_2)))|((A_extended_level2_3)&(HALF_2)))&(B[1]))^(HALF_2);
	PP[1][3] = ((A[3])&(B[1]))&(~(HALF_2));
	PP[1][4] = (((((A[4])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[1]))^(HALF_1))&(~(HALF_2));
	PP[1][5] = (((A[5])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][6] = (((A[6])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][7] = (((A[7])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][8] = ((~((A_extended_level0_0)&(B[1])))&(~(HALF_1)))&(~(HALF_2));
	PP[2][0] = ((A[0])&(((B[2])&(~(HALF_2)))|((B_extended_level2_3)&(HALF_2))))^(HALF_2);
	PP[2][1] = ((A[1])&(((B[2])&(~(HALF_2)))|((B_extended_level2_3)&(HALF_2))))^(HALF_2);
	PP[2][2] = (A[2])&(B[2]);
	PP[2][3] = (A[3])&(B[2]);
	PP[2][4] = ((((((A[4])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_2)&(HALF_2)))&(B[2]))^((HALF_1)|(HALF_2));
	PP[2][5] = (((A[5])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][6] = (((A[6])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][7] = (((A[7])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][8] = ((~((A_extended_level0_0)&(B[2])))&(~(HALF_1)))&(~(HALF_2));
	PP[3][0] = ((A[0])&(B[3]))&(~(HALF_2));
	PP[3][1] = ((A[1])&(B[3]))&(~(HALF_2));
	PP[3][2] = (A[2])&(B[3]);
	PP[3][3] = (A[3])&(B[3]);
	PP[3][4] = ((((((A[4])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_2)&(HALF_2)))&(B[3]))^((HALF_1)|(HALF_2));
	PP[3][5] = (((A[5])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][6] = (((A[6])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][7] = (((A[7])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][8] = ((~((A_extended_level0_0)&(B[3])))&(~(HALF_1)))&(~(HALF_2));
	PP[4][0] = (((A[0])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1))&(~(HALF_2));
	PP[4][1] = (((A[1])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1))&(~(HALF_2));
	PP[4][2] = ((A[2])&(((((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_2)&(HALF_2))))^((HALF_1)|(HALF_2));
	PP[4][3] = ((A[3])&(((((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_2)&(HALF_2))))^((HALF_1)|(HALF_2));
	PP[4][4] = (A[4])&(B[4]);
	PP[4][5] = (A[5])&(B[4]);
	PP[4][6] = ((((A[6])&(~(HALF_2)))|((A_extended_level2_1)&(HALF_2)))&(B[4]))^(HALF_2);
	PP[4][7] = ((A[7])&(B[4]))&(~(HALF_2));
	PP[4][8] = (~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[4])))&(~(HALF_2));
	PP[5][0] = (((A[0])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][1] = (((A[1])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][2] = (((A[2])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][3] = (((A[3])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][4] = (A[4])&(B[5]);
	PP[5][5] = (A[5])&(B[5]);
	PP[5][6] = ((((A[6])&(~(HALF_2)))|((A_extended_level2_1)&(HALF_2)))&(B[5]))^(HALF_2);
	PP[5][7] = ((A[7])&(B[5]))&(~(HALF_2));
	PP[5][8] = (~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[5])))&(~(HALF_2));
	PP[6][0] = (((A[0])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][1] = (((A[1])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][2] = (((A[2])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][3] = (((A[3])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][4] = ((A[4])&(((B[6])&(~(HALF_2)))|((B_extended_level2_1)&(HALF_2))))^(HALF_2);
	PP[6][5] = ((A[5])&(((B[6])&(~(HALF_2)))|((B_extended_level2_1)&(HALF_2))))^(HALF_2);
	PP[6][6] = (A[6])&(B[6]);
	PP[6][7] = (A[7])&(B[6]);
	PP[6][8] = ~((((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_0)&(HALF_2)))&(B[6]));
	PP[7][0] = (((A[0])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][1] = (((A[1])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][2] = (((A[2])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][3] = (((A[3])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][4] = ((A[4])&(B[7]))&(~(HALF_2));
	PP[7][5] = ((A[5])&(B[7]))&(~(HALF_2));
	PP[7][6] = (A[6])&(B[7]);
	PP[7][7] = (A[7])&(B[7]);
	PP[7][8] = ~((((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_0)&(HALF_2)))&(B[7]));
	PP[8][0] = ((~((A[0])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[8][1] = ((~((A[1])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[8][2] = ((~((A[2])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[8][3] = ((~((A[3])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[8][4] = (~((A[4])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))))&(~(HALF_2));
	PP[8][5] = (~((A[5])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))))&(~(HALF_2));
	PP[8][6] = ~((A[6])&(((((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_0)&(HALF_2))));
	PP[8][7] = ~((A[7])&(((((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_0)&(HALF_2))));
	PP[8][8] = (A_extended_level0_0)&(B_extended_level0_0);
end

// sum of PPs
integer j;
integer i_0;
integer i_1;
integer i_2;
integer i_3;

wire [16:0] Baugh_Wooley_0;
assign Baugh_Wooley_0 = {{1'b0},{(HALF_2)|(1'b0)},{1'b0},{(HALF_1)|(1'b0)},{1'b0},{(HALF_2)|(1'b0)},{1'b0},{(HALF_0)|(1'b0)},{1'b0},{(HALF_2)|(1'b0)},{1'b0},{(HALF_1)|(1'b0)},{1'b0},{(HALF_2)|(1'b0)},{1'b0},{1'b0},{1'b0}};
wire [16:0] Baugh_Wooley_1;
assign Baugh_Wooley_1 = {{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0}};

reg [16:0] PP_temp [8:0];
always @(*) begin
	for (j = 0; j < (B_chop_size +1); j = j + 1 ) begin
		PP_temp[j] = 17'b0 ;
	end
	for (j = 0; j < (B_chop_size +1); j = j + 1 ) begin
		PP_temp[j] = (PP[j] << j);
	end
end

reg [15:0] C_temp_0;
reg [15:0] C_temp_1;
reg [15:0] C_0;
reg [15:0] C_1;
always @(*) begin
	C_temp_1 [3:0] = 4'b0;
	C_1 [3:0] = C_temp_1 [3:0];
	C_temp_0[7:0] = PP_temp[0][3: 0] + PP_temp[1][3: 0] + PP_temp[2][3: 0] + PP_temp[3][3: 0] + PP_temp[4][3: 0] + PP_temp[5][3: 0] + PP_temp[6][3: 0] + PP_temp[7][3: 0] + PP_temp[8][3: 0] + Baugh_Wooley_0[3: 0] + Baugh_Wooley_1[3: 0];
	C_0[7:0] = (C_temp_0[7:0])&(~({{4{HALF_2}},{4{1'b0}}}));
	C_temp_1[11:4] = PP_temp[0][7: 4] + PP_temp[1][7: 4] + PP_temp[2][7: 4] + PP_temp[3][7: 4] + PP_temp[4][7: 4] + PP_temp[5][7: 4] + PP_temp[6][7: 4] + PP_temp[7][7: 4] + PP_temp[8][7: 4] + Baugh_Wooley_0[7: 4] + Baugh_Wooley_1[7: 4];
	C_1[11:4] = (C_temp_1[11:4])&(~({{4{(HALF_1)|(HALF_2)}},{4{1'b0}}}));
	C_temp_0[15:8] = PP_temp[0][11: 8] + PP_temp[1][11: 8] + PP_temp[2][11: 8] + PP_temp[3][11: 8] + PP_temp[4][11: 8] + PP_temp[5][11: 8] + PP_temp[6][11: 8] + PP_temp[7][11: 8] + PP_temp[8][11: 8] + Baugh_Wooley_0[11: 8] + Baugh_Wooley_1[11: 8];
	C_0[15:8] = (C_temp_0[15:8])&(~({{4{HALF_2}},{4{1'b0}}}));
	C_temp_1[15:12] = PP_temp[0][15: 12] + PP_temp[1][15: 12] + PP_temp[2][15: 12] + PP_temp[3][15: 12] + PP_temp[4][15: 12] + PP_temp[5][15: 12] + PP_temp[6][15: 12] + PP_temp[7][15: 12] + PP_temp[8][15: 12] + Baugh_Wooley_0[15: 12] + Baugh_Wooley_1[15: 12];
	C_1[15:12] = (C_temp_1[15:12])&(~({{0{((HALF_0)|(HALF_1))|(HALF_2)}},{4{1'b0}}}));
end

reg C_carry_temp_0;
reg C_carry_temp_1;
reg C_carry_temp_2;
reg signed [A_chop_size+B_chop_size-1:0] C_temp;
always @(*) begin
	C_temp[3: 0] = C_0[3: 0] + C_1[3: 0];
	C_carry_temp_0 = ((((C_0[3])&(C_1[3])))|(((C_0[3])^(C_1[3]))&((C_0[2])&(C_1[2])))|(((C_0[3])^(C_1[3]))&((C_0[2])^(C_1[2]))&((C_0[1])&(C_1[1])))|(((C_0[3])^(C_1[3]))&((C_0[2])^(C_1[2]))&((C_0[1])^(C_1[1]))&((C_0[0])&(C_1[0])))|(((C_0[3])^(C_1[3]))&((C_0[2])^(C_1[2]))&((C_0[1])^(C_1[1]))&((C_0[0])^(C_1[0]))&(1'b0)));
	C_temp[7: 4] = C_0[7: 4] + C_1[7: 4] + ((C_carry_temp_0)&(~(HALF_2)));
	C_carry_temp_1 = ((((C_0[7])&(C_1[7])))|(((C_0[7])^(C_1[7]))&((C_0[6])&(C_1[6])))|(((C_0[7])^(C_1[7]))&((C_0[6])^(C_1[6]))&((C_0[5])&(C_1[5])))|(((C_0[7])^(C_1[7]))&((C_0[6])^(C_1[6]))&((C_0[5])^(C_1[5]))&((C_0[4])&(C_1[4])))|(((C_0[7])^(C_1[7]))&((C_0[6])^(C_1[6]))&((C_0[5])^(C_1[5]))&((C_0[4])^(C_1[4]))&C_carry_temp_0));
	C_temp[11: 8] = C_0[11: 8] + C_1[11: 8] + ((C_carry_temp_1)&(~((HALF_1)|(HALF_2))));
	C_carry_temp_2 = ((((C_0[11])&(C_1[11])))|(((C_0[11])^(C_1[11]))&((C_0[10])&(C_1[10])))|(((C_0[11])^(C_1[11]))&((C_0[10])^(C_1[10]))&((C_0[9])&(C_1[9])))|(((C_0[11])^(C_1[11]))&((C_0[10])^(C_1[10]))&((C_0[9])^(C_1[9]))&((C_0[8])&(C_1[8])))|(((C_0[11])^(C_1[11]))&((C_0[10])^(C_1[10]))&((C_0[9])^(C_1[9]))&((C_0[8])^(C_1[8]))&C_carry_temp_1));
	C_temp[15: 12] = C_0[15: 12] + C_1[15: 12] + ((C_carry_temp_2)&(~(HALF_2)));
end
always @ (posedge clk) begin
	if(reset)
		C <= 0;
	else
		C <= C_temp[A_chop_size+B_chop_size-1:0];
end


endmodule
