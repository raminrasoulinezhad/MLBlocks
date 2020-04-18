`timescale 1 ns / 100 ps  
module multiplier_T_C1x2_F1_16bits_16bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 100;

// functionality modes 
parameter mode_16x16	= 2'b00;
parameter mode_sum_16x8	= 2'b1;
parameter mode_sum_8x4	= 2'b10;
reg [2:0] mode;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [31:0] a;
reg [15:0] b;

reg a_sign;
reg b_sign;

wire signed [31:0] result_0;
wire signed [31:0] result_1;

wire [1:0] result_SIDM_carry;
reg [1:0] temp_SIDM_carry;

reg signed [31:0] result;
reg signed [31:0] result_ideal;

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

	// check unsigned/unsigned mult 16x16
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[31:16] = {16{1'b0}};
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_16x16;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check unsigned/signed mult 16x16
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[31:16] = {16{1'b0}};
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_16x16;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{b[15]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/unsigned mult 16x16
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[31:16] = {16{a[15]}};
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_16x16;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[15]},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/signed mult 16x16
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[31:16] = {16{a[15]}};
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_16x16;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[15]},{a}}) * $signed({{b[15]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned/unsigned/ mult 16x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_16x8;

		#1
		{{temp_SIDM_carry[1:1]},{result [31:0]}} = {{result_SIDM_carry[1:1]},{result_0 [31:0]}} + {{2'b00},{result_1 [31:0]}};

		result_ideal = $signed({{1'b0},{a[15:0]}})*$signed({{1'b0},{b[7:0]}}) + $signed({{1'b0},{a[31:16]}})*$signed({{1'b0},{b[15:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:8]}} != result_ideal[24:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 16x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_16x8;

		#1
		{{temp_SIDM_carry[1:1]},{result [31:0]}} = {{result_SIDM_carry[1:1]},{result_0 [31:0]}} + {{2'b00},{result_1 [31:0]}};

		result_ideal = $signed({{1'b0},{a[15:0]}})*$signed({{b[7]},{b[7:0]}}) + $signed({{1'b0},{a[31:16]}})*$signed({{b[15]},{b[15:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:8]}} != result_ideal[24:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 16x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_16x8;

		#1
		{{temp_SIDM_carry[1:1]},{result [31:0]}} = {{result_SIDM_carry[1:1]},{result_0 [31:0]}} + {{2'b00},{result_1 [31:0]}};

		result_ideal = $signed({{a[15]},{a[15:0]}})*$signed({{1'b0},{b[7:0]}}) + $signed({{a[31]},{a[31:16]}})*$signed({{1'b0},{b[15:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:8]}} != result_ideal[24:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 16x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_16x8;

		#1
		{{temp_SIDM_carry[1:1]},{result [31:0]}} = {{result_SIDM_carry[1:1]},{result_0 [31:0]}} + {{2'b00},{result_1 [31:0]}};

		result_ideal = $signed({{a[15]},{a[15:0]}})*$signed({{b[7]},{b[7:0]}}) + $signed({{a[31]},{a[31:16]}})*$signed({{b[15]},{b[15:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:8]}} != result_ideal[24:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [19:0]}} = {{result_SIDM_carry[0:0]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};
		{{temp_SIDM_carry[1:1]},{result [31:20]}} = {{result_SIDM_carry[1:1]},{result_0 [31:20]}} + {{2'b00},{result_1 [31:20]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{1'b0},{a[23:16]}})*$signed({{1'b0},{b[11:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[15:8]}})*$signed({{1'b0},{b[7:4]}}) + $signed({{1'b0},{a[31:24]}})*$signed({{1'b0},{b[15:12]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:20]}} != result_ideal[12:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [19:0]}} = {{result_SIDM_carry[0:0]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};
		{{temp_SIDM_carry[1:1]},{result [31:20]}} = {{result_SIDM_carry[1:1]},{result_0 [31:20]}} + {{2'b00},{result_1 [31:20]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{1'b0},{a[23:16]}})*$signed({{b[11]},{b[11:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[15:8]}})*$signed({{b[7]},{b[7:4]}}) + $signed({{1'b0},{a[31:24]}})*$signed({{b[15]},{b[15:12]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:20]}} != result_ideal[12:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [19:0]}} = {{result_SIDM_carry[0:0]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};
		{{temp_SIDM_carry[1:1]},{result [31:20]}} = {{result_SIDM_carry[1:1]},{result_0 [31:20]}} + {{2'b00},{result_1 [31:20]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{a[23]},{a[23:16]}})*$signed({{1'b0},{b[11:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[15]},{a[15:8]}})*$signed({{1'b0},{b[7:4]}}) + $signed({{a[31]},{a[31:24]}})*$signed({{1'b0},{b[15:12]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:20]}} != result_ideal[12:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [19:0]}} = {{result_SIDM_carry[0:0]},{result_0 [19:0]}} + {{2'b00},{result_1 [19:0]}};
		{{temp_SIDM_carry[1:1]},{result [31:20]}} = {{result_SIDM_carry[1:1]},{result_0 [31:20]}} + {{2'b00},{result_1 [31:20]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{a[23]},{a[23:16]}})*$signed({{b[11]},{b[11:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[19:8]}} != result_ideal[12:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[15]},{a[15:8]}})*$signed({{b[7]},{b[7:4]}}) + $signed({{a[31]},{a[31:24]}})*$signed({{b[15]},{b[15:12]}});
		if  ({{temp_SIDM_carry[1:1]},{result[31:20]}} != result_ideal[12:0]) begin
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

multiplier_T_C1x2_F1_16bits_16bits_HighLevelDescribed_auto	multiplier_T_C1x2_F1_16bits_16bits_HighLevelDescribed_auto_inst(
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
