`timescale 1 ns / 100 ps  
module multiplier_S_C2x2_F0_8bits_8bits_HighLevelDescribed_auto(
		input [A_chop_size-1:0] A,
		input [B_chop_size-1:0] B,

		input A_sign,
		input B_sign,

		input HALF_0,	// a selector bit to switch computation to half mode level 0

		output [A_chop_size+B_chop_size-1:0] C
	);

parameter A_chop_size = 8;
parameter B_chop_size = 8;

// to support both signed and unsigned multiplication
// sign extension regarding extra sign identifier
wire A_extended_level0_0;
wire B_extended_level0_0;
assign A_extended_level0_0 = (A[7])&(A_sign);
assign B_extended_level0_0 = (B[7])&(B_sign);


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
	PP[0][8] = ~((A_extended_level0_0)&(B[0]));
	PP[1][0] = (A[0])&(B[1]);
	PP[1][1] = (A[1])&(B[1]);
	PP[1][2] = (A[2])&(B[1]);
	PP[1][3] = (A[3])&(B[1]);
	PP[1][4] = (A[4])&(B[1]);
	PP[1][5] = (A[5])&(B[1]);
	PP[1][6] = (A[6])&(B[1]);
	PP[1][7] = (A[7])&(B[1]);
	PP[1][8] = ~((A_extended_level0_0)&(B[1]));
	PP[2][0] = (A[0])&(B[2]);
	PP[2][1] = (A[1])&(B[2]);
	PP[2][2] = (A[2])&(B[2]);
	PP[2][3] = (A[3])&(B[2]);
	PP[2][4] = (A[4])&(B[2]);
	PP[2][5] = (A[5])&(B[2]);
	PP[2][6] = (A[6])&(B[2]);
	PP[2][7] = (A[7])&(B[2]);
	PP[2][8] = ~((A_extended_level0_0)&(B[2]));
	PP[3][0] = (A[0])&(B[3]);
	PP[3][1] = (A[1])&(B[3]);
	PP[3][2] = (A[2])&(B[3]);
	PP[3][3] = (A[3])&(B[3]);
	PP[3][4] = (A[4])&(B[3]);
	PP[3][5] = (A[5])&(B[3]);
	PP[3][6] = (A[6])&(B[3]);
	PP[3][7] = (A[7])&(B[3]);
	PP[3][8] = ~((A_extended_level0_0)&(B[3]));
	PP[4][0] = (A[0])&(B[4]);
	PP[4][1] = (A[1])&(B[4]);
	PP[4][2] = (A[2])&(B[4]);
	PP[4][3] = (A[3])&(B[4]);
	PP[4][4] = (A[4])&(B[4]);
	PP[4][5] = (A[5])&(B[4]);
	PP[4][6] = (A[6])&(B[4]);
	PP[4][7] = (A[7])&(B[4]);
	PP[4][8] = ~((A_extended_level0_0)&(B[4]));
	PP[5][0] = (A[0])&(B[5]);
	PP[5][1] = (A[1])&(B[5]);
	PP[5][2] = (A[2])&(B[5]);
	PP[5][3] = (A[3])&(B[5]);
	PP[5][4] = (A[4])&(B[5]);
	PP[5][5] = (A[5])&(B[5]);
	PP[5][6] = (A[6])&(B[5]);
	PP[5][7] = (A[7])&(B[5]);
	PP[5][8] = ~((A_extended_level0_0)&(B[5]));
	PP[6][0] = (A[0])&(B[6]);
	PP[6][1] = (A[1])&(B[6]);
	PP[6][2] = (A[2])&(B[6]);
	PP[6][3] = (A[3])&(B[6]);
	PP[6][4] = (A[4])&(B[6]);
	PP[6][5] = (A[5])&(B[6]);
	PP[6][6] = (A[6])&(B[6]);
	PP[6][7] = (A[7])&(B[6]);
	PP[6][8] = ~((A_extended_level0_0)&(B[6]));
	PP[7][0] = (A[0])&(B[7]);
	PP[7][1] = (A[1])&(B[7]);
	PP[7][2] = (A[2])&(B[7]);
	PP[7][3] = (A[3])&(B[7]);
	PP[7][4] = (A[4])&(B[7]);
	PP[7][5] = (A[5])&(B[7]);
	PP[7][6] = (A[6])&(B[7]);
	PP[7][7] = (A[7])&(B[7]);
	PP[7][8] = ~((A_extended_level0_0)&(B[7]));
	PP[8][0] = ~((A[0])&(B_extended_level0_0));
	PP[8][1] = ~((A[1])&(B_extended_level0_0));
	PP[8][2] = ~((A[2])&(B_extended_level0_0));
	PP[8][3] = ~((A[3])&(B_extended_level0_0));
	PP[8][4] = ~((A[4])&(B_extended_level0_0));
	PP[8][5] = ~((A[5])&(B_extended_level0_0));
	PP[8][6] = ~((A[6])&(B_extended_level0_0));
	PP[8][7] = ~((A[7])&(B_extended_level0_0));
	PP[8][8] = (A_extended_level0_0)&(B_extended_level0_0);
end

// sum of PPs
integer j;
integer i_0;

wire [16:0] Baugh_Wooley_0;
assign Baugh_Wooley_0 = {{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{(HALF_0)|(1'b0)},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0},{1'b0}};
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

reg [15:0] C_temp;
always @(*) begin

	C_temp = 16'b0;

	for (i_0 = 0; i_0 < (B_chop_size +1); i_0 = i_0 + 1 ) begin
		C_temp[15:0] = C_temp[15:0] + (PP_temp[i_0][15:0]);
	end
	C_temp[15:0] = C_temp[15:0] + Baugh_Wooley_0[15:0];
	C_temp[15:0] = C_temp[15:0] + Baugh_Wooley_1[15:0];
	C_temp = C_temp & {{0{~(HALF_0)}},{16{1'b1}}};

end

assign C = C_temp[15:0];

endmodule
