`timescale 1 ns / 100 ps  
module ALU_SIMD_Width_baseline(

		W,
		Y,
		X,
		
		CIN_W_X_Y_CIN,

		S,

		COUT_W_X_Y_CIN
	);

//parameters
parameter Width = 8;
input [Width-1:0] W;
input [Width-1:0] Y;
input [Width-1:0] X;

input [1:0] CIN_W_X_Y_CIN;

output [Width-1:0] S;

output [1:0] COUT_W_X_Y_CIN;


//computations
wire [Width-1:0] temp_W_X_Y;
assign {{COUT_W_X_Y_CIN}, {temp_W_X_Y}} = W + X + Y + CIN_W_X_Y_CIN;

assign S = temp_W_X_Y;

endmodule
