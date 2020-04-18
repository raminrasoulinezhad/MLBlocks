`timescale 1 ns / 100 ps  
module multiplier_S_C3x2_F2_9bits_9bits_HighLevelDescribed_auto_tb();

parameter A_chop_size = 9;
parameter B_chop_size = 9;
parameter test_max_counter = 100;

integer counter, Error_counter;

reg signed [A_chop_size - 1:0]  A;
reg signed [B_chop_size - 1:0]  B;

reg A_sign;
reg B_sign;

reg  HALF_0;
reg  HALF_1;
reg  HALF_2;

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
		HALF_1 = 1'b0;
		HALF_2 = 1'b0;

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
		HALF_1 = 1'b0;
		HALF_2 = 1'b0;

		@(posedge clk);
		#1
		if  (($signed(A[8:0]) * $signed(B[8:0]) != $signed(C[17:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $signed(A[8:0]), $signed(B[8:0]), $signed(C[17:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned mult 4x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b0;
		B_sign = 1'b0;

		HALF_0 = 1'b0;
		HALF_1 = 1'b1;
		HALF_2 = 1'b0;

		@(posedge clk);
		#1
		if  (($unsigned(A[8:5]) * $unsigned(B[8:5]) != $unsigned(C[17:10]))||($unsigned(A[3:0]) * $unsigned(B[3:0]) != $unsigned(C[7:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $unsigned(A[8:5]), $unsigned(B[8:5]), $unsigned(C[17:10]));
			$display("Error: 	A1 = %b, B1 = %b, C1 = %b", $unsigned(A[3:0]), $unsigned(B[3:0]), $unsigned(C[7:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check signed mult 4x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b1;
		B_sign = 1'b1;

		HALF_0 = 1'b0;
		HALF_1 = 1'b1;
		HALF_2 = 1'b0;

		@(posedge clk);
		#1
		if  (($signed(A[8:5]) * $signed(B[8:5]) != $signed(C[17:10]))||($signed(A[3:0]) * $signed(B[3:0]) != $signed(C[7:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $signed(A[8:5]), $signed(B[8:5]), $signed(C[17:10]));
			$display("Error: 	A1 = %b, B1 = %b, C1 = %b", $signed(A[3:0]), $signed(B[3:0]), $signed(C[7:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned mult 2x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b0;
		B_sign = 1'b0;

		HALF_0 = 1'b0;
		HALF_1 = 1'b0;
		HALF_2 = 1'b1;

		@(posedge clk);
		#1
		if  (($unsigned(A[8:7]) * $unsigned(B[8:7]) != $unsigned(C[17:14]))||($unsigned(A[6:5]) * $unsigned(B[6:5]) != $unsigned(C[13:10]))||($unsigned(A[3:2]) * $unsigned(B[3:2]) != $unsigned(C[7:4]))||($unsigned(A[1:0]) * $unsigned(B[1:0]) != $unsigned(C[3:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $unsigned(A[8:7]), $unsigned(B[8:7]), $unsigned(C[17:14]));
			$display("Error: 	A1 = %b, B1 = %b, C1 = %b", $unsigned(A[6:5]), $unsigned(B[6:5]), $unsigned(C[13:10]));
			$display("Error: 	A2 = %b, B2 = %b, C2 = %b", $unsigned(A[3:2]), $unsigned(B[3:2]), $unsigned(C[7:4]));
			$display("Error: 	A3 = %b, B3 = %b, C3 = %b", $unsigned(A[1:0]), $unsigned(B[1:0]), $unsigned(C[3:0]));
			Error_counter = Error_counter + 1;
		end
	end


	// check signed mult 2x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		A = $random;
		B = $random;

		A_sign = 1'b1;
		B_sign = 1'b1;

		HALF_0 = 1'b0;
		HALF_1 = 1'b0;
		HALF_2 = 1'b1;

		@(posedge clk);
		#1
		if  (($signed(A[8:7]) * $signed(B[8:7]) != $signed(C[17:14]))||($signed(A[6:5]) * $signed(B[6:5]) != $signed(C[13:10]))||($signed(A[3:2]) * $signed(B[3:2]) != $signed(C[7:4]))||($signed(A[1:0]) * $signed(B[1:0]) != $signed(C[3:0]))) begin
			$display("Error: 	A0 = %b, B0 = %b, C0 = %b", $signed(A[8:7]), $signed(B[8:7]), $signed(C[17:14]));
			$display("Error: 	A1 = %b, B1 = %b, C1 = %b", $signed(A[6:5]), $signed(B[6:5]), $signed(C[13:10]));
			$display("Error: 	A2 = %b, B2 = %b, C2 = %b", $signed(A[3:2]), $signed(B[3:2]), $signed(C[7:4]));
			$display("Error: 	A3 = %b, B3 = %b, C3 = %b", $signed(A[1:0]), $signed(B[1:0]), $signed(C[3:0]));
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

multiplier_S_C3x2_F2_9bits_9bits_HighLevelDescribed_auto	multiplier_S_C3x2_F2_9bits_9bits_HighLevelDescribed_auto_inst(
	.A(A),
	.B(B),

	.A_sign(A_sign),
	.B_sign(B_sign),

	.HALF_0(HALF_0),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C)
);

endmodule
