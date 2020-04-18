`timescale 1 ns / 100 ps  
module multiplier_T_C2x1_F1_16bits_4bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 100;

// functionality modes 
parameter mode_16x4	= 2'b00;
parameter mode_sum_8x4	= 2'b1;
parameter mode_sum_4x2	= 2'b10;
reg [2:0] mode;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [15:0] a;
reg [7:0] b;

reg a_sign;
reg b_sign;

wire signed [19:0] result_0;
wire signed [19:0] result_1;

wire [1:0] result_SIDM_carry;
reg [1:0] temp_SIDM_carry;

reg signed [19:0] result;
reg signed [19:0] result_ideal;

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

	// check unsigned/unsigned mult 16x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		b = $random;
		b[15:4] = {12{1'b0}};

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_16x4;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check unsigned/signed mult 16x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		b = $random;
		b[15:4] = {12{b[3]}};

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_16x4;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{b[3]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/unsigned mult 16x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		b = $random;
		b[15:4] = {12{1'b0}};

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_16x4;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[15]},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/signed mult 16x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		b = $random;
		b[15:4] = {12{b[3]}};

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_16x4;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[15]},{a}}) * $signed({{b[3]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned/unsigned/ mult 8x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_8x4;

		#1
		{{temp_SIDM_carry[1:1]},{result [19:0]}} = {{result_SIDM_carry[1:1]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{1'b0},{a[15:8]}})*$signed({{1'b0},{b[7:4]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 8x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_8x4;

		#1
		{{temp_SIDM_carry[1:1]},{result [19:0]}} = {{result_SIDM_carry[1:1]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{1'b0},{a[15:8]}})*$signed({{b[7]},{b[7:4]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 8x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_8x4;

		#1
		{{temp_SIDM_carry[1:1]},{result [19:0]}} = {{result_SIDM_carry[1:1]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{a[15]},{a[15:8]}})*$signed({{1'b0},{b[7:4]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 8x4
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_8x4;

		#1
		{{temp_SIDM_carry[1:1]},{result [19:0]}} = {{result_SIDM_carry[1:1]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{a[15]},{a[15:8]}})*$signed({{b[7]},{b[7:4]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/unsigned/ mult 4x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_4x2;

		#1
		{{temp_SIDM_carry[0:0]},{result [13:0]}} = {{result_SIDM_carry[0:0]},{result_0 [13:0]}} + {{2'b00},{result_1 [13:0]}};
		{{temp_SIDM_carry[1:1]},{result [19:14]}} = {{result_SIDM_carry[1:1]},{result_0 [19:14]}} + {{2'b00},{result_1 [19:14]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{1'b0},{a[11:8]}})*$signed({{1'b0},{b[5:4]}});
		if  ({{temp_SIDM_carry[0:0]},{result[13:8]}} != result_ideal[6:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[7:4]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{1'b0},{a[15:12]}})*$signed({{1'b0},{b[7:6]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:14]}} != result_ideal[6:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 4x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_4x2;

		#1
		{{temp_SIDM_carry[0:0]},{result [13:0]}} = {{result_SIDM_carry[0:0]},{result_0 [13:0]}} + {{2'b00},{result_1 [13:0]}};
		{{temp_SIDM_carry[1:1]},{result [19:14]}} = {{result_SIDM_carry[1:1]},{result_0 [19:14]}} + {{2'b00},{result_1 [19:14]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{1'b0},{a[11:8]}})*$signed({{b[5]},{b[5:4]}});
		if  ({{temp_SIDM_carry[0:0]},{result[13:8]}} != result_ideal[6:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[7:4]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{1'b0},{a[15:12]}})*$signed({{b[7]},{b[7:6]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:14]}} != result_ideal[6:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 4x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_4x2;

		#1
		{{temp_SIDM_carry[0:0]},{result [13:0]}} = {{result_SIDM_carry[0:0]},{result_0 [13:0]}} + {{2'b00},{result_1 [13:0]}};
		{{temp_SIDM_carry[1:1]},{result [19:14]}} = {{result_SIDM_carry[1:1]},{result_0 [19:14]}} + {{2'b00},{result_1 [19:14]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{a[11]},{a[11:8]}})*$signed({{1'b0},{b[5:4]}});
		if  ({{temp_SIDM_carry[0:0]},{result[13:8]}} != result_ideal[6:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[7]},{a[7:4]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{a[15]},{a[15:12]}})*$signed({{1'b0},{b[7:6]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:14]}} != result_ideal[6:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 4x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_4x2;

		#1
		{{temp_SIDM_carry[0:0]},{result [13:0]}} = {{result_SIDM_carry[0:0]},{result_0 [13:0]}} + {{2'b00},{result_1 [13:0]}};
		{{temp_SIDM_carry[1:1]},{result [19:14]}} = {{result_SIDM_carry[1:1]},{result_0 [19:14]}} + {{2'b00},{result_1 [19:14]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{a[11]},{a[11:8]}})*$signed({{b[5]},{b[5:4]}});
		if  ({{temp_SIDM_carry[0:0]},{result[13:8]}} != result_ideal[6:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[7]},{a[7:4]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{a[15]},{a[15:12]}})*$signed({{b[7]},{b[7:6]}});
		if  ({{temp_SIDM_carry[1:1]},{result[19:14]}} != result_ideal[6:0]) begin
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

multiplier_T_C2x1_F1_16bits_4bits_HighLevelDescribed_auto	multiplier_T_C2x1_F1_16bits_4bits_HighLevelDescribed_auto_inst(
	.a(a),
	.b(b),

	.a_sign(a_sign),
	.b_sign(b_sign),

	.mode(mode),

	.result_0(result_0),
	.result_1(result_1),
	.result_SIDM_carry(result_SIDM_carry)
);

endmodule
