`timescale 1 ns / 100 ps  
module multiplier_T_C2x2_F2_16bits_16bits_HighLevelDescribed_auto_tb();

/*******************************************************
*	Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 100;

// functionality modes 
parameter mode_16x16	= 2'b00;
parameter mode_sum_8x8	= 2'b1;
parameter mode_sum_4x4	= 2'b10;
parameter mode_sum_2x2	= 2'b11;
reg [2:0] mode;

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

wire [7:0] result_SIDM_carry;
reg [7:0] temp_SIDM_carry;

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
		{{temp_SIDM_carry[3:3]},{result [15:0]}} = {{result_SIDM_carry[3:3]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIDM_carry[7:7]},{result [31:16]}} = {{result_SIDM_carry[7:7]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{1'b0},{b[7:0]}}) + $signed({{1'b0},{a[15:8]}})*$signed({{1'b0},{b[15:8]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:16]}})*$signed({{1'b0},{b[23:16]}}) + $signed({{1'b0},{a[31:24]}})*$signed({{1'b0},{b[31:24]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:16]}} != result_ideal[16:0]) begin
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
		{{temp_SIDM_carry[3:3]},{result [15:0]}} = {{result_SIDM_carry[3:3]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIDM_carry[7:7]},{result [31:16]}} = {{result_SIDM_carry[7:7]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{1'b0},{a[7:0]}})*$signed({{b[7]},{b[7:0]}}) + $signed({{1'b0},{a[15:8]}})*$signed({{b[15]},{b[15:8]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:16]}})*$signed({{b[23]},{b[23:16]}}) + $signed({{1'b0},{a[31:24]}})*$signed({{b[31]},{b[31:24]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:16]}} != result_ideal[16:0]) begin
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
		{{temp_SIDM_carry[3:3]},{result [15:0]}} = {{result_SIDM_carry[3:3]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIDM_carry[7:7]},{result [31:16]}} = {{result_SIDM_carry[7:7]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{1'b0},{b[7:0]}}) + $signed({{a[15]},{a[15:8]}})*$signed({{1'b0},{b[15:8]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:16]}})*$signed({{1'b0},{b[23:16]}}) + $signed({{a[31]},{a[31:24]}})*$signed({{1'b0},{b[31:24]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:16]}} != result_ideal[16:0]) begin
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
		{{temp_SIDM_carry[3:3]},{result [15:0]}} = {{result_SIDM_carry[3:3]},{result_0 [15:0]}} + {{2'b00},{result_1 [15:0]}};
		{{temp_SIDM_carry[7:7]},{result [31:16]}} = {{result_SIDM_carry[7:7]},{result_0 [31:16]}} + {{2'b00},{result_1 [31:16]}};

		result_ideal = $signed({{a[7]},{a[7:0]}})*$signed({{b[7]},{b[7:0]}}) + $signed({{a[15]},{a[15:8]}})*$signed({{b[15]},{b[15:8]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:0]}} != result_ideal[16:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:16]}})*$signed({{b[23]},{b[23:16]}}) + $signed({{a[31]},{a[31:24]}})*$signed({{b[31]},{b[31:24]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:16]}} != result_ideal[16:0]) begin
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
		{{temp_SIDM_carry[1:1]},{result [7:0]}} = {{result_SIDM_carry[1:1]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIDM_carry[3:3]},{result [15:8]}} = {{result_SIDM_carry[3:3]},{result_0 [15:8]}} + {{2'b00},{result_1 [15:8]}};
		{{temp_SIDM_carry[5:5]},{result [23:16]}} = {{result_SIDM_carry[5:5]},{result_0 [23:16]}} + {{2'b00},{result_1 [23:16]}};
		{{temp_SIDM_carry[7:7]},{result [31:24]}} = {{result_SIDM_carry[7:7]},{result_0 [31:24]}} + {{2'b00},{result_1 [31:24]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{1'b0},{a[11:8]}})*$signed({{1'b0},{b[11:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:0]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[7:4]}})*$signed({{1'b0},{b[7:4]}}) + $signed({{1'b0},{a[15:12]}})*$signed({{1'b0},{b[15:12]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:8]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[19:16]}})*$signed({{1'b0},{b[19:16]}}) + $signed({{1'b0},{a[27:24]}})*$signed({{1'b0},{b[27:24]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:16]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:20]}})*$signed({{1'b0},{b[23:20]}}) + $signed({{1'b0},{a[31:28]}})*$signed({{1'b0},{b[31:28]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:24]}} != result_ideal[8:0]) begin
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
		{{temp_SIDM_carry[1:1]},{result [7:0]}} = {{result_SIDM_carry[1:1]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIDM_carry[3:3]},{result [15:8]}} = {{result_SIDM_carry[3:3]},{result_0 [15:8]}} + {{2'b00},{result_1 [15:8]}};
		{{temp_SIDM_carry[5:5]},{result [23:16]}} = {{result_SIDM_carry[5:5]},{result_0 [23:16]}} + {{2'b00},{result_1 [23:16]}};
		{{temp_SIDM_carry[7:7]},{result [31:24]}} = {{result_SIDM_carry[7:7]},{result_0 [31:24]}} + {{2'b00},{result_1 [31:24]}};

		result_ideal = $signed({{1'b0},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{1'b0},{a[11:8]}})*$signed({{b[11]},{b[11:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:0]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[7:4]}})*$signed({{b[7]},{b[7:4]}}) + $signed({{1'b0},{a[15:12]}})*$signed({{b[15]},{b[15:12]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:8]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[19:16]}})*$signed({{b[19]},{b[19:16]}}) + $signed({{1'b0},{a[27:24]}})*$signed({{b[27]},{b[27:24]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:16]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:20]}})*$signed({{b[23]},{b[23:20]}}) + $signed({{1'b0},{a[31:28]}})*$signed({{b[31]},{b[31:28]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:24]}} != result_ideal[8:0]) begin
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
		{{temp_SIDM_carry[1:1]},{result [7:0]}} = {{result_SIDM_carry[1:1]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIDM_carry[3:3]},{result [15:8]}} = {{result_SIDM_carry[3:3]},{result_0 [15:8]}} + {{2'b00},{result_1 [15:8]}};
		{{temp_SIDM_carry[5:5]},{result [23:16]}} = {{result_SIDM_carry[5:5]},{result_0 [23:16]}} + {{2'b00},{result_1 [23:16]}};
		{{temp_SIDM_carry[7:7]},{result [31:24]}} = {{result_SIDM_carry[7:7]},{result_0 [31:24]}} + {{2'b00},{result_1 [31:24]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{1'b0},{b[3:0]}}) + $signed({{a[11]},{a[11:8]}})*$signed({{1'b0},{b[11:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:0]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[7]},{a[7:4]}})*$signed({{1'b0},{b[7:4]}}) + $signed({{a[15]},{a[15:12]}})*$signed({{1'b0},{b[15:12]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:8]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[19]},{a[19:16]}})*$signed({{1'b0},{b[19:16]}}) + $signed({{a[27]},{a[27:24]}})*$signed({{1'b0},{b[27:24]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:16]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:20]}})*$signed({{1'b0},{b[23:20]}}) + $signed({{a[31]},{a[31:28]}})*$signed({{1'b0},{b[31:28]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:24]}} != result_ideal[8:0]) begin
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
		{{temp_SIDM_carry[1:1]},{result [7:0]}} = {{result_SIDM_carry[1:1]},{result_0 [7:0]}} + {{2'b00},{result_1 [7:0]}};
		{{temp_SIDM_carry[3:3]},{result [15:8]}} = {{result_SIDM_carry[3:3]},{result_0 [15:8]}} + {{2'b00},{result_1 [15:8]}};
		{{temp_SIDM_carry[5:5]},{result [23:16]}} = {{result_SIDM_carry[5:5]},{result_0 [23:16]}} + {{2'b00},{result_1 [23:16]}};
		{{temp_SIDM_carry[7:7]},{result [31:24]}} = {{result_SIDM_carry[7:7]},{result_0 [31:24]}} + {{2'b00},{result_1 [31:24]}};

		result_ideal = $signed({{a[3]},{a[3:0]}})*$signed({{b[3]},{b[3:0]}}) + $signed({{a[11]},{a[11:8]}})*$signed({{b[11]},{b[11:8]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:0]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[7]},{a[7:4]}})*$signed({{b[7]},{b[7:4]}}) + $signed({{a[15]},{a[15:12]}})*$signed({{b[15]},{b[15:12]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:8]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[19]},{a[19:16]}})*$signed({{b[19]},{b[19:16]}}) + $signed({{a[27]},{a[27:24]}})*$signed({{b[27]},{b[27:24]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:16]}} != result_ideal[8:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:20]}})*$signed({{b[23]},{b[23:20]}}) + $signed({{a[31]},{a[31:28]}})*$signed({{b[31]},{b[31:28]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:24]}} != result_ideal[8:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [3:0]}} = {{result_SIDM_carry[0:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIDM_carry[1:1]},{result [7:4]}} = {{result_SIDM_carry[1:1]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIDM_carry[2:2]},{result [11:8]}} = {{result_SIDM_carry[2:2]},{result_0 [11:8]}} + {{2'b00},{result_1 [11:8]}};
		{{temp_SIDM_carry[3:3]},{result [15:12]}} = {{result_SIDM_carry[3:3]},{result_0 [15:12]}} + {{2'b00},{result_1 [15:12]}};
		{{temp_SIDM_carry[4:4]},{result [19:16]}} = {{result_SIDM_carry[4:4]},{result_0 [19:16]}} + {{2'b00},{result_1 [19:16]}};
		{{temp_SIDM_carry[5:5]},{result [23:20]}} = {{result_SIDM_carry[5:5]},{result_0 [23:20]}} + {{2'b00},{result_1 [23:20]}};
		{{temp_SIDM_carry[6:6]},{result [27:24]}} = {{result_SIDM_carry[6:6]},{result_0 [27:24]}} + {{2'b00},{result_1 [27:24]}};
		{{temp_SIDM_carry[7:7]},{result [31:28]}} = {{result_SIDM_carry[7:7]},{result_0 [31:28]}} + {{2'b00},{result_1 [31:28]}};

		result_ideal = $signed({{1'b0},{a[1:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{1'b0},{a[9:8]}})*$signed({{1'b0},{b[9:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[3:0]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[3:2]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{1'b0},{a[11:10]}})*$signed({{1'b0},{b[11:10]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:4]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[5:4]}})*$signed({{1'b0},{b[5:4]}}) + $signed({{1'b0},{a[13:12]}})*$signed({{1'b0},{b[13:12]}});
		if  ({{temp_SIDM_carry[2:2]},{result[11:8]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[7:6]}})*$signed({{1'b0},{b[7:6]}}) + $signed({{1'b0},{a[15:14]}})*$signed({{1'b0},{b[15:14]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:12]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[17:16]}})*$signed({{1'b0},{b[17:16]}}) + $signed({{1'b0},{a[25:24]}})*$signed({{1'b0},{b[25:24]}});
		if  ({{temp_SIDM_carry[4:4]},{result[19:16]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[19:18]}})*$signed({{1'b0},{b[19:18]}}) + $signed({{1'b0},{a[27:26]}})*$signed({{1'b0},{b[27:26]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:20]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[21:20]}})*$signed({{1'b0},{b[21:20]}}) + $signed({{1'b0},{a[29:28]}})*$signed({{1'b0},{b[29:28]}});
		if  ({{temp_SIDM_carry[6:6]},{result[27:24]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:22]}})*$signed({{1'b0},{b[23:22]}}) + $signed({{1'b0},{a[31:30]}})*$signed({{1'b0},{b[31:30]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:28]}} != result_ideal[4:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [3:0]}} = {{result_SIDM_carry[0:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIDM_carry[1:1]},{result [7:4]}} = {{result_SIDM_carry[1:1]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIDM_carry[2:2]},{result [11:8]}} = {{result_SIDM_carry[2:2]},{result_0 [11:8]}} + {{2'b00},{result_1 [11:8]}};
		{{temp_SIDM_carry[3:3]},{result [15:12]}} = {{result_SIDM_carry[3:3]},{result_0 [15:12]}} + {{2'b00},{result_1 [15:12]}};
		{{temp_SIDM_carry[4:4]},{result [19:16]}} = {{result_SIDM_carry[4:4]},{result_0 [19:16]}} + {{2'b00},{result_1 [19:16]}};
		{{temp_SIDM_carry[5:5]},{result [23:20]}} = {{result_SIDM_carry[5:5]},{result_0 [23:20]}} + {{2'b00},{result_1 [23:20]}};
		{{temp_SIDM_carry[6:6]},{result [27:24]}} = {{result_SIDM_carry[6:6]},{result_0 [27:24]}} + {{2'b00},{result_1 [27:24]}};
		{{temp_SIDM_carry[7:7]},{result [31:28]}} = {{result_SIDM_carry[7:7]},{result_0 [31:28]}} + {{2'b00},{result_1 [31:28]}};

		result_ideal = $signed({{1'b0},{a[1:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{1'b0},{a[9:8]}})*$signed({{b[9]},{b[9:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[3:0]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[3:2]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{1'b0},{a[11:10]}})*$signed({{b[11]},{b[11:10]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:4]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[5:4]}})*$signed({{b[5]},{b[5:4]}}) + $signed({{1'b0},{a[13:12]}})*$signed({{b[13]},{b[13:12]}});
		if  ({{temp_SIDM_carry[2:2]},{result[11:8]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[7:6]}})*$signed({{b[7]},{b[7:6]}}) + $signed({{1'b0},{a[15:14]}})*$signed({{b[15]},{b[15:14]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:12]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[17:16]}})*$signed({{b[17]},{b[17:16]}}) + $signed({{1'b0},{a[25:24]}})*$signed({{b[25]},{b[25:24]}});
		if  ({{temp_SIDM_carry[4:4]},{result[19:16]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[19:18]}})*$signed({{b[19]},{b[19:18]}}) + $signed({{1'b0},{a[27:26]}})*$signed({{b[27]},{b[27:26]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:20]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[21:20]}})*$signed({{b[21]},{b[21:20]}}) + $signed({{1'b0},{a[29:28]}})*$signed({{b[29]},{b[29:28]}});
		if  ({{temp_SIDM_carry[6:6]},{result[27:24]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{1'b0},{a[23:22]}})*$signed({{b[23]},{b[23:22]}}) + $signed({{1'b0},{a[31:30]}})*$signed({{b[31]},{b[31:30]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:28]}} != result_ideal[4:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [3:0]}} = {{result_SIDM_carry[0:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIDM_carry[1:1]},{result [7:4]}} = {{result_SIDM_carry[1:1]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIDM_carry[2:2]},{result [11:8]}} = {{result_SIDM_carry[2:2]},{result_0 [11:8]}} + {{2'b00},{result_1 [11:8]}};
		{{temp_SIDM_carry[3:3]},{result [15:12]}} = {{result_SIDM_carry[3:3]},{result_0 [15:12]}} + {{2'b00},{result_1 [15:12]}};
		{{temp_SIDM_carry[4:4]},{result [19:16]}} = {{result_SIDM_carry[4:4]},{result_0 [19:16]}} + {{2'b00},{result_1 [19:16]}};
		{{temp_SIDM_carry[5:5]},{result [23:20]}} = {{result_SIDM_carry[5:5]},{result_0 [23:20]}} + {{2'b00},{result_1 [23:20]}};
		{{temp_SIDM_carry[6:6]},{result [27:24]}} = {{result_SIDM_carry[6:6]},{result_0 [27:24]}} + {{2'b00},{result_1 [27:24]}};
		{{temp_SIDM_carry[7:7]},{result [31:28]}} = {{result_SIDM_carry[7:7]},{result_0 [31:28]}} + {{2'b00},{result_1 [31:28]}};

		result_ideal = $signed({{a[1]},{a[1:0]}})*$signed({{1'b0},{b[1:0]}}) + $signed({{a[9]},{a[9:8]}})*$signed({{1'b0},{b[9:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[3:0]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[3]},{a[3:2]}})*$signed({{1'b0},{b[3:2]}}) + $signed({{a[11]},{a[11:10]}})*$signed({{1'b0},{b[11:10]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:4]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[5]},{a[5:4]}})*$signed({{1'b0},{b[5:4]}}) + $signed({{a[13]},{a[13:12]}})*$signed({{1'b0},{b[13:12]}});
		if  ({{temp_SIDM_carry[2:2]},{result[11:8]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[7]},{a[7:6]}})*$signed({{1'b0},{b[7:6]}}) + $signed({{a[15]},{a[15:14]}})*$signed({{1'b0},{b[15:14]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:12]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[17]},{a[17:16]}})*$signed({{1'b0},{b[17:16]}}) + $signed({{a[25]},{a[25:24]}})*$signed({{1'b0},{b[25:24]}});
		if  ({{temp_SIDM_carry[4:4]},{result[19:16]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[19]},{a[19:18]}})*$signed({{1'b0},{b[19:18]}}) + $signed({{a[27]},{a[27:26]}})*$signed({{1'b0},{b[27:26]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:20]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[21]},{a[21:20]}})*$signed({{1'b0},{b[21:20]}}) + $signed({{a[29]},{a[29:28]}})*$signed({{1'b0},{b[29:28]}});
		if  ({{temp_SIDM_carry[6:6]},{result[27:24]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:22]}})*$signed({{1'b0},{b[23:22]}}) + $signed({{a[31]},{a[31:30]}})*$signed({{1'b0},{b[31:30]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:28]}} != result_ideal[4:0]) begin
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
		{{temp_SIDM_carry[0:0]},{result [3:0]}} = {{result_SIDM_carry[0:0]},{result_0 [3:0]}} + {{2'b00},{result_1 [3:0]}};
		{{temp_SIDM_carry[1:1]},{result [7:4]}} = {{result_SIDM_carry[1:1]},{result_0 [7:4]}} + {{2'b00},{result_1 [7:4]}};
		{{temp_SIDM_carry[2:2]},{result [11:8]}} = {{result_SIDM_carry[2:2]},{result_0 [11:8]}} + {{2'b00},{result_1 [11:8]}};
		{{temp_SIDM_carry[3:3]},{result [15:12]}} = {{result_SIDM_carry[3:3]},{result_0 [15:12]}} + {{2'b00},{result_1 [15:12]}};
		{{temp_SIDM_carry[4:4]},{result [19:16]}} = {{result_SIDM_carry[4:4]},{result_0 [19:16]}} + {{2'b00},{result_1 [19:16]}};
		{{temp_SIDM_carry[5:5]},{result [23:20]}} = {{result_SIDM_carry[5:5]},{result_0 [23:20]}} + {{2'b00},{result_1 [23:20]}};
		{{temp_SIDM_carry[6:6]},{result [27:24]}} = {{result_SIDM_carry[6:6]},{result_0 [27:24]}} + {{2'b00},{result_1 [27:24]}};
		{{temp_SIDM_carry[7:7]},{result [31:28]}} = {{result_SIDM_carry[7:7]},{result_0 [31:28]}} + {{2'b00},{result_1 [31:28]}};

		result_ideal = $signed({{a[1]},{a[1:0]}})*$signed({{b[1]},{b[1:0]}}) + $signed({{a[9]},{a[9:8]}})*$signed({{b[9]},{b[9:8]}});
		if  ({{temp_SIDM_carry[0:0]},{result[3:0]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[3]},{a[3:2]}})*$signed({{b[3]},{b[3:2]}}) + $signed({{a[11]},{a[11:10]}})*$signed({{b[11]},{b[11:10]}});
		if  ({{temp_SIDM_carry[1:1]},{result[7:4]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[5]},{a[5:4]}})*$signed({{b[5]},{b[5:4]}}) + $signed({{a[13]},{a[13:12]}})*$signed({{b[13]},{b[13:12]}});
		if  ({{temp_SIDM_carry[2:2]},{result[11:8]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[7]},{a[7:6]}})*$signed({{b[7]},{b[7:6]}}) + $signed({{a[15]},{a[15:14]}})*$signed({{b[15]},{b[15:14]}});
		if  ({{temp_SIDM_carry[3:3]},{result[15:12]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[17]},{a[17:16]}})*$signed({{b[17]},{b[17:16]}}) + $signed({{a[25]},{a[25:24]}})*$signed({{b[25]},{b[25:24]}});
		if  ({{temp_SIDM_carry[4:4]},{result[19:16]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[19]},{a[19:18]}})*$signed({{b[19]},{b[19:18]}}) + $signed({{a[27]},{a[27:26]}})*$signed({{b[27]},{b[27:26]}});
		if  ({{temp_SIDM_carry[5:5]},{result[23:20]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[21]},{a[21:20]}})*$signed({{b[21]},{b[21:20]}}) + $signed({{a[29]},{a[29:28]}})*$signed({{b[29]},{b[29:28]}});
		if  ({{temp_SIDM_carry[6:6]},{result[27:24]}} != result_ideal[4:0]) begin
			Error_counter = Error_counter + 1;
		end

		result_ideal = $signed({{a[23]},{a[23:22]}})*$signed({{b[23]},{b[23:22]}}) + $signed({{a[31]},{a[31:30]}})*$signed({{b[31]},{b[31:30]}});
		if  ({{temp_SIDM_carry[7:7]},{result[31:28]}} != result_ideal[4:0]) begin
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

multiplier_T_C2x2_F2_16bits_16bits_HighLevelDescribed_auto	multiplier_T_C2x2_F2_16bits_16bits_HighLevelDescribed_auto_inst(
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
