module mult_flex (
		a,
		a_s,

		b,
		b_s,

		res
	);

	///////// Parameters
	parameter A_W = 8;
	parameter B_W = 8;

	///////// IOs
	input [A_W-1:0] a;
	input a_s;
	
	input [B_W-1:0] b;
	input b_s;

	output [A_W+B_W-1:0] res;

	///////// internal signals
	wire signed [A_W:0] a_ex;
	wire signed [B_W:0] b_ex;
	
	assign a_ex = {{(a[A_W-1] & a_s)},{a}};
	assign b_ex = {{(b[B_W-1] & b_s)},{b}};

	wire signed [A_W+B_W+1:0] res_temp;
	assign res_temp = a_ex * b_ex;

	assign res = res_temp[A_W+B_W-1:0];

endmodule 
