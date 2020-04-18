`timescale 1 ns / 100 ps  
module multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_tb();

parameter A_chop_size = 9;
parameter B_chop_size = 9;
parameter test_max_counter = 10000;

integer counter, Error_counter;

reg signed [A_chop_size - 1:0]  A;
reg signed [B_chop_size - 1:0]  B;

reg A_sign;
reg B_sign;

reg  HALF_0;

wire signed [17:0] C;

reg clk;
initial begin
	clk = 0;
	forever #5 clk= ~clk;
end

initial begin
	Error_counter = 0;
	@(posedge clk);
	@(posedge clk);

	// check unsigned mult 9x9
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b0;
		B_sign = 1'b0;

		HALF_0 = 1'b1;

		@(posedge clk);
		#1
		if  (($unsigned(A[8:0]) * $unsigned(B[8:0]) != $unsigned(C[17:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $unsigned(A[8:0]), $unsigned(B[8:0]), $unsigned(C[17:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check signed mult 9x9
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b1;
		B_sign = 1'b1;

		HALF_0 = 1'b1;

		@(posedge clk);
		#1
		if  (($signed(A[8:0]) * $signed(B[8:0]) != $signed(C[17:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $signed(A[8:0]), $signed(B[8:0]), $signed(C[17:0]));
			Error_counter = Error_counter + 1;
		end
	end



	$display(" ");
	if (Error_counter != 0)begin
		$display("--> Error: there was %d wrong answer", Error_counter);
	end else begin
		$display("--> Correct: there was no wrong answer :) ");
	end
	$display(" ");



	@(posedge clk);
	@(posedge clk);
	$finish();
end

multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto	multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_inst(
	.A(A),
	.B(B),

	.A_sign(A_sign),
	.B_sign(B_sign),

	.HALF_0(HALF_0),

	.C(C)
);

endmodule
