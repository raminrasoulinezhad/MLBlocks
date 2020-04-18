`timescale 1 ns / 100 ps  
module multiplier_S_C3x3_F0_9bits_9bits_HighLevelDescribed_auto(
		input clk,
		input reset,

		input [A_chop_size-1:0] A,
		input [B_chop_size-1:0] B,

		input A_sign,
		input B_sign,

		input HALF_0,	// a selector bit to switch computation to half mode level 0

		output reg [A_chop_size+B_chop_size-1:0] C
	);

parameter A_chop_size = 9;
parameter B_chop_size = 9;

// to support both signed and unsigned multiplication
// sign extension regarding extra sign identifier
wire A_extended_level0_0;
wire B_extended_level0_0;
assign A_extended_level0_0 = (A[8])&(A_sign);
assign B_extended_level0_0 = (B[8])&(B_sign);


reg signed [A_chop_size+B_chop_size+1:0] C_temp;
always @ (*) begin
	 C_temp = $signed({{A_extended_level0_0},{A}}) * $signed({{B_extended_level0_0},{B}});
end

always @ (posedge clk) begin
	if(reset)
		C <= 0;
	else
		C <= C_temp[A_chop_size+B_chop_size-1:0];
end

endmodule
