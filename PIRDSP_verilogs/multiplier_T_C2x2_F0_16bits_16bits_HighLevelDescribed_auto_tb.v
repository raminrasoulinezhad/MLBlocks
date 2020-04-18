`timescale 1 ns / 100 ps  
module multiplier_T_C2x2_F0_16bits_16bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 10000;

// functionality modes 
parameter mode_16x16	= 1'b00;
parameter mode_sum_8x8	= 1'b1;
reg [1:0] mode;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [31:0] a;
reg [31:0] b;

reg a_sign;
reg b_sign;

wire signed [31:0] result_0;
wire signed [31:0] result_1;

wire [1:0] result_SIMD_carry;
reg [1:0] temp_SIMD_carry;

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
		b[31:16] = {16{1'b0}};

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
		b[31:16] = {16{b[15]}};

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
		b[31:16] = {16{1'b0}};

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
		b[31:16] = {16{b[15]}};

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


	// check unsigned/unsigned/ mult 8x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_8x8;

		#1
		{{temp_SIMD_carry[0:0]},{result [15:0]}} = {{result_SIMD_carry[0:0]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIMD_carry[1:1]},{result [31:16]}} = {{result_SIMD_carry[1:1]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{1'b0},{b[7:0]}}) + $signed({{1'b0},{a[15:8]}})*$signed({{1'b0},{b[15:8]}});
		if  ({{temp_SIMD_carry[0:0]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:16]}})*$signed({{1'b0},{b[23:16]}}) + $signed({{1'b0},{a[31:24]}})*$signed({{1'b0},{b[31:24]}});
		if  ({{temp_SIMD_carry[1:1]},{result[31:16]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 8x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_8x8;

		#1
		{{temp_SIMD_carry[0:0]},{result [15:0]}} = {{result_SIMD_carry[0:0]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIMD_carry[1:1]},{result [31:16]}} = {{result_SIMD_carry[1:1]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{b[7]},{b[7:0]}}) + $signed({{1'b0},{a[15:8]}})*$signed({{b[15]},{b[15:8]}});
		if  ({{temp_SIMD_carry[0:0]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:16]}})*$signed({{b[23]},{b[23:16]}}) + $signed({{1'b0},{a[31:24]}})*$signed({{b[31]},{b[31:24]}});
		if  ({{temp_SIMD_carry[1:1]},{result[31:16]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 8x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_8x8;

		#1
		{{temp_SIMD_carry[0:0]},{result [15:0]}} = {{result_SIMD_carry[0:0]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIMD_carry[1:1]},{result [31:16]}} = {{result_SIMD_carry[1:1]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{1'b0},{b[7:0]}}) + $signed({{a[15]},{a[15:8]}})*$signed({{1'b0},{b[15:8]}});
		if  ({{temp_SIMD_carry[0:0]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:16]}})*$signed({{1'b0},{b[23:16]}}) + $signed({{a[31]},{a[31:24]}})*$signed({{1'b0},{b[31:24]}});
		if  ({{temp_SIMD_carry[1:1]},{result[31:16]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 8x8
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_8x8;

		#1
		{{temp_SIMD_carry[0:0]},{result [15:0]}} = {{result_SIMD_carry[0:0]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIMD_carry[1:1]},{result [31:16]}} = {{result_SIMD_carry[1:1]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{b[7]},{b[7:0]}}) + $signed({{a[15]},{a[15:8]}})*$signed({{b[15]},{b[15:8]}});
		if  ({{temp_SIMD_carry[0:0]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:16]}})*$signed({{b[23]},{b[23:16]}}) + $signed({{a[31]},{a[31:24]}})*$signed({{b[31]},{b[31:24]}});
		if  ({{temp_SIMD_carry[1:1]},{result[31:16]}} != result_ideal[16:0]) begin
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

multiplier_T_C2x2_F0_16bits_16bits_HighLevelDescribed_auto	multiplier_T_C2x2_F0_16bits_16bits_HighLevelDescribed_auto_inst(
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
