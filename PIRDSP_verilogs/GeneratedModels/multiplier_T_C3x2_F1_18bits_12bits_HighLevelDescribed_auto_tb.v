`timescale 1 ns / 100 ps  
module multiplier_T_C3x2_F1_18bits_12bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 100;

// functionality modes 
parameter mode_18x12	= 2'b00;
parameter mode_sum_6x6	= 2'b1;
parameter mode_sum_3x3	= 2'b10;
reg [2:0] mode;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [35:0] a;
reg [35:0] b;

reg a_sign;
reg b_sign;

wire signed [29:0] result_0;
wire signed [29:0] result_1;

wire [7:0] result_SIDM_carry;
reg [7:0] temp_SIDM_carry;

reg signed [29:0] result;
reg signed [29:0] result_ideal;

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

	// check unsigned/unsigned mult 18x12
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[35:18] = {18{1'b0}};
		b = $random;
		b[35:12] = {24{1'b0}};

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_18x12;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check unsigned/signed mult 18x12
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[35:18] = {18{1'b0}};
		b = $random;
		b[35:12] = {24{b[11]}};

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_18x12;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{b[11]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/unsigned mult 18x12
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[35:18] = {18{a[17]}};
		b = $random;
		b[35:12] = {24{1'b0}};

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_18x12;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[17]},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/signed mult 18x12
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[35:18] = {18{a[17]}};
		b = $random;
		b[35:12] = {24{b[11]}};

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_18x12;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[17]},{a}}) * $signed({{b[11]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned/unsigned/ mult 6x6
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_6x6;

		#1
		{{temp_SIDM_carry[3:2]},{result [17:0]}} = {{result_SIDM_carry[3:2]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIDM_carry[7:6]},{result [29:18]}} = {{result_SIDM_carry[7:6]},{result_0 [29:18]}} + {{2'b00},{result_1 [29:18]}};

		result_ideal = $signed({{1'b0},{a[5:0]}})*$signed({{1'b0},{b[5:0]}}) + $signed({{1'b0},{a[11:6]}})*$signed({{1'b0},{b[11:6]}}) + $signed({{1'b0},{a[17:12]}})*$signed({{1'b0},{b[17:12]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:6]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:18]}})*$signed({{1'b0},{b[23:18]}}) + $signed({{1'b0},{a[29:24]}})*$signed({{1'b0},{b[29:24]}}) + $signed({{1'b0},{a[35:30]}})*$signed({{1'b0},{b[35:30]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:18]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 6x6
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_6x6;

		#1
		{{temp_SIDM_carry[3:2]},{result [17:0]}} = {{result_SIDM_carry[3:2]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIDM_carry[7:6]},{result [29:18]}} = {{result_SIDM_carry[7:6]},{result_0 [29:18]}} + {{2'b00},{result_1 [29:18]}};

		result_ideal = $signed({{1'b0},{a[5:0]}})*$signed({{b[5]},{b[5:0]}}) + $signed({{1'b0},{a[11:6]}})*$signed({{b[11]},{b[11:6]}}) + $signed({{1'b0},{a[17:12]}})*$signed({{b[17]},{b[17:12]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:6]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:18]}})*$signed({{b[23]},{b[23:18]}}) + $signed({{1'b0},{a[29:24]}})*$signed({{b[29]},{b[29:24]}}) + $signed({{1'b0},{a[35:30]}})*$signed({{b[35]},{b[35:30]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:18]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 6x6
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_6x6;

		#1
		{{temp_SIDM_carry[3:2]},{result [17:0]}} = {{result_SIDM_carry[3:2]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIDM_carry[7:6]},{result [29:18]}} = {{result_SIDM_carry[7:6]},{result_0 [29:18]}} + {{2'b00},{result_1 [29:18]}};

		result_ideal = $signed({{a[5]},{a[5:0]}})*$signed({{1'b0},{b[5:0]}}) + $signed({{a[11]},{a[11:6]}})*$signed({{1'b0},{b[11:6]}}) + $signed({{a[17]},{a[17:12]}})*$signed({{1'b0},{b[17:12]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:6]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:18]}})*$signed({{1'b0},{b[23:18]}}) + $signed({{a[29]},{a[29:24]}})*$signed({{1'b0},{b[29:24]}}) + $signed({{a[35]},{a[35:30]}})*$signed({{1'b0},{b[35:30]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:18]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 6x6
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_6x6;

		#1
		{{temp_SIDM_carry[3:2]},{result [17:0]}} = {{result_SIDM_carry[3:2]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIDM_carry[7:6]},{result [29:18]}} = {{result_SIDM_carry[7:6]},{result_0 [29:18]}} + {{2'b00},{result_1 [29:18]}};

		result_ideal = $signed({{a[5]},{a[5:0]}})*$signed({{b[5]},{b[5:0]}}) + $signed({{a[11]},{a[11:6]}})*$signed({{b[11]},{b[11:6]}}) + $signed({{a[17]},{a[17:12]}})*$signed({{b[17]},{b[17:12]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:6]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:18]}})*$signed({{b[23]},{b[23:18]}}) + $signed({{a[29]},{a[29:24]}})*$signed({{b[29]},{b[29:24]}}) + $signed({{a[35]},{a[35:30]}})*$signed({{b[35]},{b[35:30]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:18]}} != result_ideal[13:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/unsigned/ mult 3x3
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_3x3;

		#1
		{{temp_SIDM_carry[1:0]},{result [11:0]}} = {{result_SIDM_carry[1:0]},{result_0 [11:0]}} + {{2'b00},{result_1 [11:0]}};
		{{temp_SIDM_carry[3:2]},{result [17:12]}} = {{result_SIDM_carry[3:2]},{result_0 [17:12]}} + {{2'b00},{result_1 [17:12]}};
		{{temp_SIDM_carry[5:4]},{result [23:18]}} = {{result_SIDM_carry[5:4]},{result_0 [23:18]}} + {{2'b00},{result_1 [23:18]}};
		{{temp_SIDM_carry[7:6]},{result [29:24]}} = {{result_SIDM_carry[7:6]},{result_0 [29:24]}} + {{2'b00},{result_1 [29:24]}};

		result_ideal = $signed({{1'b0},{a[2:0]}})*$signed({{1'b0},{b[2:0]}}) + $signed({{1'b0},{a[8:6]}})*$signed({{1'b0},{b[8:6]}}) + $signed({{1'b0},{a[14:12]}})*$signed({{1'b0},{b[14:12]}});
		if  ({{temp_SIDM_carry[1:0]},{result[11:6]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[5:3]}})*$signed({{1'b0},{b[5:3]}}) + $signed({{1'b0},{a[11:9]}})*$signed({{1'b0},{b[11:9]}}) + $signed({{1'b0},{a[17:15]}})*$signed({{1'b0},{b[17:15]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:12]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[20:18]}})*$signed({{1'b0},{b[20:18]}}) + $signed({{1'b0},{a[26:24]}})*$signed({{1'b0},{b[26:24]}}) + $signed({{1'b0},{a[32:30]}})*$signed({{1'b0},{b[32:30]}});
		if  ({{temp_SIDM_carry[5:4]},{result[23:18]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:21]}})*$signed({{1'b0},{b[23:21]}}) + $signed({{1'b0},{a[29:27]}})*$signed({{1'b0},{b[29:27]}}) + $signed({{1'b0},{a[35:33]}})*$signed({{1'b0},{b[35:33]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:24]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 3x3
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_3x3;

		#1
		{{temp_SIDM_carry[1:0]},{result [11:0]}} = {{result_SIDM_carry[1:0]},{result_0 [11:0]}} + {{2'b00},{result_1 [11:0]}};
		{{temp_SIDM_carry[3:2]},{result [17:12]}} = {{result_SIDM_carry[3:2]},{result_0 [17:12]}} + {{2'b00},{result_1 [17:12]}};
		{{temp_SIDM_carry[5:4]},{result [23:18]}} = {{result_SIDM_carry[5:4]},{result_0 [23:18]}} + {{2'b00},{result_1 [23:18]}};
		{{temp_SIDM_carry[7:6]},{result [29:24]}} = {{result_SIDM_carry[7:6]},{result_0 [29:24]}} + {{2'b00},{result_1 [29:24]}};

		result_ideal = $signed({{1'b0},{a[2:0]}})*$signed({{b[2]},{b[2:0]}}) + $signed({{1'b0},{a[8:6]}})*$signed({{b[8]},{b[8:6]}}) + $signed({{1'b0},{a[14:12]}})*$signed({{b[14]},{b[14:12]}});
		if  ({{temp_SIDM_carry[1:0]},{result[11:6]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[5:3]}})*$signed({{b[5]},{b[5:3]}}) + $signed({{1'b0},{a[11:9]}})*$signed({{b[11]},{b[11:9]}}) + $signed({{1'b0},{a[17:15]}})*$signed({{b[17]},{b[17:15]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:12]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[20:18]}})*$signed({{b[20]},{b[20:18]}}) + $signed({{1'b0},{a[26:24]}})*$signed({{b[26]},{b[26:24]}}) + $signed({{1'b0},{a[32:30]}})*$signed({{b[32]},{b[32:30]}});
		if  ({{temp_SIDM_carry[5:4]},{result[23:18]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:21]}})*$signed({{b[23]},{b[23:21]}}) + $signed({{1'b0},{a[29:27]}})*$signed({{b[29]},{b[29:27]}}) + $signed({{1'b0},{a[35:33]}})*$signed({{b[35]},{b[35:33]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:24]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 3x3
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_3x3;

		#1
		{{temp_SIDM_carry[1:0]},{result [11:0]}} = {{result_SIDM_carry[1:0]},{result_0 [11:0]}} + {{2'b00},{result_1 [11:0]}};
		{{temp_SIDM_carry[3:2]},{result [17:12]}} = {{result_SIDM_carry[3:2]},{result_0 [17:12]}} + {{2'b00},{result_1 [17:12]}};
		{{temp_SIDM_carry[5:4]},{result [23:18]}} = {{result_SIDM_carry[5:4]},{result_0 [23:18]}} + {{2'b00},{result_1 [23:18]}};
		{{temp_SIDM_carry[7:6]},{result [29:24]}} = {{result_SIDM_carry[7:6]},{result_0 [29:24]}} + {{2'b00},{result_1 [29:24]}};

		result_ideal = $signed({{a[2]},{a[2:0]}})*$signed({{1'b0},{b[2:0]}}) + $signed({{a[8]},{a[8:6]}})*$signed({{1'b0},{b[8:6]}}) + $signed({{a[14]},{a[14:12]}})*$signed({{1'b0},{b[14:12]}});
		if  ({{temp_SIDM_carry[1:0]},{result[11:6]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[5]},{a[5:3]}})*$signed({{1'b0},{b[5:3]}}) + $signed({{a[11]},{a[11:9]}})*$signed({{1'b0},{b[11:9]}}) + $signed({{a[17]},{a[17:15]}})*$signed({{1'b0},{b[17:15]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:12]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[20]},{a[20:18]}})*$signed({{1'b0},{b[20:18]}}) + $signed({{a[26]},{a[26:24]}})*$signed({{1'b0},{b[26:24]}}) + $signed({{a[32]},{a[32:30]}})*$signed({{1'b0},{b[32:30]}});
		if  ({{temp_SIDM_carry[5:4]},{result[23:18]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:21]}})*$signed({{1'b0},{b[23:21]}}) + $signed({{a[29]},{a[29:27]}})*$signed({{1'b0},{b[29:27]}}) + $signed({{a[35]},{a[35:33]}})*$signed({{1'b0},{b[35:33]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:24]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 3x3
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_3x3;

		#1
		{{temp_SIDM_carry[1:0]},{result [11:0]}} = {{result_SIDM_carry[1:0]},{result_0 [11:0]}} + {{2'b00},{result_1 [11:0]}};
		{{temp_SIDM_carry[3:2]},{result [17:12]}} = {{result_SIDM_carry[3:2]},{result_0 [17:12]}} + {{2'b00},{result_1 [17:12]}};
		{{temp_SIDM_carry[5:4]},{result [23:18]}} = {{result_SIDM_carry[5:4]},{result_0 [23:18]}} + {{2'b00},{result_1 [23:18]}};
		{{temp_SIDM_carry[7:6]},{result [29:24]}} = {{result_SIDM_carry[7:6]},{result_0 [29:24]}} + {{2'b00},{result_1 [29:24]}};

		result_ideal = $signed({{a[2]},{a[2:0]}})*$signed({{b[2]},{b[2:0]}}) + $signed({{a[8]},{a[8:6]}})*$signed({{b[8]},{b[8:6]}}) + $signed({{a[14]},{a[14:12]}})*$signed({{b[14]},{b[14:12]}});
		if  ({{temp_SIDM_carry[1:0]},{result[11:6]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[5]},{a[5:3]}})*$signed({{b[5]},{b[5:3]}}) + $signed({{a[11]},{a[11:9]}})*$signed({{b[11]},{b[11:9]}}) + $signed({{a[17]},{a[17:15]}})*$signed({{b[17]},{b[17:15]}});
		if  ({{temp_SIDM_carry[3:2]},{result[17:12]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[20]},{a[20:18]}})*$signed({{b[20]},{b[20:18]}}) + $signed({{a[26]},{a[26:24]}})*$signed({{b[26]},{b[26:24]}}) + $signed({{a[32]},{a[32:30]}})*$signed({{b[32]},{b[32:30]}});
		if  ({{temp_SIDM_carry[5:4]},{result[23:18]}} != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:21]}})*$signed({{b[23]},{b[23:21]}}) + $signed({{a[29]},{a[29:27]}})*$signed({{b[29]},{b[29:27]}}) + $signed({{a[35]},{a[35:33]}})*$signed({{b[35]},{b[35:33]}});
		if  ({{temp_SIDM_carry[7:6]},{result[29:24]}} != result_ideal[7:0]) begin
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

multiplier_T_C3x2_F1_18bits_12bits_HighLevelDescribed_auto	multiplier_T_C3x2_F1_18bits_12bits_HighLevelDescribed_auto_inst(
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
