`timescale 1 ns / 100 ps  
module multiplier_T_C3x2_F1_27bits_18bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 10000;

// functionality modes 
parameter mode_27x18	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
reg [2:0] mode;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [53:0] a;
reg [53:0] b;

reg a_sign;
reg b_sign;

wire signed [44:0] result_0;
wire signed [44:0] result_1;

wire [7:0] result_SIMD_carry;
reg [7:0] temp_SIMD_carry;

reg signed [44:0] result;
reg signed [44:0] result_ideal;

/*******************************************************
*	Clock generator
*******************************************************/
reg clk;
initial begin
	clk = 0;
	forever #5 clk= ~clk;
end


initial begin
	Error_counter = 0;
	@(posedge clk);
	@(posedge clk);

	// check unsigned/unsigned mult 27x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[53:27] = {27{1'b0}};
		b = $random;
		b[53:18] = {36{1'b0}};

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_27x18;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check unsigned/signed mult 27x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[53:27] = {27{1'b0}};
		b = $random;
		b[53:18] = {36{b[17]}};

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_27x18;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{b[17]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/unsigned mult 27x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[53:27] = {27{a[26]}};
		b = $random;
		b[53:18] = {36{1'b0}};

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_27x18;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[26]},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/signed mult 27x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[53:27] = {27{a[26]}};
		b = $random;
		b[53:18] = {36{b[17]}};

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_27x18;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[26]},{a}}) * $signed({{b[17]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned/unsigned/ mult 9x9
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_9x9;

		#1
		{{temp_SIMD_carry[3:2]},{result [26:0]}} = {{result_SIMD_carry[3:2]},{result_0 [26:0]}} + {{2'b00},{result_1 [26:0]}};
		{{temp_SIMD_carry[7:6]},{result [44:27]}} = {{result_SIMD_carry[7:6]},{result_0 [44:27]}} + {{2'b00},{result_1 [44:27]}};

		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{1'b0},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{1'b0},{b[26:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:9]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{1'b0},{b[44:36]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:27]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 9x9
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_9x9;

		#1
		{{temp_SIMD_carry[3:2]},{result [26:0]}} = {{result_SIMD_carry[3:2]},{result_0 [26:0]}} + {{2'b00},{result_1 [26:0]}};
		{{temp_SIMD_carry[7:6]},{result [44:27]}} = {{result_SIMD_carry[7:6]},{result_0 [44:27]}} + {{2'b00},{result_1 [44:27]}};

		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{1'b0},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{b[26]},{b[26:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:9]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{b[44]},{b[44:36]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:27]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 9x9
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_9x9;

		#1
		{{temp_SIMD_carry[3:2]},{result [26:0]}} = {{result_SIMD_carry[3:2]},{result_0 [26:0]}} + {{2'b00},{result_1 [26:0]}};
		{{temp_SIMD_carry[7:6]},{result [44:27]}} = {{result_SIMD_carry[7:6]},{result_0 [44:27]}} + {{2'b00},{result_1 [44:27]}};

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{a[17]},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{1'b0},{b[26:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:9]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{1'b0},{b[44:36]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:27]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 9x9
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_9x9;

		#1
		{{temp_SIMD_carry[3:2]},{result [26:0]}} = {{result_SIMD_carry[3:2]},{result_0 [26:0]}} + {{2'b00},{result_1 [26:0]}};
		{{temp_SIMD_carry[7:6]},{result [44:27]}} = {{result_SIMD_carry[7:6]},{result_0 [44:27]}} + {{2'b00},{result_1 [44:27]}};

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{a[17]},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{b[26]},{b[26:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:9]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{b[44]},{b[44:36]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:27]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/unsigned/ mult 4x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_4x4;

		#1
		{{temp_SIMD_carry[1:0]},{result [16:0]}} = {{result_SIMD_carry[1:0]},{result_0 [16:0]}} + {{2'b00},{result_1 [16:0]}};
		{{temp_SIMD_carry[3:2]},{result [26:17]}} = {{result_SIMD_carry[3:2]},{result_0 [26:17]}} + {{2'b00},{result_1 [26:17]}};
		{{temp_SIMD_carry[5:4]},{result [34:27]}} = {{result_SIMD_carry[5:4]},{result_0 [34:27]}} + {{2'b00},{result_1 [34:27]}};
		{{temp_SIMD_carry[7:6]},{result [44:35]}} = {{result_SIMD_carry[7:6]},{result_0 [44:35]}} + {{2'b00},{result_1 [44:35]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{1'b0},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{1'b0},{b[21:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[16:9]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{1'b0},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{1'b0},{b[26:23]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:19]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{1'b0},{b[39:36]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  ({{temp_SIMD_carry[5:4]},{result[34:27]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{1'b0},{b[44:41]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:37]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 4x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_4x4;

		#1
		{{temp_SIMD_carry[1:0]},{result [16:0]}} = {{result_SIMD_carry[1:0]},{result_0 [16:0]}} + {{2'b00},{result_1 [16:0]}};
		{{temp_SIMD_carry[3:2]},{result [26:17]}} = {{result_SIMD_carry[3:2]},{result_0 [26:17]}} + {{2'b00},{result_1 [26:17]}};
		{{temp_SIMD_carry[5:4]},{result [34:27]}} = {{result_SIMD_carry[5:4]},{result_0 [34:27]}} + {{2'b00},{result_1 [34:27]}};
		{{temp_SIMD_carry[7:6]},{result [44:35]}} = {{result_SIMD_carry[7:6]},{result_0 [44:35]}} + {{2'b00},{result_1 [44:35]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{1'b0},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{b[21]},{b[21:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[16:9]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{1'b0},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{b[26]},{b[26:23]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:19]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{b[39]},{b[39:36]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  ({{temp_SIMD_carry[5:4]},{result[34:27]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{b[44]},{b[44:41]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:37]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 4x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_4x4;

		#1
		{{temp_SIMD_carry[1:0]},{result [16:0]}} = {{result_SIMD_carry[1:0]},{result_0 [16:0]}} + {{2'b00},{result_1 [16:0]}};
		{{temp_SIMD_carry[3:2]},{result [26:17]}} = {{result_SIMD_carry[3:2]},{result_0 [26:17]}} + {{2'b00},{result_1 [26:17]}};
		{{temp_SIMD_carry[5:4]},{result [34:27]}} = {{result_SIMD_carry[5:4]},{result_0 [34:27]}} + {{2'b00},{result_1 [34:27]}};
		{{temp_SIMD_carry[7:6]},{result [44:35]}} = {{result_SIMD_carry[7:6]},{result_0 [44:35]}} + {{2'b00},{result_1 [44:35]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{a[12]},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{1'b0},{b[21:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[16:9]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{a[17]},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{1'b0},{b[26:23]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:19]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{1'b0},{b[39:36]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  ({{temp_SIMD_carry[5:4]},{result[34:27]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{1'b0},{b[44:41]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:37]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 4x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_4x4;

		#1
		{{temp_SIMD_carry[1:0]},{result [16:0]}} = {{result_SIMD_carry[1:0]},{result_0 [16:0]}} + {{2'b00},{result_1 [16:0]}};
		{{temp_SIMD_carry[3:2]},{result [26:17]}} = {{result_SIMD_carry[3:2]},{result_0 [26:17]}} + {{2'b00},{result_1 [26:17]}};
		{{temp_SIMD_carry[5:4]},{result [34:27]}} = {{result_SIMD_carry[5:4]},{result_0 [34:27]}} + {{2'b00},{result_1 [34:27]}};
		{{temp_SIMD_carry[7:6]},{result [44:35]}} = {{result_SIMD_carry[7:6]},{result_0 [44:35]}} + {{2'b00},{result_1 [44:35]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{a[12]},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{b[21]},{b[21:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[16:9]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{a[17]},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{b[26]},{b[26:23]}});
		if  ({{temp_SIMD_carry[3:2]},{result[26:19]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{b[39]},{b[39:36]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  ({{temp_SIMD_carry[5:4]},{result[34:27]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{b[44]},{b[44:41]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  ({{temp_SIMD_carry[7:6]},{result[44:37]}} != result_ideal[9:0]) begin
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

multiplier_T_C3x2_F1_27bits_18bits_HighLevelDescribed_auto	multiplier_T_C3x2_F1_27bits_18bits_HighLevelDescribed_auto_inst(
	.a(a),
	.b(b),

	.a_sign(a_sign),
	.b_sign(b_sign),

	.mode(mode),

	.result_0(result_0),
	.result_1(result_1),
	.result_SIMD_carry(result_SIMD_carry)
);

endmodule
