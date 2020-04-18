`timescale 1 ns / 100 ps  
module multiplier_T_C3x3_F2_27bits_27bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 10000;

// functionality modes 
parameter mode_27x27	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
parameter mode_sum_2x2	= 2'b11;
reg [2:0] mode;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [80:0] a;
reg [80:0] b;

reg a_sign;
reg b_sign;

wire signed [53:0] result_0;
wire signed [53:0] result_1;

wire [23:0] result_SIMD_carry;
reg [23:0] temp_SIMD_carry;

reg signed [53:0] result;
reg signed [53:0] result_ideal;

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

	// check unsigned/unsigned mult 27x27
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[80:27] = {54{1'b0}};
		b = $random;
		b[80:27] = {54{1'b0}};

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_27x27;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check unsigned/signed mult 27x27
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[80:27] = {54{1'b0}};
		b = $random;
		b[80:27] = {54{b[26]}};

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_27x27;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{b[26]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/unsigned mult 27x27
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[80:27] = {54{a[26]}};
		b = $random;
		b[80:27] = {54{1'b0}};

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_27x27;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[26]},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/signed mult 27x27
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[80:27] = {54{a[26]}};
		b = $random;
		b[80:27] = {54{b[26]}};

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_27x27;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[26]},{a}}) * $signed({{b[26]},{b}});
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
		{{temp_SIMD_carry[7:6]},{result [17:0]}} = {{result_SIMD_carry[7:6]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIMD_carry[15:14]},{result [35:18]}} = {{result_SIMD_carry[15:14]},{result_0 [35:18]}} + {{2'b00},{result_1 [35:18]}};
		{{temp_SIMD_carry[23:22]},{result [53:36]}} = {{result_SIMD_carry[23:22]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};

		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{1'b0},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{1'b0},{b[26:18]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:0]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{1'b0},{b[44:36]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:54]}})*$signed({{1'b0},{b[62:54]}}) + $signed({{1'b0},{a[71:63]}})*$signed({{1'b0},{b[71:63]}}) + $signed({{1'b0},{a[80:72]}})*$signed({{1'b0},{b[80:72]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:36]}} != result_ideal[19:0]) begin
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
		{{temp_SIMD_carry[7:6]},{result [17:0]}} = {{result_SIMD_carry[7:6]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIMD_carry[15:14]},{result [35:18]}} = {{result_SIMD_carry[15:14]},{result_0 [35:18]}} + {{2'b00},{result_1 [35:18]}};
		{{temp_SIMD_carry[23:22]},{result [53:36]}} = {{result_SIMD_carry[23:22]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};

		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{1'b0},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{b[26]},{b[26:18]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:0]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{b[44]},{b[44:36]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:54]}})*$signed({{b[62]},{b[62:54]}}) + $signed({{1'b0},{a[71:63]}})*$signed({{b[71]},{b[71:63]}}) + $signed({{1'b0},{a[80:72]}})*$signed({{b[80]},{b[80:72]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:36]}} != result_ideal[19:0]) begin
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
		{{temp_SIMD_carry[7:6]},{result [17:0]}} = {{result_SIMD_carry[7:6]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIMD_carry[15:14]},{result [35:18]}} = {{result_SIMD_carry[15:14]},{result_0 [35:18]}} + {{2'b00},{result_1 [35:18]}};
		{{temp_SIMD_carry[23:22]},{result [53:36]}} = {{result_SIMD_carry[23:22]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{a[17]},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{1'b0},{b[26:18]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:0]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{1'b0},{b[44:36]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:54]}})*$signed({{1'b0},{b[62:54]}}) + $signed({{a[71]},{a[71:63]}})*$signed({{1'b0},{b[71:63]}}) + $signed({{a[80]},{a[80:72]}})*$signed({{1'b0},{b[80:72]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:36]}} != result_ideal[19:0]) begin
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
		{{temp_SIMD_carry[7:6]},{result [17:0]}} = {{result_SIMD_carry[7:6]},{result_0 [17:0]}} + {{2'b00},{result_1 [17:0]}};
		{{temp_SIMD_carry[15:14]},{result [35:18]}} = {{result_SIMD_carry[15:14]},{result_0 [35:18]}} + {{2'b00},{result_1 [35:18]}};
		{{temp_SIMD_carry[23:22]},{result [53:36]}} = {{result_SIMD_carry[23:22]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{a[17]},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{b[26]},{b[26:18]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:0]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{b[44]},{b[44:36]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:54]}})*$signed({{b[62]},{b[62:54]}}) + $signed({{a[71]},{a[71:63]}})*$signed({{b[71]},{b[71:63]}}) + $signed({{a[80]},{a[80:72]}})*$signed({{b[80]},{b[80:72]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:36]}} != result_ideal[19:0]) begin
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
		{{temp_SIMD_carry[3:2]},{result [7:0]}} = {{result_SIMD_carry[3:2]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIMD_carry[7:6]},{result [17:8]}} = {{result_SIMD_carry[7:6]},{result_0 [17:8]}} + {{2'b00},{result_1 [17:8]}};
		{{temp_SIMD_carry[11:10]},{result [25:18]}} = {{result_SIMD_carry[11:10]},{result_0 [25:18]}} + {{2'b00},{result_1 [25:18]}};
		{{temp_SIMD_carry[15:14]},{result [35:26]}} = {{result_SIMD_carry[15:14]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIMD_carry[19:18]},{result [43:36]}} = {{result_SIMD_carry[19:18]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIMD_carry[23:22]},{result [53:44]}} = {{result_SIMD_carry[23:22]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{1'b0},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{1'b0},{b[21:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:0]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{1'b0},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{1'b0},{b[26:23]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:10]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{1'b0},{b[39:36]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{1'b0},{b[44:41]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[57:54]}})*$signed({{1'b0},{b[57:54]}}) + $signed({{1'b0},{a[66:63]}})*$signed({{1'b0},{b[66:63]}}) + $signed({{1'b0},{a[75:72]}})*$signed({{1'b0},{b[75:72]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:59]}})*$signed({{1'b0},{b[62:59]}}) + $signed({{1'b0},{a[71:68]}})*$signed({{1'b0},{b[71:68]}}) + $signed({{1'b0},{a[80:77]}})*$signed({{1'b0},{b[80:77]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:46]}} != result_ideal[9:0]) begin
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
		{{temp_SIMD_carry[3:2]},{result [7:0]}} = {{result_SIMD_carry[3:2]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIMD_carry[7:6]},{result [17:8]}} = {{result_SIMD_carry[7:6]},{result_0 [17:8]}} + {{2'b00},{result_1 [17:8]}};
		{{temp_SIMD_carry[11:10]},{result [25:18]}} = {{result_SIMD_carry[11:10]},{result_0 [25:18]}} + {{2'b00},{result_1 [25:18]}};
		{{temp_SIMD_carry[15:14]},{result [35:26]}} = {{result_SIMD_carry[15:14]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIMD_carry[19:18]},{result [43:36]}} = {{result_SIMD_carry[19:18]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIMD_carry[23:22]},{result [53:44]}} = {{result_SIMD_carry[23:22]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{1'b0},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{b[21]},{b[21:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:0]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{1'b0},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{b[26]},{b[26:23]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:10]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{b[39]},{b[39:36]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{b[44]},{b[44:41]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[57:54]}})*$signed({{b[57]},{b[57:54]}}) + $signed({{1'b0},{a[66:63]}})*$signed({{b[66]},{b[66:63]}}) + $signed({{1'b0},{a[75:72]}})*$signed({{b[75]},{b[75:72]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:59]}})*$signed({{b[62]},{b[62:59]}}) + $signed({{1'b0},{a[71:68]}})*$signed({{b[71]},{b[71:68]}}) + $signed({{1'b0},{a[80:77]}})*$signed({{b[80]},{b[80:77]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:46]}} != result_ideal[9:0]) begin
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
		{{temp_SIMD_carry[3:2]},{result [7:0]}} = {{result_SIMD_carry[3:2]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIMD_carry[7:6]},{result [17:8]}} = {{result_SIMD_carry[7:6]},{result_0 [17:8]}} + {{2'b00},{result_1 [17:8]}};
		{{temp_SIMD_carry[11:10]},{result [25:18]}} = {{result_SIMD_carry[11:10]},{result_0 [25:18]}} + {{2'b00},{result_1 [25:18]}};
		{{temp_SIMD_carry[15:14]},{result [35:26]}} = {{result_SIMD_carry[15:14]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIMD_carry[19:18]},{result [43:36]}} = {{result_SIMD_carry[19:18]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIMD_carry[23:22]},{result [53:44]}} = {{result_SIMD_carry[23:22]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{a[12]},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{1'b0},{b[21:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:0]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{a[17]},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{1'b0},{b[26:23]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:10]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{1'b0},{b[39:36]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{1'b0},{b[44:41]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[57]},{a[57:54]}})*$signed({{1'b0},{b[57:54]}}) + $signed({{a[66]},{a[66:63]}})*$signed({{1'b0},{b[66:63]}}) + $signed({{a[75]},{a[75:72]}})*$signed({{1'b0},{b[75:72]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:59]}})*$signed({{1'b0},{b[62:59]}}) + $signed({{a[71]},{a[71:68]}})*$signed({{1'b0},{b[71:68]}}) + $signed({{a[80]},{a[80:77]}})*$signed({{1'b0},{b[80:77]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:46]}} != result_ideal[9:0]) begin
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
		{{temp_SIMD_carry[3:2]},{result [7:0]}} = {{result_SIMD_carry[3:2]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIMD_carry[7:6]},{result [17:8]}} = {{result_SIMD_carry[7:6]},{result_0 [17:8]}} + {{2'b00},{result_1 [17:8]}};
		{{temp_SIMD_carry[11:10]},{result [25:18]}} = {{result_SIMD_carry[11:10]},{result_0 [25:18]}} + {{2'b00},{result_1 [25:18]}};
		{{temp_SIMD_carry[15:14]},{result [35:26]}} = {{result_SIMD_carry[15:14]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIMD_carry[19:18]},{result [43:36]}} = {{result_SIMD_carry[19:18]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIMD_carry[23:22]},{result [53:44]}} = {{result_SIMD_carry[23:22]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{a[12]},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{b[21]},{b[21:18]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:0]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{a[17]},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{b[26]},{b[26:23]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:10]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{b[39]},{b[39:36]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{b[44]},{b[44:41]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[57]},{a[57:54]}})*$signed({{b[57]},{b[57:54]}}) + $signed({{a[66]},{a[66:63]}})*$signed({{b[66]},{b[66:63]}}) + $signed({{a[75]},{a[75:72]}})*$signed({{b[75]},{b[75:72]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:59]}})*$signed({{b[62]},{b[62:59]}}) + $signed({{a[71]},{a[71:68]}})*$signed({{b[71]},{b[71:68]}}) + $signed({{a[80]},{a[80:77]}})*$signed({{b[80]},{b[80:77]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:46]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/unsigned/ mult 2x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_2x2;

		#1
		{{temp_SIMD_carry[1:0]},{result [3:0]}} = {{result_SIMD_carry[1:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIMD_carry[3:2]},{result [7:4]}} = {{result_SIMD_carry[3:2]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIMD_carry[5:4]},{result [13:8]}} = {{result_SIMD_carry[5:4]},{result_0 [13:8]}} + {{2'b00},{result_1 [13:8]}};
		{{temp_SIMD_carry[7:6]},{result [17:14]}} = {{result_SIMD_carry[7:6]},{result_0 [17:14]}} + {{2'b00},{result_1 [17:14]}};
		{{temp_SIMD_carry[9:8]},{result [21:18]}} = {{result_SIMD_carry[9:8]},{result_0 [21:18]}} + {{2'b00},{result_1 [21:18]}};
		{{temp_SIMD_carry[11:10]},{result [25:22]}} = {{result_SIMD_carry[11:10]},{result_0 [25:22]}} + {{2'b00},{result_1 [25:22]}};
		{{temp_SIMD_carry[13:12]},{result [31:26]}} = {{result_SIMD_carry[13:12]},{result_0 [31:26]}} + {{2'b00},{result_1 [31:26]}};
		{{temp_SIMD_carry[15:14]},{result [35:32]}} = {{result_SIMD_carry[15:14]},{result_0 [35:32]}} + {{2'b00},{result_1 [35:32]}};
		{{temp_SIMD_carry[17:16]},{result [39:36]}} = {{result_SIMD_carry[17:16]},{result_0 [39:36]}} + {{2'b00},{result_1 [39:36]}};
		{{temp_SIMD_carry[19:18]},{result [43:40]}} = {{result_SIMD_carry[19:18]},{result_0 [43:40]}} + {{2'b00},{result_1 [43:40]}};
		{{temp_SIMD_carry[21:20]},{result [49:44]}} = {{result_SIMD_carry[21:20]},{result_0 [49:44]}} + {{2'b00},{result_1 [49:44]}};
		{{temp_SIMD_carry[23:22]},{result [53:50]}} = {{result_SIMD_carry[23:22]},{result_0 [53:50]}} + {{2'b00},{result_1 [53:50]}};

		result_ideal = $signed({{1'b0},{a[1:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{1'b0},{a[10:9]}})*$signed({{1'b0},{b[10:9]}}) + $signed({{1'b0},{a[19:18]}})*$signed({{1'b0},{b[19:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[3:0]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[3:2]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{1'b0},{a[12:11]}})*$signed({{1'b0},{b[12:11]}}) + $signed({{1'b0},{a[21:20]}})*$signed({{1'b0},{b[21:20]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:4]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[6:5]}})*$signed({{1'b0},{b[6:5]}}) + $signed({{1'b0},{a[15:14]}})*$signed({{1'b0},{b[15:14]}}) + $signed({{1'b0},{a[24:23]}})*$signed({{1'b0},{b[24:23]}});
		if  ({{temp_SIMD_carry[5:4]},{result[13:10]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:7]}})*$signed({{1'b0},{b[8:7]}}) + $signed({{1'b0},{a[17:16]}})*$signed({{1'b0},{b[17:16]}}) + $signed({{1'b0},{a[26:25]}})*$signed({{1'b0},{b[26:25]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:14]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[28:27]}})*$signed({{1'b0},{b[28:27]}}) + $signed({{1'b0},{a[37:36]}})*$signed({{1'b0},{b[37:36]}}) + $signed({{1'b0},{a[46:45]}})*$signed({{1'b0},{b[46:45]}});
		if  ({{temp_SIMD_carry[9:8]},{result[21:18]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:29]}})*$signed({{1'b0},{b[30:29]}}) + $signed({{1'b0},{a[39:38]}})*$signed({{1'b0},{b[39:38]}}) + $signed({{1'b0},{a[48:47]}})*$signed({{1'b0},{b[48:47]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:22]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[33:32]}})*$signed({{1'b0},{b[33:32]}}) + $signed({{1'b0},{a[42:41]}})*$signed({{1'b0},{b[42:41]}}) + $signed({{1'b0},{a[51:50]}})*$signed({{1'b0},{b[51:50]}});
		if  ({{temp_SIMD_carry[13:12]},{result[31:28]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:34]}})*$signed({{1'b0},{b[35:34]}}) + $signed({{1'b0},{a[44:43]}})*$signed({{1'b0},{b[44:43]}}) + $signed({{1'b0},{a[53:52]}})*$signed({{1'b0},{b[53:52]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:32]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[55:54]}})*$signed({{1'b0},{b[55:54]}}) + $signed({{1'b0},{a[64:63]}})*$signed({{1'b0},{b[64:63]}}) + $signed({{1'b0},{a[73:72]}})*$signed({{1'b0},{b[73:72]}});
		if  ({{temp_SIMD_carry[17:16]},{result[39:36]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[57:56]}})*$signed({{1'b0},{b[57:56]}}) + $signed({{1'b0},{a[66:65]}})*$signed({{1'b0},{b[66:65]}}) + $signed({{1'b0},{a[75:74]}})*$signed({{1'b0},{b[75:74]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:40]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[60:59]}})*$signed({{1'b0},{b[60:59]}}) + $signed({{1'b0},{a[69:68]}})*$signed({{1'b0},{b[69:68]}}) + $signed({{1'b0},{a[78:77]}})*$signed({{1'b0},{b[78:77]}});
		if  ({{temp_SIMD_carry[21:20]},{result[49:46]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:61]}})*$signed({{1'b0},{b[62:61]}}) + $signed({{1'b0},{a[71:70]}})*$signed({{1'b0},{b[71:70]}}) + $signed({{1'b0},{a[80:79]}})*$signed({{1'b0},{b[80:79]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:50]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 2x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_2x2;

		#1
		{{temp_SIMD_carry[1:0]},{result [3:0]}} = {{result_SIMD_carry[1:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIMD_carry[3:2]},{result [7:4]}} = {{result_SIMD_carry[3:2]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIMD_carry[5:4]},{result [13:8]}} = {{result_SIMD_carry[5:4]},{result_0 [13:8]}} + {{2'b00},{result_1 [13:8]}};
		{{temp_SIMD_carry[7:6]},{result [17:14]}} = {{result_SIMD_carry[7:6]},{result_0 [17:14]}} + {{2'b00},{result_1 [17:14]}};
		{{temp_SIMD_carry[9:8]},{result [21:18]}} = {{result_SIMD_carry[9:8]},{result_0 [21:18]}} + {{2'b00},{result_1 [21:18]}};
		{{temp_SIMD_carry[11:10]},{result [25:22]}} = {{result_SIMD_carry[11:10]},{result_0 [25:22]}} + {{2'b00},{result_1 [25:22]}};
		{{temp_SIMD_carry[13:12]},{result [31:26]}} = {{result_SIMD_carry[13:12]},{result_0 [31:26]}} + {{2'b00},{result_1 [31:26]}};
		{{temp_SIMD_carry[15:14]},{result [35:32]}} = {{result_SIMD_carry[15:14]},{result_0 [35:32]}} + {{2'b00},{result_1 [35:32]}};
		{{temp_SIMD_carry[17:16]},{result [39:36]}} = {{result_SIMD_carry[17:16]},{result_0 [39:36]}} + {{2'b00},{result_1 [39:36]}};
		{{temp_SIMD_carry[19:18]},{result [43:40]}} = {{result_SIMD_carry[19:18]},{result_0 [43:40]}} + {{2'b00},{result_1 [43:40]}};
		{{temp_SIMD_carry[21:20]},{result [49:44]}} = {{result_SIMD_carry[21:20]},{result_0 [49:44]}} + {{2'b00},{result_1 [49:44]}};
		{{temp_SIMD_carry[23:22]},{result [53:50]}} = {{result_SIMD_carry[23:22]},{result_0 [53:50]}} + {{2'b00},{result_1 [53:50]}};

		result_ideal = $signed({{1'b0},{a[1:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{1'b0},{a[10:9]}})*$signed({{b[10]},{b[10:9]}}) + $signed({{1'b0},{a[19:18]}})*$signed({{b[19]},{b[19:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[3:0]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[3:2]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{1'b0},{a[12:11]}})*$signed({{b[12]},{b[12:11]}}) + $signed({{1'b0},{a[21:20]}})*$signed({{b[21]},{b[21:20]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:4]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[6:5]}})*$signed({{b[6]},{b[6:5]}}) + $signed({{1'b0},{a[15:14]}})*$signed({{b[15]},{b[15:14]}}) + $signed({{1'b0},{a[24:23]}})*$signed({{b[24]},{b[24:23]}});
		if  ({{temp_SIMD_carry[5:4]},{result[13:10]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:7]}})*$signed({{b[8]},{b[8:7]}}) + $signed({{1'b0},{a[17:16]}})*$signed({{b[17]},{b[17:16]}}) + $signed({{1'b0},{a[26:25]}})*$signed({{b[26]},{b[26:25]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:14]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[28:27]}})*$signed({{b[28]},{b[28:27]}}) + $signed({{1'b0},{a[37:36]}})*$signed({{b[37]},{b[37:36]}}) + $signed({{1'b0},{a[46:45]}})*$signed({{b[46]},{b[46:45]}});
		if  ({{temp_SIMD_carry[9:8]},{result[21:18]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:29]}})*$signed({{b[30]},{b[30:29]}}) + $signed({{1'b0},{a[39:38]}})*$signed({{b[39]},{b[39:38]}}) + $signed({{1'b0},{a[48:47]}})*$signed({{b[48]},{b[48:47]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:22]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[33:32]}})*$signed({{b[33]},{b[33:32]}}) + $signed({{1'b0},{a[42:41]}})*$signed({{b[42]},{b[42:41]}}) + $signed({{1'b0},{a[51:50]}})*$signed({{b[51]},{b[51:50]}});
		if  ({{temp_SIMD_carry[13:12]},{result[31:28]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:34]}})*$signed({{b[35]},{b[35:34]}}) + $signed({{1'b0},{a[44:43]}})*$signed({{b[44]},{b[44:43]}}) + $signed({{1'b0},{a[53:52]}})*$signed({{b[53]},{b[53:52]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:32]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[55:54]}})*$signed({{b[55]},{b[55:54]}}) + $signed({{1'b0},{a[64:63]}})*$signed({{b[64]},{b[64:63]}}) + $signed({{1'b0},{a[73:72]}})*$signed({{b[73]},{b[73:72]}});
		if  ({{temp_SIMD_carry[17:16]},{result[39:36]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[57:56]}})*$signed({{b[57]},{b[57:56]}}) + $signed({{1'b0},{a[66:65]}})*$signed({{b[66]},{b[66:65]}}) + $signed({{1'b0},{a[75:74]}})*$signed({{b[75]},{b[75:74]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:40]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[60:59]}})*$signed({{b[60]},{b[60:59]}}) + $signed({{1'b0},{a[69:68]}})*$signed({{b[69]},{b[69:68]}}) + $signed({{1'b0},{a[78:77]}})*$signed({{b[78]},{b[78:77]}});
		if  ({{temp_SIMD_carry[21:20]},{result[49:46]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:61]}})*$signed({{b[62]},{b[62:61]}}) + $signed({{1'b0},{a[71:70]}})*$signed({{b[71]},{b[71:70]}}) + $signed({{1'b0},{a[80:79]}})*$signed({{b[80]},{b[80:79]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:50]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 2x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_2x2;

		#1
		{{temp_SIMD_carry[1:0]},{result [3:0]}} = {{result_SIMD_carry[1:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIMD_carry[3:2]},{result [7:4]}} = {{result_SIMD_carry[3:2]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIMD_carry[5:4]},{result [13:8]}} = {{result_SIMD_carry[5:4]},{result_0 [13:8]}} + {{2'b00},{result_1 [13:8]}};
		{{temp_SIMD_carry[7:6]},{result [17:14]}} = {{result_SIMD_carry[7:6]},{result_0 [17:14]}} + {{2'b00},{result_1 [17:14]}};
		{{temp_SIMD_carry[9:8]},{result [21:18]}} = {{result_SIMD_carry[9:8]},{result_0 [21:18]}} + {{2'b00},{result_1 [21:18]}};
		{{temp_SIMD_carry[11:10]},{result [25:22]}} = {{result_SIMD_carry[11:10]},{result_0 [25:22]}} + {{2'b00},{result_1 [25:22]}};
		{{temp_SIMD_carry[13:12]},{result [31:26]}} = {{result_SIMD_carry[13:12]},{result_0 [31:26]}} + {{2'b00},{result_1 [31:26]}};
		{{temp_SIMD_carry[15:14]},{result [35:32]}} = {{result_SIMD_carry[15:14]},{result_0 [35:32]}} + {{2'b00},{result_1 [35:32]}};
		{{temp_SIMD_carry[17:16]},{result [39:36]}} = {{result_SIMD_carry[17:16]},{result_0 [39:36]}} + {{2'b00},{result_1 [39:36]}};
		{{temp_SIMD_carry[19:18]},{result [43:40]}} = {{result_SIMD_carry[19:18]},{result_0 [43:40]}} + {{2'b00},{result_1 [43:40]}};
		{{temp_SIMD_carry[21:20]},{result [49:44]}} = {{result_SIMD_carry[21:20]},{result_0 [49:44]}} + {{2'b00},{result_1 [49:44]}};
		{{temp_SIMD_carry[23:22]},{result [53:50]}} = {{result_SIMD_carry[23:22]},{result_0 [53:50]}} + {{2'b00},{result_1 [53:50]}};

		result_ideal = $signed({{a[1]},{a[1:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{a[10]},{a[10:9]}})*$signed({{1'b0},{b[10:9]}}) + $signed({{a[19]},{a[19:18]}})*$signed({{1'b0},{b[19:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[3:0]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[3]},{a[3:2]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{a[12]},{a[12:11]}})*$signed({{1'b0},{b[12:11]}}) + $signed({{a[21]},{a[21:20]}})*$signed({{1'b0},{b[21:20]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:4]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[6]},{a[6:5]}})*$signed({{1'b0},{b[6:5]}}) + $signed({{a[15]},{a[15:14]}})*$signed({{1'b0},{b[15:14]}}) + $signed({{a[24]},{a[24:23]}})*$signed({{1'b0},{b[24:23]}});
		if  ({{temp_SIMD_carry[5:4]},{result[13:10]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:7]}})*$signed({{1'b0},{b[8:7]}}) + $signed({{a[17]},{a[17:16]}})*$signed({{1'b0},{b[17:16]}}) + $signed({{a[26]},{a[26:25]}})*$signed({{1'b0},{b[26:25]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:14]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[28]},{a[28:27]}})*$signed({{1'b0},{b[28:27]}}) + $signed({{a[37]},{a[37:36]}})*$signed({{1'b0},{b[37:36]}}) + $signed({{a[46]},{a[46:45]}})*$signed({{1'b0},{b[46:45]}});
		if  ({{temp_SIMD_carry[9:8]},{result[21:18]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:29]}})*$signed({{1'b0},{b[30:29]}}) + $signed({{a[39]},{a[39:38]}})*$signed({{1'b0},{b[39:38]}}) + $signed({{a[48]},{a[48:47]}})*$signed({{1'b0},{b[48:47]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:22]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[33]},{a[33:32]}})*$signed({{1'b0},{b[33:32]}}) + $signed({{a[42]},{a[42:41]}})*$signed({{1'b0},{b[42:41]}}) + $signed({{a[51]},{a[51:50]}})*$signed({{1'b0},{b[51:50]}});
		if  ({{temp_SIMD_carry[13:12]},{result[31:28]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:34]}})*$signed({{1'b0},{b[35:34]}}) + $signed({{a[44]},{a[44:43]}})*$signed({{1'b0},{b[44:43]}}) + $signed({{a[53]},{a[53:52]}})*$signed({{1'b0},{b[53:52]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:32]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[55]},{a[55:54]}})*$signed({{1'b0},{b[55:54]}}) + $signed({{a[64]},{a[64:63]}})*$signed({{1'b0},{b[64:63]}}) + $signed({{a[73]},{a[73:72]}})*$signed({{1'b0},{b[73:72]}});
		if  ({{temp_SIMD_carry[17:16]},{result[39:36]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[57]},{a[57:56]}})*$signed({{1'b0},{b[57:56]}}) + $signed({{a[66]},{a[66:65]}})*$signed({{1'b0},{b[66:65]}}) + $signed({{a[75]},{a[75:74]}})*$signed({{1'b0},{b[75:74]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:40]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[60]},{a[60:59]}})*$signed({{1'b0},{b[60:59]}}) + $signed({{a[69]},{a[69:68]}})*$signed({{1'b0},{b[69:68]}}) + $signed({{a[78]},{a[78:77]}})*$signed({{1'b0},{b[78:77]}});
		if  ({{temp_SIMD_carry[21:20]},{result[49:46]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:61]}})*$signed({{1'b0},{b[62:61]}}) + $signed({{a[71]},{a[71:70]}})*$signed({{1'b0},{b[71:70]}}) + $signed({{a[80]},{a[80:79]}})*$signed({{1'b0},{b[80:79]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:50]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 2x2
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_2x2;

		#1
		{{temp_SIMD_carry[1:0]},{result [3:0]}} = {{result_SIMD_carry[1:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIMD_carry[3:2]},{result [7:4]}} = {{result_SIMD_carry[3:2]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIMD_carry[5:4]},{result [13:8]}} = {{result_SIMD_carry[5:4]},{result_0 [13:8]}} + {{2'b00},{result_1 [13:8]}};
		{{temp_SIMD_carry[7:6]},{result [17:14]}} = {{result_SIMD_carry[7:6]},{result_0 [17:14]}} + {{2'b00},{result_1 [17:14]}};
		{{temp_SIMD_carry[9:8]},{result [21:18]}} = {{result_SIMD_carry[9:8]},{result_0 [21:18]}} + {{2'b00},{result_1 [21:18]}};
		{{temp_SIMD_carry[11:10]},{result [25:22]}} = {{result_SIMD_carry[11:10]},{result_0 [25:22]}} + {{2'b00},{result_1 [25:22]}};
		{{temp_SIMD_carry[13:12]},{result [31:26]}} = {{result_SIMD_carry[13:12]},{result_0 [31:26]}} + {{2'b00},{result_1 [31:26]}};
		{{temp_SIMD_carry[15:14]},{result [35:32]}} = {{result_SIMD_carry[15:14]},{result_0 [35:32]}} + {{2'b00},{result_1 [35:32]}};
		{{temp_SIMD_carry[17:16]},{result [39:36]}} = {{result_SIMD_carry[17:16]},{result_0 [39:36]}} + {{2'b00},{result_1 [39:36]}};
		{{temp_SIMD_carry[19:18]},{result [43:40]}} = {{result_SIMD_carry[19:18]},{result_0 [43:40]}} + {{2'b00},{result_1 [43:40]}};
		{{temp_SIMD_carry[21:20]},{result [49:44]}} = {{result_SIMD_carry[21:20]},{result_0 [49:44]}} + {{2'b00},{result_1 [49:44]}};
		{{temp_SIMD_carry[23:22]},{result [53:50]}} = {{result_SIMD_carry[23:22]},{result_0 [53:50]}} + {{2'b00},{result_1 [53:50]}};

		result_ideal = $signed({{a[1]},{a[1:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{a[10]},{a[10:9]}})*$signed({{b[10]},{b[10:9]}}) + $signed({{a[19]},{a[19:18]}})*$signed({{b[19]},{b[19:18]}});
		if  ({{temp_SIMD_carry[1:0]},{result[3:0]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[3]},{a[3:2]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{a[12]},{a[12:11]}})*$signed({{b[12]},{b[12:11]}}) + $signed({{a[21]},{a[21:20]}})*$signed({{b[21]},{b[21:20]}});
		if  ({{temp_SIMD_carry[3:2]},{result[7:4]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[6]},{a[6:5]}})*$signed({{b[6]},{b[6:5]}}) + $signed({{a[15]},{a[15:14]}})*$signed({{b[15]},{b[15:14]}}) + $signed({{a[24]},{a[24:23]}})*$signed({{b[24]},{b[24:23]}});
		if  ({{temp_SIMD_carry[5:4]},{result[13:10]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:7]}})*$signed({{b[8]},{b[8:7]}}) + $signed({{a[17]},{a[17:16]}})*$signed({{b[17]},{b[17:16]}}) + $signed({{a[26]},{a[26:25]}})*$signed({{b[26]},{b[26:25]}});
		if  ({{temp_SIMD_carry[7:6]},{result[17:14]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[28]},{a[28:27]}})*$signed({{b[28]},{b[28:27]}}) + $signed({{a[37]},{a[37:36]}})*$signed({{b[37]},{b[37:36]}}) + $signed({{a[46]},{a[46:45]}})*$signed({{b[46]},{b[46:45]}});
		if  ({{temp_SIMD_carry[9:8]},{result[21:18]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:29]}})*$signed({{b[30]},{b[30:29]}}) + $signed({{a[39]},{a[39:38]}})*$signed({{b[39]},{b[39:38]}}) + $signed({{a[48]},{a[48:47]}})*$signed({{b[48]},{b[48:47]}});
		if  ({{temp_SIMD_carry[11:10]},{result[25:22]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[33]},{a[33:32]}})*$signed({{b[33]},{b[33:32]}}) + $signed({{a[42]},{a[42:41]}})*$signed({{b[42]},{b[42:41]}}) + $signed({{a[51]},{a[51:50]}})*$signed({{b[51]},{b[51:50]}});
		if  ({{temp_SIMD_carry[13:12]},{result[31:28]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:34]}})*$signed({{b[35]},{b[35:34]}}) + $signed({{a[44]},{a[44:43]}})*$signed({{b[44]},{b[44:43]}}) + $signed({{a[53]},{a[53:52]}})*$signed({{b[53]},{b[53:52]}});
		if  ({{temp_SIMD_carry[15:14]},{result[35:32]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[55]},{a[55:54]}})*$signed({{b[55]},{b[55:54]}}) + $signed({{a[64]},{a[64:63]}})*$signed({{b[64]},{b[64:63]}}) + $signed({{a[73]},{a[73:72]}})*$signed({{b[73]},{b[73:72]}});
		if  ({{temp_SIMD_carry[17:16]},{result[39:36]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[57]},{a[57:56]}})*$signed({{b[57]},{b[57:56]}}) + $signed({{a[66]},{a[66:65]}})*$signed({{b[66]},{b[66:65]}}) + $signed({{a[75]},{a[75:74]}})*$signed({{b[75]},{b[75:74]}});
		if  ({{temp_SIMD_carry[19:18]},{result[43:40]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[60]},{a[60:59]}})*$signed({{b[60]},{b[60:59]}}) + $signed({{a[69]},{a[69:68]}})*$signed({{b[69]},{b[69:68]}}) + $signed({{a[78]},{a[78:77]}})*$signed({{b[78]},{b[78:77]}});
		if  ({{temp_SIMD_carry[21:20]},{result[49:46]}} != result_ideal[5:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:61]}})*$signed({{b[62]},{b[62:61]}}) + $signed({{a[71]},{a[71:70]}})*$signed({{b[71]},{b[71:70]}}) + $signed({{a[80]},{a[80:79]}})*$signed({{b[80]},{b[80:79]}});
		if  ({{temp_SIMD_carry[23:22]},{result[53:50]}} != result_ideal[5:0]) begin
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

multiplier_T_C3x3_F2_27bits_27bits_HighLevelDescribed_auto	multiplier_T_C3x3_F2_27bits_27bits_HighLevelDescribed_auto_inst(
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
