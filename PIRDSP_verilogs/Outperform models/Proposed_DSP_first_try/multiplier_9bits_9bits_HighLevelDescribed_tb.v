`timescale 1 ns / 100 ps   
module multiplier_9bits_9bits_HighLevelDescribed_tb ();

	parameter A_width = 9;		// this parameter should be an odd number
	parameter B_width = 9;		// this parameter should be an odd number
	
	integer counter;
	integer Error_counter;
	parameter test_max_counter = 10000; 
	
	
	
	reg signed [A_width-1:0] A;
	reg signed [B_width-1:0] B;
	
	reg A_sign;
	reg B_sign;
	
	reg HALF;
	
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
		
		// check signed mult 9x9
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			A = $random;
			B = $random;
			
			A_sign = 1'b1;
			B_sign = 1'b1;
			
			HALF = 1'b0;
			
			@(posedge clk);
			#1
			if  (A * B != C) begin
				$display("Error: \tA = %d, B = %d, C = %d", A, B, C);
				Error_counter = Error_counter + 1;
			end 
		end 	
		
		// check unsigned mult 9x9
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			A = $random;
			B = $random;
			
			A_sign = 1'b0;
			B_sign = 1'b0;
			
			HALF = 1'b0;
			
			@(posedge clk);
			#1
			if  ($unsigned(A) * $unsigned(B) != $unsigned(C)) begin
				$display("Error: \tA = %d, B = %d, C = %d", $unsigned(A), $unsigned(B), $unsigned(C));
				Error_counter = Error_counter + 1;
			end 
		end 
		
		
		// check signed mult 4x4
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			A = $random;
			B = $random;
			
			A_sign = 1'b1;
			B_sign = 1'b1;
			
			HALF = 1'b1;
			
			@(posedge clk);
			#1
			
			if  ($signed(A[3:0]) * $signed(B[3:0]) != $signed(C[7:0])) begin
				$display("Error: \tA1 = %d, B1 = %d, C = %d", $signed(A[3:0]), $signed(B[3:0]), $signed(C[7:0]));
				Error_counter = Error_counter + 1;
			end 
			if  ($signed(A[8:5]) * $signed(B[8:5]) != $signed(C[17:10])) begin
				$display("Error: \tA1 = %d, B1 = %d, C = %d", $signed(A[8:5]), $signed(B[8:5]), $signed(C[17:10]));
				Error_counter = Error_counter + 1;
			end 
		end  
		
		// check unsigned mult 4x4
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			A = $random;
			B = $random;
			
			A_sign = 1'b0;
			B_sign = 1'b0;
			
			HALF = 1'b1;
			
			@(posedge clk);
			#1
			
			if  ($unsigned(A[3:0]) * $unsigned(B[3:0]) != $unsigned(C[7:0])) begin
				$display("Error: \tA1 = %d, B1 = %d, C = %d", $unsigned(A[3:0]), $unsigned(B[3:0]), $unsigned(C[7:0]));
				Error_counter = Error_counter + 1;
			end 
			if  ($unsigned(A[8:5]) * $unsigned(B[8:5]) != $unsigned(C[17:10])) begin
				$display("Error: \tA1 = %d, B1 = %d, C = %d", $unsigned(A[8:5]), $unsigned(B[8:5]), $unsigned(C[17:10]));
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
	
	multiplier_9bits_9bits_HighLevelDescribed			multiplier_9bits_9bits_HighLevelDescribed_inst(
		.A(A),
		.B(B),
		
		.A_sign(A_sign),
		.B_sign(B_sign),
		
		.HALF(HALF),
		
		.C(C)
	);
	
endmodule 
