`timescale 1 ns / 100 ps  
module multiplier_S_C1x2_F1_16bits_8bits_HighLevelDescribed_auto(
		input [A_chop_size-1:0] A,
		input [B_chop_size-1:0] B,

		input A_sign,
		input B_sign,

		input HALF_0,	// a selector bit to switch computation to half mode level 0
		input HALF_1,	// a selector bit to switch computation to half mode level 1

		output [A_chop_size+B_chop_size-1:0] C
	);

parameter A_chop_size = 16;
parameter B_chop_size = 8;

// to support both signed and unsigned multiplication
// sign extension regarding extra sign identifier
wire A_extended_level0_0;
wire B_extended_level0_0;
assign A_extended_level0_0 = (A[15])&(A_sign);
assign B_extended_level0_0 = (B[7])&(B_sign);

wire A_extended_level1_0;
wire B_extended_level1_0;
assign A_extended_level1_0 = (A[15])&(A_sign);
assign B_extended_level1_0 = (B[7])&(B_sign);
wire A_extended_level1_1;
wire B_extended_level1_1;
assign A_extended_level1_1 = (A[7])&(A_sign);
assign B_extended_level1_1 = (B[3])&(B_sign);


reg [A_chop_size:0] PP [B_chop_size:0];
always @(*) begin
	PP[0][0] = (A[0])&(B[0]);
	PP[0][1] = (A[1])&(B[0]);
	PP[0][2] = (A[2])&(B[0]);
	PP[0][3] = (A[3])&(B[0]);
	PP[0][4] = (A[4])&(B[0]);
	PP[0][5] = (A[5])&(B[0]);
	PP[0][6] = (A[6])&(B[0]);
	PP[0][7] = (A[7])&(B[0]);
	PP[0][8] = ((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[0]))^(HALF_1);
	PP[0][9] = ((A[9])&(B[0]))&(~(HALF_1));
	PP[0][10] = ((A[10])&(B[0]))&(~(HALF_1));
	PP[0][11] = ((A[11])&(B[0]))&(~(HALF_1));
	PP[0][12] = ((A[12])&(B[0]))&(~(HALF_1));
	PP[0][13] = ((A[13])&(B[0]))&(~(HALF_1));
	PP[0][14] = ((A[14])&(B[0]))&(~(HALF_1));
	PP[0][15] = ((A[15])&(B[0]))&(~(HALF_1));
	PP[0][16] = (~((A_extended_level0_0)&(B[0])))&(~(HALF_1));
	PP[1][0] = (A[0])&(B[1]);
	PP[1][1] = (A[1])&(B[1]);
	PP[1][2] = (A[2])&(B[1]);
	PP[1][3] = (A[3])&(B[1]);
	PP[1][4] = (A[4])&(B[1]);
	PP[1][5] = (A[5])&(B[1]);
	PP[1][6] = (A[6])&(B[1]);
	PP[1][7] = (A[7])&(B[1]);
	PP[1][8] = ((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[1]))^(HALF_1);
	PP[1][9] = ((A[9])&(B[1]))&(~(HALF_1));
	PP[1][10] = ((A[10])&(B[1]))&(~(HALF_1));
	PP[1][11] = ((A[11])&(B[1]))&(~(HALF_1));
	PP[1][12] = ((A[12])&(B[1]))&(~(HALF_1));
	PP[1][13] = ((A[13])&(B[1]))&(~(HALF_1));
	PP[1][14] = ((A[14])&(B[1]))&(~(HALF_1));
	PP[1][15] = ((A[15])&(B[1]))&(~(HALF_1));
	PP[1][16] = (~((A_extended_level0_0)&(B[1])))&(~(HALF_1));
	PP[2][0] = (A[0])&(B[2]);
	PP[2][1] = (A[1])&(B[2]);
	PP[2][2] = (A[2])&(B[2]);
	PP[2][3] = (A[3])&(B[2]);
	PP[2][4] = (A[4])&(B[2]);
	PP[2][5] = (A[5])&(B[2]);
	PP[2][6] = (A[6])&(B[2]);
	PP[2][7] = (A[7])&(B[2]);
	PP[2][8] = ((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[2]))^(HALF_1);
	PP[2][9] = ((A[9])&(B[2]))&(~(HALF_1));
	PP[2][10] = ((A[10])&(B[2]))&(~(HALF_1));
	PP[2][11] = ((A[11])&(B[2]))&(~(HALF_1));
	PP[2][12] = ((A[12])&(B[2]))&(~(HALF_1));
	PP[2][13] = ((A[13])&(B[2]))&(~(HALF_1));
	PP[2][14] = ((A[14])&(B[2]))&(~(HALF_1));
	PP[2][15] = ((A[15])&(B[2]))&(~(HALF_1));
	PP[2][16] = (~((A_extended_level0_0)&(B[2])))&(~(HALF_1));
	PP[3][0] = (A[0])&(B[3]);
	PP[3][1] = (A[1])&(B[3]);
	PP[3][2] = (A[2])&(B[3]);
	PP[3][3] = (A[3])&(B[3]);
	PP[3][4] = (A[4])&(B[3]);
	PP[3][5] = (A[5])&(B[3]);
	PP[3][6] = (A[6])&(B[3]);
	PP[3][7] = (A[7])&(B[3]);
	PP[3][8] = ((((A[8])&(~(HALF_1)))|((A_extended_level1_1)&(HALF_1)))&(B[3]))^(HALF_1);
	PP[3][9] = ((A[9])&(B[3]))&(~(HALF_1));
	PP[3][10] = ((A[10])&(B[3]))&(~(HALF_1));
	PP[3][11] = ((A[11])&(B[3]))&(~(HALF_1));
	PP[3][12] = ((A[12])&(B[3]))&(~(HALF_1));
	PP[3][13] = ((A[13])&(B[3]))&(~(HALF_1));
	PP[3][14] = ((A[14])&(B[3]))&(~(HALF_1));
	PP[3][15] = ((A[15])&(B[3]))&(~(HALF_1));
	PP[3][16] = (~((A_extended_level0_0)&(B[3])))&(~(HALF_1));
	PP[4][0] = ((A[0])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][1] = ((A[1])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][2] = ((A[2])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][3] = ((A[3])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][4] = ((A[4])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][5] = ((A[5])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][6] = ((A[6])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][7] = ((A[7])&(((B[4])&(~(HALF_1)))|((B_extended_level1_1)&(HALF_1))))^(HALF_1);
	PP[4][8] = (A[8])&(B[4]);
	PP[4][9] = (A[9])&(B[4]);
	PP[4][10] = (A[10])&(B[4]);
	PP[4][11] = (A[11])&(B[4]);
	PP[4][12] = (A[12])&(B[4]);
	PP[4][13] = (A[13])&(B[4]);
	PP[4][14] = (A[14])&(B[4]);
	PP[4][15] = (A[15])&(B[4]);
	PP[4][16] = ~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[4]));
	PP[5][0] = ((A[0])&(B[5]))&(~(HALF_1));
	PP[5][1] = ((A[1])&(B[5]))&(~(HALF_1));
	PP[5][2] = ((A[2])&(B[5]))&(~(HALF_1));
	PP[5][3] = ((A[3])&(B[5]))&(~(HALF_1));
	PP[5][4] = ((A[4])&(B[5]))&(~(HALF_1));
	PP[5][5] = ((A[5])&(B[5]))&(~(HALF_1));
	PP[5][6] = ((A[6])&(B[5]))&(~(HALF_1));
	PP[5][7] = ((A[7])&(B[5]))&(~(HALF_1));
	PP[5][8] = (A[8])&(B[5]);
	PP[5][9] = (A[9])&(B[5]);
	PP[5][10] = (A[10])&(B[5]);
	PP[5][11] = (A[11])&(B[5]);
	PP[5][12] = (A[12])&(B[5]);
	PP[5][13] = (A[13])&(B[5]);
	PP[5][14] = (A[14])&(B[5]);
	PP[5][15] = (A[15])&(B[5]);
	PP[5][16] = ~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[5]));
	PP[6][0] = ((A[0])&(B[6]))&(~(HALF_1));
	PP[6][1] = ((A[1])&(B[6]))&(~(HALF_1));
	PP[6][2] = ((A[2])&(B[6]))&(~(HALF_1));
	PP[6][3] = ((A[3])&(B[6]))&(~(HALF_1));
	PP[6][4] = ((A[4])&(B[6]))&(~(HALF_1));
	PP[6][5] = ((A[5])&(B[6]))&(~(HALF_1));
	PP[6][6] = ((A[6])&(B[6]))&(~(HALF_1));
	PP[6][7] = ((A[7])&(B[6]))&(~(HALF_1));
	PP[6][8] = (A[8])&(B[6]);
	PP[6][9] = (A[9])&(B[6]);
	PP[6][10] = (A[10])&(B[6]);
	PP[6][11] = (A[11])&(B[6]);
	PP[6][12] = (A[12])&(B[6]);
	PP[6][13] = (A[13])&(B[6]);
	PP[6][14] = (A[14])&(B[6]);
	PP[6][15] = (A[15])&(B[6]);
	PP[6][16] = ~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[6]));
	PP[7][0] = ((A[0])&(B[7]))&(~(HALF_1));
	PP[7][1] = ((A[1])&(B[7]))&(~(HALF_1));
	PP[7][2] = ((A[2])&(B[7]))&(~(HALF_1));
	PP[7][3] = ((A[3])&(B[7]))&(~(HALF_1));
	PP[7][4] = ((A[4])&(B[7]))&(~(HALF_1));
	PP[7][5] = ((A[5])&(B[7]))&(~(HALF_1));
	PP[7][6] = ((A[6])&(B[7]))&(~(HALF_1));
	PP[7][7] = ((A[7])&(B[7]))&(~(HALF_1));
	PP[7][8] = (A[8])&(B[7]);
	PP[7][9] = (A[9])&(B[7]);
	PP[7][10] = (A[10])&(B[7]);
	PP[7][11] = (A[11])&(B[7]);
	PP[7][12] = (A[12])&(B[7]);
	PP[7][13] = (A[13])&(B[7]);
	PP[7][14] = (A[14])&(B[7]);
	PP[7][15] = (A[15])&(B[7]);
	PP[7][16] = ~((((A_extended_level0_0)&(~(HALF_1)))|((A_extended_level1_0)&(HALF_1)))&(B[7]));
	PP[8][0] = (~((A[0])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][1] = (~((A[1])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][2] = (~((A[2])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][3] = (~((A[3])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][4] = (~((A[4])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][5] = (~((A[5])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][6] = (~((A[6])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][7] = (~((A[7])&(B_extended_level0_0)))&(~(HALF_1));
	PP[8][8] = ~((A[8])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][9] = ~((A[9])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][10] = ~((A[10])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][11] = ~((A[11])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][12] = ~((A[12])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][13] = ~((A[13])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][14] = ~((A[14])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][15] = ~((A[15])&(((B_extended_level0_0)&(~(HALF_1)))|((B_extended_level1_0)&(HALF_1))));
	PP[8][16] = (A_extended_level0_0)&(B_extended_level0_0);
end

// sum of PPs
integer j;
integer i_0;
integer i_1;

wire [24:0] Baugh_Wooley_0;
assign Baugh_Wooley_0 = {{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{(HALF_1)|(1'b0)},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{(HALF_0)|(1'b0)},{1'b0},{1'b0},{1'b0},{(HALF_1)|(1'b0)},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0}};
wire [24:0] Baugh_Wooley_1;
assign Baugh_Wooley_1 = {{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{(1'b0)|(HALF_1)},{(1'b0)|(HALF_1)},{(1'b0)|(HALF_1)},{(1'b0)|(HALF_1)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_0)},{(1'b0)|(HALF_1)},{(1'b0)|(HALF_1)},{(1'b0)|(HALF_1)},{(1'b0)|(HALF_1)},{1'b0},{1'b0},{1'b0},{1'b0}};

reg [24:0] PP_temp [8:0];
always @(*) begin
	for (j = 0; j < (B_chop_size +1); j = j + 1 ) begin
		PP_temp[j] = 25'b0 ;
	end
	for (j = 0; j < (B_chop_size +1); j = j + 1 ) begin
		PP_temp[j] = (PP[j] << j);
	end
end

reg [23:0] C_temp;
always @(*) begin

	C_temp = 24'b0;

	for (i_0 = 0; i_0 < (B_chop_size +1); i_0 = i_0 + 1 ) begin
		C_temp[23:0] = C_temp[23:0] + (PP_temp[i_0][11:0]);
	end
	C_temp[23:0] = C_temp[23:0] + Baugh_Wooley_0[11:0];
	C_temp[23:0] = C_temp[23:0] + Baugh_Wooley_1[11:0];
	C_temp = C_temp & {{12{~(HALF_1)}},{12{1'b1}}};

	for (i_1 = 0; i_1 < (B_chop_size +1); i_1 = i_1 + 1 ) begin
		C_temp[23:12] = C_temp[23:12] + (PP_temp[i_1][23:12]);
	end
	C_temp[23:12] = C_temp[23:12] + Baugh_Wooley_0[23:12];
	C_temp[23:12] = C_temp[23:12] + Baugh_Wooley_1[23:12];
	C_temp = C_temp & {{0{~((HALF_0)|(HALF_1))}},{24{1'b1}}};

end

assign C = C_temp[23:0];

endmodule
