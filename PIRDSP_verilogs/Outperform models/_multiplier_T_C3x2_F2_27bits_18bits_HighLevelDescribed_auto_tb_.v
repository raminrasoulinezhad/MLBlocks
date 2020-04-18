`timescale 1 ns / 100 ps  
module multiplier_T_C3x2_F2_27bits_18bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 100;

// functionality modes 
parameter mode_27x18	= 2'b00;
parameter mode_sum_9x9	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
parameter mode_sum_2x2	= 2'b11;
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
wire[15:0] result_SIDM_carry;
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
		result [28:0] = {{result_SIDM_carry[7:6]},{result_0 [26:0]}} + {{2'b00},{result_1 [26:0]}};
		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{1'b0},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{1'b0},{b[26:18]}});
		if  (result[28:9] != result_ideal[19:0]) begin
			$display("--------");
			$display("SIMDCarry:\t%b",  result_SIDM_carry[7:6]);
			$display("result:\t\t%b",  result[26:9]);
			$display("total:\t\t%b",  {{result_SIDM_carry[7:6]},{result[26:9]}});
			$display("Ideal:\t\t%b",  result_ideal[19:0]);
			Error_counter = Error_counter + 1;
		end
		
		#1
		result [28:0] = {{result_SIDM_carry[15:14]},{result_0 [44:27]}} + {{2'b00},{result_1 [44:27]}};
		result_ideal = $signed({{1'b0},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{1'b0},{b[44:36]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  (result [28:0] != result_ideal[19:0]) begin
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
		result [26:0] = result_0 [26:0] + result_1 [26:0];
		result [44:27] = result_0 [44:27] + result_1 [44:27];

		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{1'b0},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{b[26]},{b[26:18]}});
		if  (result[26:9] != result_ideal[17:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{b[44]},{b[44:36]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  (result[44:27] != result_ideal[17:0]) begin
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
		result [26:0] = result_0 [26:0] + result_1 [26:0];
		result [44:27] = result_0 [44:27] + result_1 [44:27];

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{a[17]},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{1'b0},{b[26:18]}});
		if  (result[26:9] != result_ideal[17:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{1'b0},{b[44:36]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  (result[44:27] != result_ideal[17:0]) begin
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
		result [26:0] = result_0 [26:0] + result_1 [26:0];
		result [44:27] = result_0 [44:27] + result_1 [44:27];

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{a[17]},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{b[26]},{b[26:18]}});
		if  (result[26:9] != result_ideal[17:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{b[44]},{b[44:36]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  (result[44:27] != result_ideal[17:0]) begin
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
		result [16:0] = result_0 [16:0] + result_1 [16:0];
		result [26:17] = result_0 [26:17] + result_1 [26:17];
		result [34:27] = result_0 [34:27] + result_1 [34:27];
		result [44:35] = result_0 [44:35] + result_1 [44:35];

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{1'b0},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{1'b0},{b[21:18]}});
		if  (result[16:9] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{1'b0},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{1'b0},{b[26:23]}});
		if  (result[26:19] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{1'b0},{b[39:36]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  (result[34:27] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{1'b0},{b[44:41]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  (result[44:37] != result_ideal[7:0]) begin
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
		result [16:0] = result_0 [16:0] + result_1 [16:0];
		result [26:17] = result_0 [26:17] + result_1 [26:17];
		result [34:27] = result_0 [34:27] + result_1 [34:27];
		result [44:35] = result_0 [44:35] + result_1 [44:35];

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{1'b0},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{b[21]},{b[21:18]}});
		if  (result[16:9] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{1'b0},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{b[26]},{b[26:23]}});
		if  (result[26:19] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{b[39]},{b[39:36]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  (result[34:27] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{b[44]},{b[44:41]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  (result[44:37] != result_ideal[7:0]) begin
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
		result [16:0] = result_0 [16:0] + result_1 [16:0];
		result [26:17] = result_0 [26:17] + result_1 [26:17];
		result [34:27] = result_0 [34:27] + result_1 [34:27];
		result [44:35] = result_0 [44:35] + result_1 [44:35];

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{a[12]},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{1'b0},{b[21:18]}});
		if  (result[16:9] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{a[17]},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{1'b0},{b[26:23]}});
		if  (result[26:19] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{1'b0},{b[39:36]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  (result[34:27] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{1'b0},{b[44:41]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  (result[44:37] != result_ideal[7:0]) begin
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
		result [16:0] = result_0 [16:0] + result_1 [16:0];
		result [26:17] = result_0 [26:17] + result_1 [26:17];
		result [34:27] = result_0 [34:27] + result_1 [34:27];
		result [44:35] = result_0 [44:35] + result_1 [44:35];

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{a[12]},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{b[21]},{b[21:18]}});
		if  (result[16:9] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{a[17]},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{b[26]},{b[26:23]}});
		if  (result[26:19] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{b[39]},{b[39:36]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  (result[34:27] != result_ideal[7:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{b[44]},{b[44:41]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  (result[44:37] != result_ideal[7:0]) begin
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
		result [12:0] = result_0 [12:0] + result_1 [12:0];
		result [16:13] = result_0 [16:13] + result_1 [16:13];
		result [22:17] = result_0 [22:17] + result_1 [22:17];
		result [26:23] = result_0 [26:23] + result_1 [26:23];
		result [30:27] = result_0 [30:27] + result_1 [30:27];
		result [34:31] = result_0 [34:31] + result_1 [34:31];
		result [40:35] = result_0 [40:35] + result_1 [40:35];
		result [44:41] = result_0 [44:41] + result_1 [44:41];

		result_ideal = $signed({{1'b0},{a[1:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{1'b0},{a[10:9]}})*$signed({{1'b0},{b[10:9]}}) + $signed({{1'b0},{a[19:18]}})*$signed({{1'b0},{b[19:18]}});
		if  (result[12:9] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[3:2]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{1'b0},{a[12:11]}})*$signed({{1'b0},{b[12:11]}}) + $signed({{1'b0},{a[21:20]}})*$signed({{1'b0},{b[21:20]}});
		if  (result[16:13] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[6:5]}})*$signed({{1'b0},{b[6:5]}}) + $signed({{1'b0},{a[15:14]}})*$signed({{1'b0},{b[15:14]}}) + $signed({{1'b0},{a[24:23]}})*$signed({{1'b0},{b[24:23]}});
		if  (result[22:19] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:7]}})*$signed({{1'b0},{b[8:7]}}) + $signed({{1'b0},{a[17:16]}})*$signed({{1'b0},{b[17:16]}}) + $signed({{1'b0},{a[26:25]}})*$signed({{1'b0},{b[26:25]}});
		if  (result[26:23] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[28:27]}})*$signed({{1'b0},{b[28:27]}}) + $signed({{1'b0},{a[37:36]}})*$signed({{1'b0},{b[37:36]}}) + $signed({{1'b0},{a[46:45]}})*$signed({{1'b0},{b[46:45]}});
		if  (result[30:27] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:29]}})*$signed({{1'b0},{b[30:29]}}) + $signed({{1'b0},{a[39:38]}})*$signed({{1'b0},{b[39:38]}}) + $signed({{1'b0},{a[48:47]}})*$signed({{1'b0},{b[48:47]}});
		if  (result[34:31] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[33:32]}})*$signed({{1'b0},{b[33:32]}}) + $signed({{1'b0},{a[42:41]}})*$signed({{1'b0},{b[42:41]}}) + $signed({{1'b0},{a[51:50]}})*$signed({{1'b0},{b[51:50]}});
		if  (result[40:37] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:34]}})*$signed({{1'b0},{b[35:34]}}) + $signed({{1'b0},{a[44:43]}})*$signed({{1'b0},{b[44:43]}}) + $signed({{1'b0},{a[53:52]}})*$signed({{1'b0},{b[53:52]}});
		if  (result[44:41] != result_ideal[3:0]) begin
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
		result [12:0] = result_0 [12:0] + result_1 [12:0];
		result [16:13] = result_0 [16:13] + result_1 [16:13];
		result [22:17] = result_0 [22:17] + result_1 [22:17];
		result [26:23] = result_0 [26:23] + result_1 [26:23];
		result [30:27] = result_0 [30:27] + result_1 [30:27];
		result [34:31] = result_0 [34:31] + result_1 [34:31];
		result [40:35] = result_0 [40:35] + result_1 [40:35];
		result [44:41] = result_0 [44:41] + result_1 [44:41];

		result_ideal = $signed({{1'b0},{a[1:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{1'b0},{a[10:9]}})*$signed({{b[10]},{b[10:9]}}) + $signed({{1'b0},{a[19:18]}})*$signed({{b[19]},{b[19:18]}});
		if  (result[12:9] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[3:2]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{1'b0},{a[12:11]}})*$signed({{b[12]},{b[12:11]}}) + $signed({{1'b0},{a[21:20]}})*$signed({{b[21]},{b[21:20]}});
		if  (result[16:13] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[6:5]}})*$signed({{b[6]},{b[6:5]}}) + $signed({{1'b0},{a[15:14]}})*$signed({{b[15]},{b[15:14]}}) + $signed({{1'b0},{a[24:23]}})*$signed({{b[24]},{b[24:23]}});
		if  (result[22:19] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:7]}})*$signed({{b[8]},{b[8:7]}}) + $signed({{1'b0},{a[17:16]}})*$signed({{b[17]},{b[17:16]}}) + $signed({{1'b0},{a[26:25]}})*$signed({{b[26]},{b[26:25]}});
		if  (result[26:23] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[28:27]}})*$signed({{b[28]},{b[28:27]}}) + $signed({{1'b0},{a[37:36]}})*$signed({{b[37]},{b[37:36]}}) + $signed({{1'b0},{a[46:45]}})*$signed({{b[46]},{b[46:45]}});
		if  (result[30:27] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[30:29]}})*$signed({{b[30]},{b[30:29]}}) + $signed({{1'b0},{a[39:38]}})*$signed({{b[39]},{b[39:38]}}) + $signed({{1'b0},{a[48:47]}})*$signed({{b[48]},{b[48:47]}});
		if  (result[34:31] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[33:32]}})*$signed({{b[33]},{b[33:32]}}) + $signed({{1'b0},{a[42:41]}})*$signed({{b[42]},{b[42:41]}}) + $signed({{1'b0},{a[51:50]}})*$signed({{b[51]},{b[51:50]}});
		if  (result[40:37] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[35:34]}})*$signed({{b[35]},{b[35:34]}}) + $signed({{1'b0},{a[44:43]}})*$signed({{b[44]},{b[44:43]}}) + $signed({{1'b0},{a[53:52]}})*$signed({{b[53]},{b[53:52]}});
		if  (result[44:41] != result_ideal[3:0]) begin
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
		result [12:0] = result_0 [12:0] + result_1 [12:0];
		result [16:13] = result_0 [16:13] + result_1 [16:13];
		result [22:17] = result_0 [22:17] + result_1 [22:17];
		result [26:23] = result_0 [26:23] + result_1 [26:23];
		result [30:27] = result_0 [30:27] + result_1 [30:27];
		result [34:31] = result_0 [34:31] + result_1 [34:31];
		result [40:35] = result_0 [40:35] + result_1 [40:35];
		result [44:41] = result_0 [44:41] + result_1 [44:41];

		result_ideal = $signed({{a[1]},{a[1:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{a[10]},{a[10:9]}})*$signed({{1'b0},{b[10:9]}}) + $signed({{a[19]},{a[19:18]}})*$signed({{1'b0},{b[19:18]}});
		if  (result[12:9] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[3]},{a[3:2]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{a[12]},{a[12:11]}})*$signed({{1'b0},{b[12:11]}}) + $signed({{a[21]},{a[21:20]}})*$signed({{1'b0},{b[21:20]}});
		if  (result[16:13] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[6]},{a[6:5]}})*$signed({{1'b0},{b[6:5]}}) + $signed({{a[15]},{a[15:14]}})*$signed({{1'b0},{b[15:14]}}) + $signed({{a[24]},{a[24:23]}})*$signed({{1'b0},{b[24:23]}});
		if  (result[22:19] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:7]}})*$signed({{1'b0},{b[8:7]}}) + $signed({{a[17]},{a[17:16]}})*$signed({{1'b0},{b[17:16]}}) + $signed({{a[26]},{a[26:25]}})*$signed({{1'b0},{b[26:25]}});
		if  (result[26:23] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[28]},{a[28:27]}})*$signed({{1'b0},{b[28:27]}}) + $signed({{a[37]},{a[37:36]}})*$signed({{1'b0},{b[37:36]}}) + $signed({{a[46]},{a[46:45]}})*$signed({{1'b0},{b[46:45]}});
		if  (result[30:27] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:29]}})*$signed({{1'b0},{b[30:29]}}) + $signed({{a[39]},{a[39:38]}})*$signed({{1'b0},{b[39:38]}}) + $signed({{a[48]},{a[48:47]}})*$signed({{1'b0},{b[48:47]}});
		if  (result[34:31] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[33]},{a[33:32]}})*$signed({{1'b0},{b[33:32]}}) + $signed({{a[42]},{a[42:41]}})*$signed({{1'b0},{b[42:41]}}) + $signed({{a[51]},{a[51:50]}})*$signed({{1'b0},{b[51:50]}});
		if  (result[40:37] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:34]}})*$signed({{1'b0},{b[35:34]}}) + $signed({{a[44]},{a[44:43]}})*$signed({{1'b0},{b[44:43]}}) + $signed({{a[53]},{a[53:52]}})*$signed({{1'b0},{b[53:52]}});
		if  (result[44:41] != result_ideal[3:0]) begin
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
		result [12:0] = result_0 [12:0] + result_1 [12:0];
		result [16:13] = result_0 [16:13] + result_1 [16:13];
		result [22:17] = result_0 [22:17] + result_1 [22:17];
		result [26:23] = result_0 [26:23] + result_1 [26:23];
		result [30:27] = result_0 [30:27] + result_1 [30:27];
		result [34:31] = result_0 [34:31] + result_1 [34:31];
		result [40:35] = result_0 [40:35] + result_1 [40:35];
		result [44:41] = result_0 [44:41] + result_1 [44:41];

		result_ideal = $signed({{a[1]},{a[1:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{a[10]},{a[10:9]}})*$signed({{b[10]},{b[10:9]}}) + $signed({{a[19]},{a[19:18]}})*$signed({{b[19]},{b[19:18]}});
		if  (result[12:9] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[3]},{a[3:2]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{a[12]},{a[12:11]}})*$signed({{b[12]},{b[12:11]}}) + $signed({{a[21]},{a[21:20]}})*$signed({{b[21]},{b[21:20]}});
		if  (result[16:13] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[6]},{a[6:5]}})*$signed({{b[6]},{b[6:5]}}) + $signed({{a[15]},{a[15:14]}})*$signed({{b[15]},{b[15:14]}}) + $signed({{a[24]},{a[24:23]}})*$signed({{b[24]},{b[24:23]}});
		if  (result[22:19] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:7]}})*$signed({{b[8]},{b[8:7]}}) + $signed({{a[17]},{a[17:16]}})*$signed({{b[17]},{b[17:16]}}) + $signed({{a[26]},{a[26:25]}})*$signed({{b[26]},{b[26:25]}});
		if  (result[26:23] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[28]},{a[28:27]}})*$signed({{b[28]},{b[28:27]}}) + $signed({{a[37]},{a[37:36]}})*$signed({{b[37]},{b[37:36]}}) + $signed({{a[46]},{a[46:45]}})*$signed({{b[46]},{b[46:45]}});
		if  (result[30:27] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[30]},{a[30:29]}})*$signed({{b[30]},{b[30:29]}}) + $signed({{a[39]},{a[39:38]}})*$signed({{b[39]},{b[39:38]}}) + $signed({{a[48]},{a[48:47]}})*$signed({{b[48]},{b[48:47]}});
		if  (result[34:31] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[33]},{a[33:32]}})*$signed({{b[33]},{b[33:32]}}) + $signed({{a[42]},{a[42:41]}})*$signed({{b[42]},{b[42:41]}}) + $signed({{a[51]},{a[51:50]}})*$signed({{b[51]},{b[51:50]}});
		if  (result[40:37] != result_ideal[3:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[35]},{a[35:34]}})*$signed({{b[35]},{b[35:34]}}) + $signed({{a[44]},{a[44:43]}})*$signed({{b[44]},{b[44:43]}}) + $signed({{a[53]},{a[53:52]}})*$signed({{b[53]},{b[53:52]}});
		if  (result[44:41] != result_ideal[3:0]) begin
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

multiplier_T_C3x2_F2_27bits_18bits_HighLevelDescribed_auto	multiplier_T_C3x2_F2_27bits_18bits_HighLevelDescribed_auto_inst(
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
