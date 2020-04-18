`timescale 1 ns / 100 ps  
module ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb();

/*******************************************************
*	Clock generator
*******************************************************/
reg clk;
initial begin
	clk = 0;
	forever #5 clk= ~clk;
end


/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 10000;
parameter Width = 8;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [Width-1:0] W;
reg [Width-1:0] Z;
reg [Width-1:0] Y;
reg [Width-1:0] X;

reg [1:0] op;
reg Z_controller;
reg S_controller;
reg W_X_Y_controller;
reg [1:0] CIN_W_X_Y_CIN;
reg CIN_Z_W_X_Y_CIN;

wire [Width-1:0] S;

wire [1:0] COUT_W_X_Y_CIN;
wire COUT_Z_W_X_Y_CIN;

reg [1:0] result_SIMD_carry_in;
wire [1:0] result_SIMD_carry_out;

reg [Width+1:0] S_temp;
reg [1:0] carry_temp;
initial begin
	Error_counter = 0;
	op = 2'b0;
	Z_controller = 0;
	S_controller = 0;
	W_X_Y_controller = 0;
	CIN_W_X_Y_CIN = 2'b0;
	CIN_Z_W_X_Y_CIN = 0;
	result_SIMD_carry_in = 0;

	@(posedge clk);
	@(posedge clk);
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		W = $random;
		Z = $random;
		Y = $random;
		X = $random;

		#1
		S_temp = W + Z + X + Y;
		if  (S_temp[Width-1:0] != S ) begin
			Error_counter = Error_counter + 1;
		end

		carry_temp = COUT_W_X_Y_CIN + COUT_Z_W_X_Y_CIN;
		if  (S_temp[Width+1:Width] != carry_temp ) begin
			Error_counter = Error_counter + 1;
		end

	end
end
ALU_SIMD_Width_parameterized_HighLevelDescribed_auto ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_inst(
	.W(W),
	.Z(Z),
	.Y(Y),
	.X(X),

	.op(op),
	.Z_controller(Z_controller),
	.S_controller(S_controller),
	.W_X_Y_controller(W_X_Y_controller),
	.CIN_W_X_Y_CIN(CIN_W_X_Y_CIN),
	.CIN_Z_W_X_Y_CIN(CIN_Z_W_X_Y_CIN),
	
	.S(S),
	
	.COUT_W_X_Y_CIN(COUT_W_X_Y_CIN),
	.COUT_Z_W_X_Y_CIN(COUT_Z_W_X_Y_CIN),
	
	.result_SIMD_carry_in(result_SIMD_carry_in),
	.result_SIMD_carry_out(result_SIMD_carry_out)
);


endmodule
