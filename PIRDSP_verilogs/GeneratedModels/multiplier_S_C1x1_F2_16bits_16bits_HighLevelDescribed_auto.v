`timescale 1 ns / 100 ps  
module multiplier_S_C1x1_F2_16bits_16bits_HighLevelDescribed_auto(
		input [A_chop_size-1:0] A,
		input [B_chop_size-1:0] B,

		input A_sign,
		input B_sign,

		input HALF_0,	// a selector bit to switch computation to half mode level 0
		input HALF_1,	// a selector bit to switch computation to half mode level 1
		input HALF_2,	// a selector bit to switch computation to half mode level 2

		output [A_chop_size+B_chop_size-1:0] C
	);

parameter A_chop_size = 16;
parameter B_chop_size = 16;

// to support both signed and unsigned multiplication
// sign extension regarding extra sign identifier
wire A_extended_level0_0;
wire B_extended_level0_0;
assign A_extended_level0_0 = (A[15])&(A_sign);
assign B_extended_level0_0 = (B[15])&(B_sign);

wire A_extended_level1_0;
wire B_extended_level1_0;
assign A_extended_level1_0 = (A[15])&(A_sign);
assign B_extended_level1_0 = (B[15])&(B_sign);
wire A_extended_level1_1;
wire B_extended_level1_1;
assign A_extended_level1_1 = (A[7])&(A_sign);
assign B_extended_level1_1 = (B[7])&(B_sign);

wire A_extended_level2_0;
wire B_extended_level2_0;
assign A_extended_level2_0 = (A[15])&(A_sign);
assign B_extended_level2_0 = (B[15])&(B_sign);
wire A_extended_level2_1;
wire B_extended_level2_1;
assign A_extended_level2_1 = (A[11])&(A_sign);
assign B_extended_level2_1 = (B[11])&(B_sign);
wire A_extended_level2_2;
wire B_extended_level2_2;
assign A_extended_level2_2 = (A[7])&(A_sign);
assign B_extended_level2_2 = (B[7])&(B_sign);
wire A_extended_level2_3;
wire B_extended_level2_3;
assign A_extended_level2_3 = (A[3])&(A_sign);
assign B_extended_level2_3 = (B[3])&(B_sign);


reg [A_chop_size:0] PP [B_chop_size:0];
always @(*) begin
	PP[0][0] = (A[0])&(B[0]);
	PP[0][1] = (A[1])&(B[0]);
	PP[0][2] = (A[2])&(B[0]);
	PP[0][3] = (A[3])&(B[0]);
	PP[0][4] = ((((A[4])&(~(HALF_2)))|((A_extended_level2_3)&(HALF_2)))&(B[0]))^(HALF_2);
	PP[0][5] = ((A[5])&(B[0]))&(~(HALF_2));
	PP[0][6] = ((A[6])&(B[0]))&(~(HALF_2));
	PP[0][7] = ((A[7])&(B[0]))&(~(HALF_2));
	PP[0][8] = (((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[0]))^(HALF_1))&(~(HALF_2));
	PP[0][9] = (((A[9])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][10] = (((A[10])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][11] = (((A[11])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][12] = (((A[12])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][13] = (((A[13])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][14] = (((A[14])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][15] = (((A[15])&(B[0]))&(~(HALF_1)))&(~(HALF_2));
	PP[0][16] = ((~((A_extended_level0_0)&(B[0])))&(~(HALF_1)))&(~(HALF_2));
	PP[1][0] = (A[0])&(B[1]);
	PP[1][1] = (A[1])&(B[1]);
	PP[1][2] = (A[2])&(B[1]);
	PP[1][3] = (A[3])&(B[1]);
	PP[1][4] = ((((A[4])&(~(HALF_2)))|((A_extended_level2_3)&(HALF_2)))&(B[1]))^(HALF_2);
	PP[1][5] = ((A[5])&(B[1]))&(~(HALF_2));
	PP[1][6] = ((A[6])&(B[1]))&(~(HALF_2));
	PP[1][7] = ((A[7])&(B[1]))&(~(HALF_2));
	PP[1][8] = (((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[1]))^(HALF_1))&(~(HALF_2));
	PP[1][9] = (((A[9])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][10] = (((A[10])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][11] = (((A[11])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][12] = (((A[12])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][13] = (((A[13])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][14] = (((A[14])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][15] = (((A[15])&(B[1]))&(~(HALF_1)))&(~(HALF_2));
	PP[1][16] = ((~((A_extended_level0_0)&(B[1])))&(~(HALF_1)))&(~(HALF_2));
	PP[2][0] = (A[0])&(B[2]);
	PP[2][1] = (A[1])&(B[2]);
	PP[2][2] = (A[2])&(B[2]);
	PP[2][3] = (A[3])&(B[2]);
	PP[2][4] = ((((A[4])&(~(HALF_2)))|((A_extended_level2_3)&(HALF_2)))&(B[2]))^(HALF_2);
	PP[2][5] = ((A[5])&(B[2]))&(~(HALF_2));
	PP[2][6] = ((A[6])&(B[2]))&(~(HALF_2));
	PP[2][7] = ((A[7])&(B[2]))&(~(HALF_2));
	PP[2][8] = (((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[2]))^(HALF_1))&(~(HALF_2));
	PP[2][9] = (((A[9])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][10] = (((A[10])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][11] = (((A[11])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][12] = (((A[12])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][13] = (((A[13])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][14] = (((A[14])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][15] = (((A[15])&(B[2]))&(~(HALF_1)))&(~(HALF_2));
	PP[2][16] = ((~((A_extended_level0_0)&(B[2])))&(~(HALF_1)))&(~(HALF_2));
	PP[3][0] = (A[0])&(B[3]);
	PP[3][1] = (A[1])&(B[3]);
	PP[3][2] = (A[2])&(B[3]);
	PP[3][3] = (A[3])&(B[3]);
	PP[3][4] = ((((A[4])&(~(HALF_2)))|((A_extended_level2_3)&(HALF_2)))&(B[3]))^(HALF_2);
	PP[3][5] = ((A[5])&(B[3]))&(~(HALF_2));
	PP[3][6] = ((A[6])&(B[3]))&(~(HALF_2));
	PP[3][7] = ((A[7])&(B[3]))&(~(HALF_2));
	PP[3][8] = (((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[3]))^(HALF_1))&(~(HALF_2));
	PP[3][9] = (((A[9])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][10] = (((A[10])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][11] = (((A[11])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][12] = (((A[12])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][13] = (((A[13])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][14] = (((A[14])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][15] = (((A[15])&(B[3]))&(~(HALF_1)))&(~(HALF_2));
	PP[3][16] = ((~((A_extended_level0_0)&(B[3])))&(~(HALF_1)))&(~(HALF_2));
	PP[4][0] = ((A[0])&(((B[4])&(~(HALF_2)))|((B_extended_level2_3)&(HALF_2))))^(HALF_2);
	PP[4][1] = ((A[1])&(((B[4])&(~(HALF_2)))|((B_extended_level2_3)&(HALF_2))))^(HALF_2);
	PP[4][2] = ((A[2])&(((B[4])&(~(HALF_2)))|((B_extended_level2_3)&(HALF_2))))^(HALF_2);
	PP[4][3] = ((A[3])&(((B[4])&(~(HALF_2)))|((B_extended_level2_3)&(HALF_2))))^(HALF_2);
	PP[4][4] = (A[4])&(B[4]);
	PP[4][5] = (A[5])&(B[4]);
	PP[4][6] = (A[6])&(B[4]);
	PP[4][7] = (A[7])&(B[4]);
	PP[4][8] = ((((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_2)&(HALF_2)))&(B[4]))^((HALF_1)|(HALF_2));
	PP[4][9] = (((A[9])&(B[4]))&(~(HALF_1)))&(~(HALF_2));
	PP[4][10] = (((A[10])&(B[4]))&(~(HALF_1)))&(~(HALF_2));
	PP[4][11] = (((A[11])&(B[4]))&(~(HALF_1)))&(~(HALF_2));
	PP[4][12] = (((A[12])&(B[4]))&(~(HALF_1)))&(~(HALF_2));
	PP[4][13] = (((A[13])&(B[4]))&(~(HALF_1)))&(~(HALF_2));
	PP[4][14] = (((A[14])&(B[4]))&(~(HALF_1)))&(~(HALF_2));
	PP[4][15] = (((A[15])&(B[4]))&(~(HALF_1)))&(~(HALF_2));
	PP[4][16] = ((~((A_extended_level0_0)&(B[4])))&(~(HALF_1)))&(~(HALF_2));
	PP[5][0] = ((A[0])&(B[5]))&(~(HALF_2));
	PP[5][1] = ((A[1])&(B[5]))&(~(HALF_2));
	PP[5][2] = ((A[2])&(B[5]))&(~(HALF_2));
	PP[5][3] = ((A[3])&(B[5]))&(~(HALF_2));
	PP[5][4] = (A[4])&(B[5]);
	PP[5][5] = (A[5])&(B[5]);
	PP[5][6] = (A[6])&(B[5]);
	PP[5][7] = (A[7])&(B[5]);
	PP[5][8] = ((((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_2)&(HALF_2)))&(B[5]))^((HALF_1)|(HALF_2));
	PP[5][9] = (((A[9])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][10] = (((A[10])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][11] = (((A[11])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][12] = (((A[12])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][13] = (((A[13])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][14] = (((A[14])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][15] = (((A[15])&(B[5]))&(~(HALF_1)))&(~(HALF_2));
	PP[5][16] = ((~((A_extended_level0_0)&(B[5])))&(~(HALF_1)))&(~(HALF_2));
	PP[6][0] = ((A[0])&(B[6]))&(~(HALF_2));
	PP[6][1] = ((A[1])&(B[6]))&(~(HALF_2));
	PP[6][2] = ((A[2])&(B[6]))&(~(HALF_2));
	PP[6][3] = ((A[3])&(B[6]))&(~(HALF_2));
	PP[6][4] = (A[4])&(B[6]);
	PP[6][5] = (A[5])&(B[6]);
	PP[6][6] = (A[6])&(B[6]);
	PP[6][7] = (A[7])&(B[6]);
	PP[6][8] = ((((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_2)&(HALF_2)))&(B[6]))^((HALF_1)|(HALF_2));
	PP[6][9] = (((A[9])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][10] = (((A[10])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][11] = (((A[11])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][12] = (((A[12])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][13] = (((A[13])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][14] = (((A[14])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][15] = (((A[15])&(B[6]))&(~(HALF_1)))&(~(HALF_2));
	PP[6][16] = ((~((A_extended_level0_0)&(B[6])))&(~(HALF_1)))&(~(HALF_2));
	PP[7][0] = ((A[0])&(B[7]))&(~(HALF_2));
	PP[7][1] = ((A[1])&(B[7]))&(~(HALF_2));
	PP[7][2] = ((A[2])&(B[7]))&(~(HALF_2));
	PP[7][3] = ((A[3])&(B[7]))&(~(HALF_2));
	PP[7][4] = (A[4])&(B[7]);
	PP[7][5] = (A[5])&(B[7]);
	PP[7][6] = (A[6])&(B[7]);
	PP[7][7] = (A[7])&(B[7]);
	PP[7][8] = ((((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_2)&(HALF_2)))&(B[7]))^((HALF_1)|(HALF_2));
	PP[7][9] = (((A[9])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][10] = (((A[10])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][11] = (((A[11])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][12] = (((A[12])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][13] = (((A[13])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][14] = (((A[14])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][15] = (((A[15])&(B[7]))&(~(HALF_1)))&(~(HALF_2));
	PP[7][16] = ((~((A_extended_level0_0)&(B[7])))&(~(HALF_1)))&(~(HALF_2));
	PP[8][0] = (((A[0])&(((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1))&(~(HALF_2));
	PP[8][1] = (((A[1])&(((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1))&(~(HALF_2));
	PP[8][2] = (((A[2])&(((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1))&(~(HALF_2));
	PP[8][3] = (((A[3])&(((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1))&(~(HALF_2));
	PP[8][4] = ((A[4])&(((((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_2)&(HALF_2))))^((HALF_1)|(HALF_2));
	PP[8][5] = ((A[5])&(((((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_2)&(HALF_2))))^((HALF_1)|(HALF_2));
	PP[8][6] = ((A[6])&(((((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_2)&(HALF_2))))^((HALF_1)|(HALF_2));
	PP[8][7] = ((A[7])&(((((B[8])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_2)&(HALF_2))))^((HALF_1)|(HALF_2));
	PP[8][8] = (A[8])&(B[8]);
	PP[8][9] = (A[9])&(B[8]);
	PP[8][10] = (A[10])&(B[8]);
	PP[8][11] = (A[11])&(B[8]);
	PP[8][12] = ((((A[12])&(~(HALF_2)))|((A_extended_level2_1)&(HALF_2)))&(B[8]))^(HALF_2);
	PP[8][13] = ((A[13])&(B[8]))&(~(HALF_2));
	PP[8][14] = ((A[14])&(B[8]))&(~(HALF_2));
	PP[8][15] = ((A[15])&(B[8]))&(~(HALF_2));
	PP[8][16] = (~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[8])))&(~(HALF_2));
	PP[9][0] = (((A[0])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][1] = (((A[1])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][2] = (((A[2])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][3] = (((A[3])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][4] = (((A[4])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][5] = (((A[5])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][6] = (((A[6])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][7] = (((A[7])&(B[9]))&(~(HALF_1)))&(~(HALF_2));
	PP[9][8] = (A[8])&(B[9]);
	PP[9][9] = (A[9])&(B[9]);
	PP[9][10] = (A[10])&(B[9]);
	PP[9][11] = (A[11])&(B[9]);
	PP[9][12] = ((((A[12])&(~(HALF_2)))|((A_extended_level2_1)&(HALF_2)))&(B[9]))^(HALF_2);
	PP[9][13] = ((A[13])&(B[9]))&(~(HALF_2));
	PP[9][14] = ((A[14])&(B[9]))&(~(HALF_2));
	PP[9][15] = ((A[15])&(B[9]))&(~(HALF_2));
	PP[9][16] = (~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[9])))&(~(HALF_2));
	PP[10][0] = (((A[0])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][1] = (((A[1])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][2] = (((A[2])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][3] = (((A[3])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][4] = (((A[4])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][5] = (((A[5])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][6] = (((A[6])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][7] = (((A[7])&(B[10]))&(~(HALF_1)))&(~(HALF_2));
	PP[10][8] = (A[8])&(B[10]);
	PP[10][9] = (A[9])&(B[10]);
	PP[10][10] = (A[10])&(B[10]);
	PP[10][11] = (A[11])&(B[10]);
	PP[10][12] = ((((A[12])&(~(HALF_2)))|((A_extended_level2_1)&(HALF_2)))&(B[10]))^(HALF_2);
	PP[10][13] = ((A[13])&(B[10]))&(~(HALF_2));
	PP[10][14] = ((A[14])&(B[10]))&(~(HALF_2));
	PP[10][15] = ((A[15])&(B[10]))&(~(HALF_2));
	PP[10][16] = (~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[10])))&(~(HALF_2));
	PP[11][0] = (((A[0])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][1] = (((A[1])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][2] = (((A[2])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][3] = (((A[3])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][4] = (((A[4])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][5] = (((A[5])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][6] = (((A[6])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][7] = (((A[7])&(B[11]))&(~(HALF_1)))&(~(HALF_2));
	PP[11][8] = (A[8])&(B[11]);
	PP[11][9] = (A[9])&(B[11]);
	PP[11][10] = (A[10])&(B[11]);
	PP[11][11] = (A[11])&(B[11]);
	PP[11][12] = ((((A[12])&(~(HALF_2)))|((A_extended_level2_1)&(HALF_2)))&(B[11]))^(HALF_2);
	PP[11][13] = ((A[13])&(B[11]))&(~(HALF_2));
	PP[11][14] = ((A[14])&(B[11]))&(~(HALF_2));
	PP[11][15] = ((A[15])&(B[11]))&(~(HALF_2));
	PP[11][16] = (~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[11])))&(~(HALF_2));
	PP[12][0] = (((A[0])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][1] = (((A[1])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][2] = (((A[2])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][3] = (((A[3])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][4] = (((A[4])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][5] = (((A[5])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][6] = (((A[6])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][7] = (((A[7])&(B[12]))&(~(HALF_1)))&(~(HALF_2));
	PP[12][8] = ((A[8])&(((B[12])&(~(HALF_2)))|((B_extended_level2_1)&(HALF_2))))^(HALF_2);
	PP[12][9] = ((A[9])&(((B[12])&(~(HALF_2)))|((B_extended_level2_1)&(HALF_2))))^(HALF_2);
	PP[12][10] = ((A[10])&(((B[12])&(~(HALF_2)))|((B_extended_level2_1)&(HALF_2))))^(HALF_2);
	PP[12][11] = ((A[11])&(((B[12])&(~(HALF_2)))|((B_extended_level2_1)&(HALF_2))))^(HALF_2);
	PP[12][12] = (A[12])&(B[12]);
	PP[12][13] = (A[13])&(B[12]);
	PP[12][14] = (A[14])&(B[12]);
	PP[12][15] = (A[15])&(B[12]);
	PP[12][16] = ~((((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_0)&(HALF_2)))&(B[12]));
	PP[13][0] = (((A[0])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][1] = (((A[1])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][2] = (((A[2])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][3] = (((A[3])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][4] = (((A[4])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][5] = (((A[5])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][6] = (((A[6])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][7] = (((A[7])&(B[13]))&(~(HALF_1)))&(~(HALF_2));
	PP[13][8] = ((A[8])&(B[13]))&(~(HALF_2));
	PP[13][9] = ((A[9])&(B[13]))&(~(HALF_2));
	PP[13][10] = ((A[10])&(B[13]))&(~(HALF_2));
	PP[13][11] = ((A[11])&(B[13]))&(~(HALF_2));
	PP[13][12] = (A[12])&(B[13]);
	PP[13][13] = (A[13])&(B[13]);
	PP[13][14] = (A[14])&(B[13]);
	PP[13][15] = (A[15])&(B[13]);
	PP[13][16] = ~((((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_0)&(HALF_2)))&(B[13]));
	PP[14][0] = (((A[0])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][1] = (((A[1])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][2] = (((A[2])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][3] = (((A[3])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][4] = (((A[4])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][5] = (((A[5])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][6] = (((A[6])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][7] = (((A[7])&(B[14]))&(~(HALF_1)))&(~(HALF_2));
	PP[14][8] = ((A[8])&(B[14]))&(~(HALF_2));
	PP[14][9] = ((A[9])&(B[14]))&(~(HALF_2));
	PP[14][10] = ((A[10])&(B[14]))&(~(HALF_2));
	PP[14][11] = ((A[11])&(B[14]))&(~(HALF_2));
	PP[14][12] = (A[12])&(B[14]);
	PP[14][13] = (A[13])&(B[14]);
	PP[14][14] = (A[14])&(B[14]);
	PP[14][15] = (A[15])&(B[14]);
	PP[14][16] = ~((((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_0)&(HALF_2)))&(B[14]));
	PP[15][0] = (((A[0])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][1] = (((A[1])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][2] = (((A[2])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][3] = (((A[3])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][4] = (((A[4])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][5] = (((A[5])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][6] = (((A[6])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][7] = (((A[7])&(B[15]))&(~(HALF_1)))&(~(HALF_2));
	PP[15][8] = ((A[8])&(B[15]))&(~(HALF_2));
	PP[15][9] = ((A[9])&(B[15]))&(~(HALF_2));
	PP[15][10] = ((A[10])&(B[15]))&(~(HALF_2));
	PP[15][11] = ((A[11])&(B[15]))&(~(HALF_2));
	PP[15][12] = (A[12])&(B[15]);
	PP[15][13] = (A[13])&(B[15]);
	PP[15][14] = (A[14])&(B[15]);
	PP[15][15] = (A[15])&(B[15]);
	PP[15][16] = ~((((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((A_extended_level2_0)&(HALF_2)))&(B[15]));
	PP[16][0] = ((~((A[0])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][1] = ((~((A[1])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][2] = ((~((A[2])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][3] = ((~((A[3])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][4] = ((~((A[4])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][5] = ((~((A[5])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][6] = ((~((A[6])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][7] = ((~((A[7])&(B_extended_level0_0)))&(~(HALF_1)))&(~(HALF_2));
	PP[16][8] = (~((A[8])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))))&(~(HALF_2));
	PP[16][9] = (~((A[9])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))))&(~(HALF_2));
	PP[16][10] = (~((A[10])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))))&(~(HALF_2));
	PP[16][11] = (~((A[11])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))))&(~(HALF_2));
	PP[16][12] = ~((A[12])&(((((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_0)&(HALF_2))));
	PP[16][13] = ~((A[13])&(((((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_0)&(HALF_2))));
	PP[16][14] = ~((A[14])&(((((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_0)&(HALF_2))));
	PP[16][15] = ~((A[15])&(((((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1)))&(~(HALF_2)))|((B_extended_level2_0)&(HALF_2))));
	PP[16][16] = (A_extended_level0_0)&(B_extended_level0_0);
end

// sum of PPs
integer j;
integer i_0;
integer i_1;
integer i_2;
integer i_3;

wire [32:0] Baugh_Wooley_0;
assign Baugh_Wooley_0 = {{1'b0},{1'b0},{1'b0},{(HALF_2)|(1'b0)},{1'b0},{1'b0},{1'b0},{(HALF_1)|(1'b0)},{1'b0},{1'b0},{1'b0},{(HALF_2)|(1'b0)},{1'b0},{1'b0},{1'b0},{(HALF_0)|(1'b0)},{1'b0},{1'b0},{1'b0},{(HALF_2)|(1'b0)},{1'b0},{1'b0},{1'b0},{(HALF_1)|(1'b0)},{1'b0},{1'b0},{1'b0},{(HALF_2)|(1'b0)},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0}};
wire [32:0] Baugh_Wooley_1;
assign Baugh_Wooley_1 = {{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0}};

reg [32:0] PP_temp [16:0];
always @(*) begin
	for (j = 0; j < (B_chop_size +1); j = j + 1 ) begin
		PP_temp[j] = 33'b0 ;
	end
	for (j = 0; j < (B_chop_size +1); j = j + 1 ) begin
		PP_temp[j] = (PP[j] << j);
	end
end

reg [31:0] C_temp;
always @(*) begin

	C_temp = 32'b0;

	for (i_0 = 0; i_0 < (B_chop_size +1); i_0 = i_0 + 1 ) begin
		C_temp[31:0] = C_temp[31:0] + (PP_temp[i_0][7:0]);
	end
	C_temp[31:0] = C_temp[31:0] + Baugh_Wooley_0[7:0];
	C_temp[31:0] = C_temp[31:0] + Baugh_Wooley_1[7:0];
	C_temp = C_temp & {{24{~(HALF_2)}},{8{1'b1}}};

	for (i_1 = 0; i_1 < (B_chop_size +1); i_1 = i_1 + 1 ) begin
		C_temp[31:8] = C_temp[31:8] + (PP_temp[i_1][15:8]);
	end
	C_temp[31:8] = C_temp[31:8] + Baugh_Wooley_0[15:8];
	C_temp[31:8] = C_temp[31:8] + Baugh_Wooley_1[15:8];
	C_temp = C_temp & {{16{~((HALF_1)|(HALF_2))}},{16{1'b1}}};

	for (i_2 = 0; i_2 < (B_chop_size +1); i_2 = i_2 + 1 ) begin
		C_temp[31:16] = C_temp[31:16] + (PP_temp[i_2][23:16]);
	end
	C_temp[31:16] = C_temp[31:16] + Baugh_Wooley_0[23:16];
	C_temp[31:16] = C_temp[31:16] + Baugh_Wooley_1[23:16];
	C_temp = C_temp & {{8{~(HALF_2)}},{24{1'b1}}};

	for (i_3 = 0; i_3 < (B_chop_size +1); i_3 = i_3 + 1 ) begin
		C_temp[31:24] = C_temp[31:24] + (PP_temp[i_3][31:24]);
	end
	C_temp[31:24] = C_temp[31:24] + Baugh_Wooley_0[31:24];
	C_temp[31:24] = C_temp[31:24] + Baugh_Wooley_1[31:24];
	C_temp = C_temp & {{0{~(((HALF_0)|(HALF_1))|(HALF_2))}},{32{1'b1}}};

end

assign C = C_temp[31:0];

endmodule
