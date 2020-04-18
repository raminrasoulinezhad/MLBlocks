`timescale 1 ns / 100 ps  
module multiplier_T_C3x2_F2_54bits_36bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 100;

// functionality modes 
parameter mode_54x36	= 2'b00;
parameter mode_sum_18x18	= 2'b1;
parameter mode_sum_9x9	= 2'b10;
parameter mode_sum_4x4	= 2'b11;
reg [2:0] mode;

//integers
integer counter, Error_counter;

/*******************************************************
*	Inputs  & outputs
*******************************************************/
reg [107:0] a;
reg [107:0] b;

reg a_sign;
reg b_sign;

wire signed [89:0] result_0;
wire signed [89:0] result_1;

wire [15:0] result_SIDM_carry;
reg [15:0] temp_SIDM_carry;

reg signed [89:0] result;
reg signed [89:0] result_ideal;

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

	// check unsigned/unsigned mult 54x36
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[107:54] = {54{1'b0}};
		b = $random;
		b[107:36] = {72{1'b0}};

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_54x36;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check unsigned/signed mult 54x36
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[107:54] = {54{1'b0}};
		b = $random;
		b[107:36] = {72{b[35]}};

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_54x36;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{1'b0},{a}}) * $signed({{b[35]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/unsigned mult 54x36
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[107:54] = {54{a[53]}};
		b = $random;
		b[107:36] = {72{1'b0}};

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_54x36;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[53]},{a}}) * $signed({{1'b0},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end

	// check signed/signed mult 54x36
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);

		a = $random;
		a[107:54] = {54{a[53]}};
		b = $random;
		b[107:36] = {72{b[35]}};

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_54x36;

		#1

		result = result_0 + result_1;
		result_ideal = $signed({{a[53]},{a}}) * $signed({{b[35]},{b}});
		if (result_ideal != result) begin
			Error_counter = Error_counter + 1;
		end
	end


	// check unsigned/unsigned/ mult 18x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b0;

		mode = mode_sum_18x18;

		#1
		{{temp_SIDM_carry[7:6]},{result [53:0]}} = {{result_SIDM_carry[7:6]},{result_0 [53:0]}} + {{2'b00},{result_1 [53:0]}};
		{{temp_SIDM_carry[15:14]},{result [89:54]}} = {{result_SIDM_carry[15:14]},{result_0 [89:54]}} + {{2'b00},{result_1 [89:54]}};

		result_ideal = $signed({{1'b0},{a[17:0]}})*$signed({{1'b0},{b[17:0]}}) + $signed({{1'b0},{a[35:18]}})*$signed({{1'b0},{b[35:18]}}) + $signed({{1'b0},{a[53:36]}})*$signed({{1'b0},{b[53:36]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:18]}} != result_ideal[37:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[71:54]}})*$signed({{1'b0},{b[71:54]}}) + $signed({{1'b0},{a[89:72]}})*$signed({{1'b0},{b[89:72]}}) + $signed({{1'b0},{a[107:90]}})*$signed({{1'b0},{b[107:90]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:54]}} != result_ideal[37:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check unsigned/signed/ mult 18x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b0;
		b_sign = 1'b1;

		mode = mode_sum_18x18;

		#1
		{{temp_SIDM_carry[7:6]},{result [53:0]}} = {{result_SIDM_carry[7:6]},{result_0 [53:0]}} + {{2'b00},{result_1 [53:0]}};
		{{temp_SIDM_carry[15:14]},{result [89:54]}} = {{result_SIDM_carry[15:14]},{result_0 [89:54]}} + {{2'b00},{result_1 [89:54]}};

		result_ideal = $signed({{1'b0},{a[17:0]}})*$signed({{b[17]},{b[17:0]}}) + $signed({{1'b0},{a[35:18]}})*$signed({{b[35]},{b[35:18]}}) + $signed({{1'b0},{a[53:36]}})*$signed({{b[53]},{b[53:36]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:18]}} != result_ideal[37:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[71:54]}})*$signed({{b[71]},{b[71:54]}}) + $signed({{1'b0},{a[89:72]}})*$signed({{b[89]},{b[89:72]}}) + $signed({{1'b0},{a[107:90]}})*$signed({{b[107]},{b[107:90]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:54]}} != result_ideal[37:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/unsigned/ mult 18x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b0;

		mode = mode_sum_18x18;

		#1
		{{temp_SIDM_carry[7:6]},{result [53:0]}} = {{result_SIDM_carry[7:6]},{result_0 [53:0]}} + {{2'b00},{result_1 [53:0]}};
		{{temp_SIDM_carry[15:14]},{result [89:54]}} = {{result_SIDM_carry[15:14]},{result_0 [89:54]}} + {{2'b00},{result_1 [89:54]}};

		result_ideal = $signed({{a[17]},{a[17:0]}})*$signed({{1'b0},{b[17:0]}}) + $signed({{a[35]},{a[35:18]}})*$signed({{1'b0},{b[35:18]}}) + $signed({{a[53]},{a[53:36]}})*$signed({{1'b0},{b[53:36]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:18]}} != result_ideal[37:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[71]},{a[71:54]}})*$signed({{1'b0},{b[71:54]}}) + $signed({{a[89]},{a[89:72]}})*$signed({{1'b0},{b[89:72]}}) + $signed({{a[107]},{a[107:90]}})*$signed({{1'b0},{b[107:90]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:54]}} != result_ideal[37:0]) begin
			Error_counter = Error_counter + 1;
		end

	end

	// check signed/signed/ mult 18x18
	for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
		@(posedge clk);
		a = $random;
		b = $random;

		a_sign = 1'b1;
		b_sign = 1'b1;

		mode = mode_sum_18x18;

		#1
		{{temp_SIDM_carry[7:6]},{result [53:0]}} = {{result_SIDM_carry[7:6]},{result_0 [53:0]}} + {{2'b00},{result_1 [53:0]}};
		{{temp_SIDM_carry[15:14]},{result [89:54]}} = {{result_SIDM_carry[15:14]},{result_0 [89:54]}} + {{2'b00},{result_1 [89:54]}};

		result_ideal = $signed({{a[17]},{a[17:0]}})*$signed({{b[17]},{b[17:0]}}) + $signed({{a[35]},{a[35:18]}})*$signed({{b[35]},{b[35:18]}}) + $signed({{a[53]},{a[53:36]}})*$signed({{b[53]},{b[53:36]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:18]}} != result_ideal[37:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[71]},{a[71:54]}})*$signed({{b[71]},{b[71:54]}}) + $signed({{a[89]},{a[89:72]}})*$signed({{b[89]},{b[89:72]}}) + $signed({{a[107]},{a[107:90]}})*$signed({{b[107]},{b[107:90]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:54]}} != result_ideal[37:0]) begin
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
		{{temp_SIDM_carry[3:2]},{result [35:0]}} = {{result_SIDM_carry[3:2]},{result_0 [35:0]}} + {{2'b00},{result_1 [35:0]}};
		{{temp_SIDM_carry[7:6]},{result [53:36]}} = {{result_SIDM_carry[7:6]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};
		{{temp_SIDM_carry[11:10]},{result [71:54]}} = {{result_SIDM_carry[11:10]},{result_0 [71:54]}} + {{2'b00},{result_1 [71:54]}};
		{{temp_SIDM_carry[15:14]},{result [89:72]}} = {{result_SIDM_carry[15:14]},{result_0 [89:72]}} + {{2'b00},{result_1 [89:72]}};

		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{1'b0},{b[26:18]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{1'b0},{b[44:36]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{1'b0},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:36]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:54]}})*$signed({{1'b0},{b[62:54]}}) + $signed({{1'b0},{a[80:72]}})*$signed({{1'b0},{b[80:72]}}) + $signed({{1'b0},{a[98:90]}})*$signed({{1'b0},{b[98:90]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:54]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[71:63]}})*$signed({{1'b0},{b[71:63]}}) + $signed({{1'b0},{a[89:81]}})*$signed({{1'b0},{b[89:81]}}) + $signed({{1'b0},{a[107:99]}})*$signed({{1'b0},{b[107:99]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:72]}} != result_ideal[19:0]) begin
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
		{{temp_SIDM_carry[3:2]},{result [35:0]}} = {{result_SIDM_carry[3:2]},{result_0 [35:0]}} + {{2'b00},{result_1 [35:0]}};
		{{temp_SIDM_carry[7:6]},{result [53:36]}} = {{result_SIDM_carry[7:6]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};
		{{temp_SIDM_carry[11:10]},{result [71:54]}} = {{result_SIDM_carry[11:10]},{result_0 [71:54]}} + {{2'b00},{result_1 [71:54]}};
		{{temp_SIDM_carry[15:14]},{result [89:72]}} = {{result_SIDM_carry[15:14]},{result_0 [89:72]}} + {{2'b00},{result_1 [89:72]}};

		result_ideal = $signed({{1'b0},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{1'b0},{a[26:18]}})*$signed({{b[26]},{b[26:18]}}) + $signed({{1'b0},{a[44:36]}})*$signed({{b[44]},{b[44:36]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{1'b0},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{1'b0},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:36]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:54]}})*$signed({{b[62]},{b[62:54]}}) + $signed({{1'b0},{a[80:72]}})*$signed({{b[80]},{b[80:72]}}) + $signed({{1'b0},{a[98:90]}})*$signed({{b[98]},{b[98:90]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:54]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[71:63]}})*$signed({{b[71]},{b[71:63]}}) + $signed({{1'b0},{a[89:81]}})*$signed({{b[89]},{b[89:81]}}) + $signed({{1'b0},{a[107:99]}})*$signed({{b[107]},{b[107:99]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:72]}} != result_ideal[19:0]) begin
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
		{{temp_SIDM_carry[3:2]},{result [35:0]}} = {{result_SIDM_carry[3:2]},{result_0 [35:0]}} + {{2'b00},{result_1 [35:0]}};
		{{temp_SIDM_carry[7:6]},{result [53:36]}} = {{result_SIDM_carry[7:6]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};
		{{temp_SIDM_carry[11:10]},{result [71:54]}} = {{result_SIDM_carry[11:10]},{result_0 [71:54]}} + {{2'b00},{result_1 [71:54]}};
		{{temp_SIDM_carry[15:14]},{result [89:72]}} = {{result_SIDM_carry[15:14]},{result_0 [89:72]}} + {{2'b00},{result_1 [89:72]}};

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{1'b0},{b[8:0]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{1'b0},{b[26:18]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{1'b0},{b[44:36]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[17]},{a[17:9]}})*$signed({{1'b0},{b[17:9]}}) + $signed({{a[35]},{a[35:27]}})*$signed({{1'b0},{b[35:27]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{1'b0},{b[53:45]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:36]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:54]}})*$signed({{1'b0},{b[62:54]}}) + $signed({{a[80]},{a[80:72]}})*$signed({{1'b0},{b[80:72]}}) + $signed({{a[98]},{a[98:90]}})*$signed({{1'b0},{b[98:90]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:54]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[71]},{a[71:63]}})*$signed({{1'b0},{b[71:63]}}) + $signed({{a[89]},{a[89:81]}})*$signed({{1'b0},{b[89:81]}}) + $signed({{a[107]},{a[107:99]}})*$signed({{1'b0},{b[107:99]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:72]}} != result_ideal[19:0]) begin
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
		{{temp_SIDM_carry[3:2]},{result [35:0]}} = {{result_SIDM_carry[3:2]},{result_0 [35:0]}} + {{2'b00},{result_1 [35:0]}};
		{{temp_SIDM_carry[7:6]},{result [53:36]}} = {{result_SIDM_carry[7:6]},{result_0 [53:36]}} + {{2'b00},{result_1 [53:36]}};
		{{temp_SIDM_carry[11:10]},{result [71:54]}} = {{result_SIDM_carry[11:10]},{result_0 [71:54]}} + {{2'b00},{result_1 [71:54]}};
		{{temp_SIDM_carry[15:14]},{result [89:72]}} = {{result_SIDM_carry[15:14]},{result_0 [89:72]}} + {{2'b00},{result_1 [89:72]}};

		result_ideal = $signed({{a[8]},{a[8:0]}})*$signed({{b[8]},{b[8:0]}}) + $signed({{a[26]},{a[26:18]}})*$signed({{b[26]},{b[26:18]}}) + $signed({{a[44]},{a[44:36]}})*$signed({{b[44]},{b[44:36]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:18]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[17]},{a[17:9]}})*$signed({{b[17]},{b[17:9]}}) + $signed({{a[35]},{a[35:27]}})*$signed({{b[35]},{b[35:27]}}) + $signed({{a[53]},{a[53:45]}})*$signed({{b[53]},{b[53:45]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:36]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:54]}})*$signed({{b[62]},{b[62:54]}}) + $signed({{a[80]},{a[80:72]}})*$signed({{b[80]},{b[80:72]}}) + $signed({{a[98]},{a[98:90]}})*$signed({{b[98]},{b[98:90]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:54]}} != result_ideal[19:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[71]},{a[71:63]}})*$signed({{b[71]},{b[71:63]}}) + $signed({{a[89]},{a[89:81]}})*$signed({{b[89]},{b[89:81]}}) + $signed({{a[107]},{a[107:99]}})*$signed({{b[107]},{b[107:99]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:72]}} != result_ideal[19:0]) begin
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
		{{temp_SIDM_carry[1:0]},{result [25:0]}} = {{result_SIDM_carry[1:0]},{result_0 [25:0]}} + {{2'b00},{result_1 [25:0]}};
		{{temp_SIDM_carry[3:2]},{result [35:26]}} = {{result_SIDM_carry[3:2]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIDM_carry[5:4]},{result [43:36]}} = {{result_SIDM_carry[5:4]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIDM_carry[7:6]},{result [53:44]}} = {{result_SIDM_carry[7:6]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};
		{{temp_SIDM_carry[9:8]},{result [61:54]}} = {{result_SIDM_carry[9:8]},{result_0 [61:54]}} + {{2'b00},{result_1 [61:54]}};
		{{temp_SIDM_carry[11:10]},{result [71:62]}} = {{result_SIDM_carry[11:10]},{result_0 [71:62]}} + {{2'b00},{result_1 [71:62]}};
		{{temp_SIDM_carry[13:12]},{result [79:72]}} = {{result_SIDM_carry[13:12]},{result_0 [79:72]}} + {{2'b00},{result_1 [79:72]}};
		{{temp_SIDM_carry[15:14]},{result [89:80]}} = {{result_SIDM_carry[15:14]},{result_0 [89:80]}} + {{2'b00},{result_1 [89:80]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{1'b0},{b[21:18]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{1'b0},{b[39:36]}});
		if  ({{temp_SIDM_carry[1:0]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{1'b0},{b[26:23]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{1'b0},{b[44:41]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{1'b0},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  ({{temp_SIDM_carry[5:4]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{1'b0},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:46]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[57:54]}})*$signed({{1'b0},{b[57:54]}}) + $signed({{1'b0},{a[75:72]}})*$signed({{1'b0},{b[75:72]}}) + $signed({{1'b0},{a[93:90]}})*$signed({{1'b0},{b[93:90]}});
		if  ({{temp_SIDM_carry[9:8]},{result[61:54]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:59]}})*$signed({{1'b0},{b[62:59]}}) + $signed({{1'b0},{a[80:77]}})*$signed({{1'b0},{b[80:77]}}) + $signed({{1'b0},{a[98:95]}})*$signed({{1'b0},{b[98:95]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:64]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[66:63]}})*$signed({{1'b0},{b[66:63]}}) + $signed({{1'b0},{a[84:81]}})*$signed({{1'b0},{b[84:81]}}) + $signed({{1'b0},{a[102:99]}})*$signed({{1'b0},{b[102:99]}});
		if  ({{temp_SIDM_carry[13:12]},{result[79:72]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[71:68]}})*$signed({{1'b0},{b[71:68]}}) + $signed({{1'b0},{a[89:86]}})*$signed({{1'b0},{b[89:86]}}) + $signed({{1'b0},{a[107:104]}})*$signed({{1'b0},{b[107:104]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:82]}} != result_ideal[9:0]) begin
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
		{{temp_SIDM_carry[1:0]},{result [25:0]}} = {{result_SIDM_carry[1:0]},{result_0 [25:0]}} + {{2'b00},{result_1 [25:0]}};
		{{temp_SIDM_carry[3:2]},{result [35:26]}} = {{result_SIDM_carry[3:2]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIDM_carry[5:4]},{result [43:36]}} = {{result_SIDM_carry[5:4]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIDM_carry[7:6]},{result [53:44]}} = {{result_SIDM_carry[7:6]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};
		{{temp_SIDM_carry[9:8]},{result [61:54]}} = {{result_SIDM_carry[9:8]},{result_0 [61:54]}} + {{2'b00},{result_1 [61:54]}};
		{{temp_SIDM_carry[11:10]},{result [71:62]}} = {{result_SIDM_carry[11:10]},{result_0 [71:62]}} + {{2'b00},{result_1 [71:62]}};
		{{temp_SIDM_carry[13:12]},{result [79:72]}} = {{result_SIDM_carry[13:12]},{result_0 [79:72]}} + {{2'b00},{result_1 [79:72]}};
		{{temp_SIDM_carry[15:14]},{result [89:80]}} = {{result_SIDM_carry[15:14]},{result_0 [89:80]}} + {{2'b00},{result_1 [89:80]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{1'b0},{a[21:18]}})*$signed({{b[21]},{b[21:18]}}) + $signed({{1'b0},{a[39:36]}})*$signed({{b[39]},{b[39:36]}});
		if  ({{temp_SIDM_carry[1:0]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{1'b0},{a[26:23]}})*$signed({{b[26]},{b[26:23]}}) + $signed({{1'b0},{a[44:41]}})*$signed({{b[44]},{b[44:41]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{1'b0},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{1'b0},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  ({{temp_SIDM_carry[5:4]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{1'b0},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{1'b0},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:46]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[57:54]}})*$signed({{b[57]},{b[57:54]}}) + $signed({{1'b0},{a[75:72]}})*$signed({{b[75]},{b[75:72]}}) + $signed({{1'b0},{a[93:90]}})*$signed({{b[93]},{b[93:90]}});
		if  ({{temp_SIDM_carry[9:8]},{result[61:54]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[62:59]}})*$signed({{b[62]},{b[62:59]}}) + $signed({{1'b0},{a[80:77]}})*$signed({{b[80]},{b[80:77]}}) + $signed({{1'b0},{a[98:95]}})*$signed({{b[98]},{b[98:95]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:64]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[66:63]}})*$signed({{b[66]},{b[66:63]}}) + $signed({{1'b0},{a[84:81]}})*$signed({{b[84]},{b[84:81]}}) + $signed({{1'b0},{a[102:99]}})*$signed({{b[102]},{b[102:99]}});
		if  ({{temp_SIDM_carry[13:12]},{result[79:72]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[71:68]}})*$signed({{b[71]},{b[71:68]}}) + $signed({{1'b0},{a[89:86]}})*$signed({{b[89]},{b[89:86]}}) + $signed({{1'b0},{a[107:104]}})*$signed({{b[107]},{b[107:104]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:82]}} != result_ideal[9:0]) begin
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
		{{temp_SIDM_carry[1:0]},{result [25:0]}} = {{result_SIDM_carry[1:0]},{result_0 [25:0]}} + {{2'b00},{result_1 [25:0]}};
		{{temp_SIDM_carry[3:2]},{result [35:26]}} = {{result_SIDM_carry[3:2]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIDM_carry[5:4]},{result [43:36]}} = {{result_SIDM_carry[5:4]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIDM_carry[7:6]},{result [53:44]}} = {{result_SIDM_carry[7:6]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};
		{{temp_SIDM_carry[9:8]},{result [61:54]}} = {{result_SIDM_carry[9:8]},{result_0 [61:54]}} + {{2'b00},{result_1 [61:54]}};
		{{temp_SIDM_carry[11:10]},{result [71:62]}} = {{result_SIDM_carry[11:10]},{result_0 [71:62]}} + {{2'b00},{result_1 [71:62]}};
		{{temp_SIDM_carry[13:12]},{result [79:72]}} = {{result_SIDM_carry[13:12]},{result_0 [79:72]}} + {{2'b00},{result_1 [79:72]}};
		{{temp_SIDM_carry[15:14]},{result [89:80]}} = {{result_SIDM_carry[15:14]},{result_0 [89:80]}} + {{2'b00},{result_1 [89:80]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{1'b0},{b[21:18]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{1'b0},{b[39:36]}});
		if  ({{temp_SIDM_carry[1:0]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{1'b0},{b[8:5]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{1'b0},{b[26:23]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{1'b0},{b[44:41]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[12]},{a[12:9]}})*$signed({{1'b0},{b[12:9]}}) + $signed({{a[30]},{a[30:27]}})*$signed({{1'b0},{b[30:27]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{1'b0},{b[48:45]}});
		if  ({{temp_SIDM_carry[5:4]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[17]},{a[17:14]}})*$signed({{1'b0},{b[17:14]}}) + $signed({{a[35]},{a[35:32]}})*$signed({{1'b0},{b[35:32]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{1'b0},{b[53:50]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:46]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[57]},{a[57:54]}})*$signed({{1'b0},{b[57:54]}}) + $signed({{a[75]},{a[75:72]}})*$signed({{1'b0},{b[75:72]}}) + $signed({{a[93]},{a[93:90]}})*$signed({{1'b0},{b[93:90]}});
		if  ({{temp_SIDM_carry[9:8]},{result[61:54]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:59]}})*$signed({{1'b0},{b[62:59]}}) + $signed({{a[80]},{a[80:77]}})*$signed({{1'b0},{b[80:77]}}) + $signed({{a[98]},{a[98:95]}})*$signed({{1'b0},{b[98:95]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:64]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[66]},{a[66:63]}})*$signed({{1'b0},{b[66:63]}}) + $signed({{a[84]},{a[84:81]}})*$signed({{1'b0},{b[84:81]}}) + $signed({{a[102]},{a[102:99]}})*$signed({{1'b0},{b[102:99]}});
		if  ({{temp_SIDM_carry[13:12]},{result[79:72]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[71]},{a[71:68]}})*$signed({{1'b0},{b[71:68]}}) + $signed({{a[89]},{a[89:86]}})*$signed({{1'b0},{b[89:86]}}) + $signed({{a[107]},{a[107:104]}})*$signed({{1'b0},{b[107:104]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:82]}} != result_ideal[9:0]) begin
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
		{{temp_SIDM_carry[1:0]},{result [25:0]}} = {{result_SIDM_carry[1:0]},{result_0 [25:0]}} + {{2'b00},{result_1 [25:0]}};
		{{temp_SIDM_carry[3:2]},{result [35:26]}} = {{result_SIDM_carry[3:2]},{result_0 [35:26]}} + {{2'b00},{result_1 [35:26]}};
		{{temp_SIDM_carry[5:4]},{result [43:36]}} = {{result_SIDM_carry[5:4]},{result_0 [43:36]}} + {{2'b00},{result_1 [43:36]}};
		{{temp_SIDM_carry[7:6]},{result [53:44]}} = {{result_SIDM_carry[7:6]},{result_0 [53:44]}} + {{2'b00},{result_1 [53:44]}};
		{{temp_SIDM_carry[9:8]},{result [61:54]}} = {{result_SIDM_carry[9:8]},{result_0 [61:54]}} + {{2'b00},{result_1 [61:54]}};
		{{temp_SIDM_carry[11:10]},{result [71:62]}} = {{result_SIDM_carry[11:10]},{result_0 [71:62]}} + {{2'b00},{result_1 [71:62]}};
		{{temp_SIDM_carry[13:12]},{result [79:72]}} = {{result_SIDM_carry[13:12]},{result_0 [79:72]}} + {{2'b00},{result_1 [79:72]}};
		{{temp_SIDM_carry[15:14]},{result [89:80]}} = {{result_SIDM_carry[15:14]},{result_0 [89:80]}} + {{2'b00},{result_1 [89:80]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{a[21]},{a[21:18]}})*$signed({{b[21]},{b[21:18]}}) + $signed({{a[39]},{a[39:36]}})*$signed({{b[39]},{b[39:36]}});
		if  ({{temp_SIDM_carry[1:0]},{result[25:18]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[8]},{a[8:5]}})*$signed({{b[8]},{b[8:5]}}) + $signed({{a[26]},{a[26:23]}})*$signed({{b[26]},{b[26:23]}}) + $signed({{a[44]},{a[44:41]}})*$signed({{b[44]},{b[44:41]}});
		if  ({{temp_SIDM_carry[3:2]},{result[35:28]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[12]},{a[12:9]}})*$signed({{b[12]},{b[12:9]}}) + $signed({{a[30]},{a[30:27]}})*$signed({{b[30]},{b[30:27]}}) + $signed({{a[48]},{a[48:45]}})*$signed({{b[48]},{b[48:45]}});
		if  ({{temp_SIDM_carry[5:4]},{result[43:36]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[17]},{a[17:14]}})*$signed({{b[17]},{b[17:14]}}) + $signed({{a[35]},{a[35:32]}})*$signed({{b[35]},{b[35:32]}}) + $signed({{a[53]},{a[53:50]}})*$signed({{b[53]},{b[53:50]}});
		if  ({{temp_SIDM_carry[7:6]},{result[53:46]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[57]},{a[57:54]}})*$signed({{b[57]},{b[57:54]}}) + $signed({{a[75]},{a[75:72]}})*$signed({{b[75]},{b[75:72]}}) + $signed({{a[93]},{a[93:90]}})*$signed({{b[93]},{b[93:90]}});
		if  ({{temp_SIDM_carry[9:8]},{result[61:54]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[62]},{a[62:59]}})*$signed({{b[62]},{b[62:59]}}) + $signed({{a[80]},{a[80:77]}})*$signed({{b[80]},{b[80:77]}}) + $signed({{a[98]},{a[98:95]}})*$signed({{b[98]},{b[98:95]}});
		if  ({{temp_SIDM_carry[11:10]},{result[71:64]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[66]},{a[66:63]}})*$signed({{b[66]},{b[66:63]}}) + $signed({{a[84]},{a[84:81]}})*$signed({{b[84]},{b[84:81]}}) + $signed({{a[102]},{a[102:99]}})*$signed({{b[102]},{b[102:99]}});
		if  ({{temp_SIDM_carry[13:12]},{result[79:72]}} != result_ideal[9:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[71]},{a[71:68]}})*$signed({{b[71]},{b[71:68]}}) + $signed({{a[89]},{a[89:86]}})*$signed({{b[89]},{b[89:86]}}) + $signed({{a[107]},{a[107:104]}})*$signed({{b[107]},{b[107:104]}});
		if  ({{temp_SIDM_carry[15:14]},{result[89:82]}} != result_ideal[9:0]) begin
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

multiplier_T_C3x2_F2_54bits_36bits_HighLevelDescribed_auto	multiplier_T_C3x2_F2_54bits_36bits_HighLevelDescribed_auto_inst(
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
