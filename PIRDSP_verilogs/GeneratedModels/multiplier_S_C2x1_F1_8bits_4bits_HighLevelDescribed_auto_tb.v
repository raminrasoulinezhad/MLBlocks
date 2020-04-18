`timescale 1 ns / 100 ps  
module multiplier_S_C2x1_F1_8bits_4bits_HighLevelDescribed_auto_tb();

parameter A_chop_size = 8;
parameter B_chop_size = 4;
parameter test_max_counter = 100;

integer counter, Error_counter;

reg signed [A_chop_size - 1:0]  A;
reg signed [B_chop_size - 1:0]  B;

reg A_sign;
reg B_sign;

reg  HALF_0;
reg  HALF_1;

wire signed [11:0] C;

reg clk;
initial begin
	clk = 0;
	forever #5 clk= ~clk;
end

initial begin
	Error_counter = 0;
	@(posedge clk);
	@(posedge clk);

	// check unsigned mult 8x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b0;
		B_sign = 1'b0;

		HALF_0 = 1'b1;
		HALF_1 = 1'b0;

		@(posedge clk);
		#1
		if  (($unsigned(A[7:0]) * $unsigned(B[3:0]) != $unsigned(C[11:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $unsigned(A[7:0]), $unsigned(B[3:0]), $unsigned(C[11:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check signed mult 8x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b1;
		B_sign = 1'b1;

		HALF_0 = 1'b1;
		HALF_1 = 1'b0;

		@(posedge clk);
		#1
		if  (($signed(A[7:0]) * $signed(B[3:0]) != $signed(C[11:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $signed(A[7:0]), $signed(B[3:0]), $signed(C[11:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned mult 4x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b0;
		B_sign = 1'b0;

		HALF_0 = 1'b0;
		HALF_1 = 1'b1;

		@(posedge clk);
		#1
		if  (($unsigned(A[7:4]) * $unsigned(B[3:2]) != $unsigned(C[11:6]))||($unsigned(A[3:0]) * $unsigned(B[1:0]) != $unsigned(C[5:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $unsigned(A[7:4]), $unsigned(B[3:2]), $unsigned(C[11:6]));
			$display("Error: 	A1 = %b, B1 = %b, C1 = %b", $unsigned(A[3:0]), $unsigned(B[1:0]), $unsigned(C[5:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check signed mult 4x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b1;
		B_sign = 1'b1;

		HALF_0 = 1'b0;
		HALF_1 = 1'b1;

		@(posedge clk);
		#1
		if  (($signed(A[7:4]) * $signed(B[3:2]) != $signed(C[11:6]))||($signed(A[3:0]) * $signed(B[1:0]) != $signed(C[5:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $signed(A[7:4]), $signed(B[3:2]), $signed(C[11:6]));
			$display("Error: 	A1 = %b, B1 = %b, C1 = %b", $signed(A[3:0]), $signed(B[1:0]), $signed(C[5:0]));
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

multiplier_S_C2x1_F1_8bits_4bits_HighLevelDescribed_auto	multiplier_S_C2x1_F1_8bits_4bits_HighLevelDescribed_auto_inst(
	.A(A),
	.B(B),

	.A_sign(A_sign),
	.B_sign(B_sign),

	.HALF_0(HALF_0),
	.HALF_1(HALF_1),

	.C(C)
);

endmodule
