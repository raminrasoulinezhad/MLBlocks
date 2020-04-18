`timescale 1 ns / 100 ps   
module Multiplier_proposed_tb ();

/*******************************************************
*		Simulation Hyper parameters
*******************************************************/
parameter test_max_counter = 10_000;

// functionality modes 
	parameter mode_27x18 		= 2'b00;
	parameter mode_8x8 			= 2'b01;
	parameter mode_sum_9x9 	= 2'b10;
	parameter mode_sum_4x4 	= 2'b11;
	
integer Error_counter;
integer counter;

/*******************************************************
*		Clock generator 
*******************************************************/
	reg clk;
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	
/*******************************************************
*		Inputs  & outputs
*******************************************************/
	reg [53:0] a;
	reg [53:0] b;
	
	reg [8:0] a_0;
	reg [8:0] a_1;
	reg [8:0] a_2;
	reg [8:0] a_3;
	reg [8:0] a_4;
	reg [8:0] a_5;
	
	reg [8:0] b_0;
	reg [8:0] b_1;
	reg [8:0] b_2;
	reg [8:0] b_3;
	reg [8:0] b_4;
	reg [8:0] b_5;
	
	reg [3:0] a_00;
	reg [3:0] a_01;
	reg [3:0] a_02;
	reg [3:0] a_03;
	reg [3:0] a_04;
	reg [3:0] a_05;
	reg [3:0] a_06;
	reg [3:0] a_07;
	reg [3:0] a_08;
	reg [3:0] a_09;
	reg [3:0] a_10;
	reg [3:0] a_11;
	
	reg [3:0] b_00;
	reg [3:0] b_01;
	reg [3:0] b_02;
	reg [3:0] b_03;
	reg [3:0] b_04;
	reg [3:0] b_05;
	reg [3:0] b_06;
	reg [3:0] b_07;
	reg [3:0] b_08;
	reg [3:0] b_09;
	reg [3:0] b_10;
	reg [3:0] b_11;
	
	reg g_0;
	reg g_1;
	reg g_2;
	reg g_3;
	reg g_4;
	reg g_5;
	
	reg a_sign;
	reg b_sign;
	
	reg [1:0] mode;
	
	wire signed [47:0] result1;
	wire signed [47:0] result2;
	reg signed [47:0] result;
	
	reg signed [47:0] result_ideal; ///
	reg signed [17:0] result_ideal_1;
	reg signed [17:0] result_ideal_2;
	reg signed [17:0] result_ideal_3;
	
	reg signed [7:0] result_ideal_01;
	reg signed [7:0] result_ideal_02;
	reg signed [7:0] result_ideal_03;
	reg signed [7:0] result_ideal_04;
	
	initial begin
		Error_counter = 0;
		
		result_ideal_1 = 0;
		result_ideal_2 = 0;
		result_ideal_3 = 0;
		
		result_ideal_01 = 0;
		result_ideal_02 = 0;
		result_ideal_03 = 0;
		result_ideal_04 = 0;
		
		a = 0;
		b = 0;
		{a_5, a_4, a_3, a_2, a_1, a_0} = a;
		{b_5, b_4, b_3, b_2, b_1, b_0} = b;
		{a_11, g_5, a_10, a_09, g_4, a_08, a_07, g_3, a_06, a_05, g_2, a_04, a_03, g_1, a_02, a_01, g_0, a_00} = a;
		{b_11, g_5, b_10, b_09, g_4, b_08, b_07, g_3, b_06, b_05, g_2, b_04, b_03, g_1, b_02, b_01, g_0, b_00} = b;
		

		
		@(posedge clk);
		@(posedge clk);
		
		
		/*******************************************************
		*		check ss su us uu of 27x18
		*******************************************************/
		// check unsigned/unsigned mult 27x18
		$display("Testing Started: test uu/su/us/ss mult 27x18");	
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a=$urandom();
			a[53:27] = 27'b0;
			b = $urandom();
			b [53:18] = 36'b0;
			
			a_sign = 1'b0;
			b_sign = 1'b0;
			mode = mode_27x18;

			#1

			result = result1+result2;
			result_ideal = $unsigned(a[26:0]) * $unsigned(b[17:0]);
			if  ( result_ideal != result) begin
				$display("Error: \tA = %d, B = %d, C = %d", $unsigned(a[26:0]), $unsigned(b[17:0]), $unsigned(result));
				Error_counter = Error_counter + 1;
			end 
			
		end 	
		
		
		// check signed/signed mult 27x18
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a=$random();
			a[53:27] = {27{a[26]}};
			b = $random();
			b [53:18] = {36{b[17]}};
			
			a_sign = 1'b1;
			b_sign = 1'b1;
			mode = mode_27x18;

			#1
			result = result1+result2;
			result_ideal = $signed(a[26:0]) * $signed(b[17:0]);
			if  ( result_ideal != result) begin
				$display("Error: \tA = %d, B = %d, C = %d", $signed(a[26:0]), $signed(b[17:0]), ($signed(result1)+$signed(result2)));
				Error_counter = Error_counter + 1;
			end 
			
		end 	
		 
		// check signed/unsigned mult 27x18
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a=$random();
			a[53:27] = {27{a[26]}};
			b = $urandom();
			b [53:18] = 36'b0;
			
			a_sign = 1'b1;
			b_sign = 1'b0;
			mode = mode_27x18;

			#1
			result = result1+result2;
			result_ideal = $signed(a[26:0]) * $signed({{1'b0},{b[17:0]}}) ;
			if  ( result_ideal != result) begin
				$display("Error: \tA = %d, B = %d, C = %d", $signed(a[26:0]), $unsigned(b[17:0]), ($signed(result1)+$unsigned(result2)));
				Error_counter = Error_counter + 1;
			end 
			
		end 
		
		// check unsigned/signed mult 27x18
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a=$urandom();
			a[53:27] = 27'b0;
			b = $random();
			b [53:18] = {36{b[17]}};
			
			a_sign = 1'b0;
			b_sign = 1'b1;
			mode = mode_27x18;

			#1
			result = result1+result2;
			result_ideal = $signed({{1'b0},{a[26:0]}}) * $signed(b[17:0]) ;
			if  ( result_ideal != result) begin
				$display("Error: \tA = %d, B = %d, C = %d", $unsigned(a[26:0]), $signed(b[17:0]), ($signed(result1)+$unsigned(result2)));
				Error_counter = Error_counter + 1;
			end 
			
		end 
		$display("Testing Finished: test uu/su/us/ss mult 27x18");	
		
		/*******************************************************
		*		check ss su us uu of SIMD 9x9
		*******************************************************/
		// check unsigned/unsigned SIMD 9x9
		$display("Testing Started: test uu/su/us/ss SIMD 9x9");	
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b0;
			b_sign = 1'b0;
			mode = mode_sum_9x9;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_1 = $unsigned(a_0) * $unsigned(b_0) + $unsigned(a_1) * $unsigned(b_1) + $unsigned(a_2) * $unsigned(b_2);
			result_ideal_2 = $unsigned(a_3) * $unsigned(b_3) + $unsigned(a_4) * $unsigned(b_4) + $unsigned(a_5) * $unsigned(b_5);
			result_ideal = {{result_ideal_2},{result_ideal_1}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 	
				
		// check signed/signed SIMD 9x9
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b1;
			b_sign = 1'b1;
			mode = mode_sum_9x9;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_1 = $signed(a_0) * $signed(b_0) + $signed(a_1) * $signed(b_1) + $signed(a_2) * $signed(b_2);
			result_ideal_2 = $signed(a_3) * $signed(b_3) + $signed(a_4) * $signed(b_4) + $signed(a_5) * $signed(b_5);
			result_ideal = {{result_ideal_2},{result_ideal_1}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 
		
		// check signed/unsigned SIMD 9x9
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b1;
			b_sign = 1'b0;
			mode = mode_sum_9x9;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_1 = $signed(a_0) * $signed({{1'b0},{b_0}}) + $signed(a_1) * $signed({{1'b0},{b_1}}) + $signed(a_2) * $signed({{1'b0},{b_2}});
			result_ideal_2 = $signed(a_3) * $signed({{1'b0},{b_3}}) + $signed(a_4) * $signed({{1'b0},{b_4}}) + $signed(a_5) * $signed({{1'b0},{b_5}});
			result_ideal = {{result_ideal_2},{result_ideal_1}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 
		
		
		// check unsigned/signed SIMD 9x9
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);

			a = $random();
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b0;
			b_sign = 1'b1;
			mode = mode_sum_9x9;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_1 = $signed({{1'b0},{a_0}}) * $signed(b_0) + $signed({{1'b0},{a_1}}) * $signed(b_1) + $signed({{1'b0},{a_2}}) * $signed(b_2);
			result_ideal_2 = $signed({{1'b0},{a_3}}) * $signed(b_3) + $signed({{1'b0},{a_4}}) * $signed(b_4) + $signed({{1'b0},{a_5}}) * $signed(b_5);
			result_ideal = {{result_ideal_2},{result_ideal_1}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 
		$display("Testing Finished: test uu/su/us/ss SIMD 9x9");
		
		/*******************************************************
		*		check ss su us uu of SIMD 4x4
		*******************************************************/
		// check unsigned/unsigned SIMD 4x4
		$display("Testing Started: test uu/su/us/ss SIMD 4x4");
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a_11, g_5, a_10, a_09, g_4, a_08, a_07, g_3, a_06, a_05, g_2, a_04, a_03, g_1, a_02, a_01, g_0, a_00} = a;
	
			b = $random();
			{b_11, g_5, b_10, b_09, g_4, b_08, b_07, g_3, b_06, b_05, g_2, b_04, b_03, g_1, b_02, b_01, g_0, b_00} = b;
			
			a_sign = 1'b0;
			b_sign = 1'b0;
			mode = mode_sum_4x4;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_01 = $unsigned(a_00) * $unsigned(b_00) + $unsigned(a_02) * $unsigned(b_02) + $unsigned(a_04) * $unsigned(b_04);
			result_ideal_02 = $unsigned(a_01) * $unsigned(b_01) + $unsigned(a_03) * $unsigned(b_03) + $unsigned(a_05) * $unsigned(b_05);
			result_ideal_03 = $unsigned(a_06) * $unsigned(b_06) + $unsigned(a_08) * $unsigned(b_08) + $unsigned(a_10) * $unsigned(b_10);
			result_ideal_04 = $unsigned(a_07) * $unsigned(b_07) + $unsigned(a_09) * $unsigned(b_09) + $unsigned(a_11) * $unsigned(b_11);
			result_ideal = {{result_ideal_04}, {2'b00}, {result_ideal_03},{result_ideal_02},{2'b00},{result_ideal_01}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 	
		
		// check signed/signed SIMD 4x4
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a_11, g_5, a_10, a_09, g_4, a_08, a_07, g_3, a_06, a_05, g_2, a_04, a_03, g_1, a_02, a_01, g_0, a_00} = a;
	
			b = $random();
			{b_11, g_5, b_10, b_09, g_4, b_08, b_07, g_3, b_06, b_05, g_2, b_04, b_03, g_1, b_02, b_01, g_0, b_00} = b;
			
			a_sign = 1'b1;
			b_sign = 1'b1;
			mode = mode_sum_4x4;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_01 = $signed(a_00) * $signed(b_00) + $signed(a_02) * $signed(b_02) + $signed(a_04) * $signed(b_04);
			result_ideal_02 = $signed(a_01) * $signed(b_01) + $signed(a_03) * $signed(b_03) + $signed(a_05) * $signed(b_05);
			result_ideal_03 = $signed(a_06) * $signed(b_06) + $signed(a_08) * $signed(b_08) + $signed(a_10) * $signed(b_10);
			result_ideal_04 = $signed(a_07) * $signed(b_07) + $signed(a_09) * $signed(b_09) + $signed(a_11) * $signed(b_11);
			result_ideal = {{result_ideal_04}, {2'b00}, {result_ideal_03},{result_ideal_02},{2'b00},{result_ideal_01}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 	
		
		// check signed/unsigned SIMD 4x4
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a_11, g_5, a_10, a_09, g_4, a_08, a_07, g_3, a_06, a_05, g_2, a_04, a_03, g_1, a_02, a_01, g_0, a_00} = a;
	
			b = $random();
			{b_11, g_5, b_10, b_09, g_4, b_08, b_07, g_3, b_06, b_05, g_2, b_04, b_03, g_1, b_02, b_01, g_0, b_00} = b;
			
			a_sign = 1'b1;
			b_sign = 1'b0;
			mode = mode_sum_4x4;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_01 = $signed(a_00) * $signed({{1'b0},{b_00}}) + $signed(a_02) * $signed({{1'b0},{b_02}}) + $signed(a_04) * $signed({{1'b0},{b_04}});
			result_ideal_02 = $signed(a_01) * $signed({{1'b0},{b_01}}) + $signed(a_03) * $signed({{1'b0},{b_03}}) + $signed(a_05) * $signed({{1'b0},{b_05}});
			result_ideal_03 = $signed(a_06) * $signed({{1'b0},{b_06}}) + $signed(a_08) * $signed({{1'b0},{b_08}}) + $signed(a_10) * $signed({{1'b0},{b_10}});
			result_ideal_04 = $signed(a_07) * $signed({{1'b0},{b_07}}) + $signed(a_09) * $signed({{1'b0},{b_09}}) + $signed(a_11) * $signed({{1'b0},{b_11}});
			result_ideal = {{result_ideal_04}, {2'b00}, {result_ideal_03},{result_ideal_02},{2'b00},{result_ideal_01}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 	
		
		// check unsigned/signed SIMD 4x4
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a_11, g_5, a_10, a_09, g_4, a_08, a_07, g_3, a_06, a_05, g_2, a_04, a_03, g_1, a_02, a_01, g_0, a_00} = a;
	
			b = $random();
			{b_11, g_5, b_10, b_09, g_4, b_08, b_07, g_3, b_06, b_05, g_2, b_04, b_03, g_1, b_02, b_01, g_0, b_00} = b;
			
			a_sign = 1'b0;
			b_sign = 1'b1;
			mode = mode_sum_4x4;

			#1

			result[26:0] = result1[26:0];
			result[44:27] = result2[44:27];
			result_ideal_01 = $signed({{1'b0},{a_00}}) * $signed(b_00) + $signed({{1'b0},{a_02}}) * $signed(b_02) + $signed({{1'b0},{a_04}}) * $signed(b_04);
			result_ideal_02 = $signed({{1'b0},{a_01}}) * $signed(b_01) + $signed({{1'b0},{a_03}}) * $signed(b_03) + $signed({{1'b0},{a_05}}) * $signed(b_05);
			result_ideal_03 = $signed({{1'b0},{a_06}}) * $signed(b_06) + $signed({{1'b0},{a_08}}) * $signed(b_08) + $signed({{1'b0},{a_10}}) * $signed(b_10);
			result_ideal_04 = $signed({{1'b0},{a_07}}) * $signed(b_07) + $signed({{1'b0},{a_09}}) * $signed(b_09) + $signed({{1'b0},{a_11}}) * $signed(b_11);
			result_ideal = {{result_ideal_04}, {2'b00}, {result_ideal_03},{result_ideal_02},{2'b00},{result_ideal_01}};
			
			if  ( result_ideal != result[44:9]) begin
				Error_counter = Error_counter + 1;
			end 
		end 	
		$display("Testing Finished: test uu/su/us/ss SIMD 4x4");
		
		/*******************************************************
		*		check ss su us uu of SIMD 8x8
		*******************************************************/
		// check unsigned/unsigned SIMD 8x8
		$display("Testing Started: test uu/su/us/ss SIMD 8x8");
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a[53],a[44],a[35],a[26],a[17],a[8]} = 6'b0;
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b[53],b[44],b[35],b[26],b[17],b[8]} = 6'b0;
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b0;
			b_sign = 1'b0;
			mode = mode_8x8;

			#1

			result[15:0] = result1[15:0] + result2[15:0];
			result[31:16] = result1[31:16] + result2[31:16];
			result[47:32] = result1[47:32] + result2[47:32];

			result_ideal_1 = $unsigned(a_0) * $unsigned(b_0) + $unsigned(a_3) * $unsigned(b_3);
			result_ideal_2 = $unsigned(a_1) * $unsigned(b_1) + $unsigned(a_4) * $unsigned(b_4);
			result_ideal_3 = $unsigned(a_2) * $unsigned(b_2) + $unsigned(a_5) * $unsigned(b_5);
			result_ideal = {{result_ideal_3[15:0]},{result_ideal_2[15:0]},{result_ideal_1[15:0]}};
			
			if  ( result_ideal != result) begin
				Error_counter = Error_counter + 1;
			end 
			
		end 	

		
		// check signed/signed SIMD 8x8
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a[53],a[44],a[35],a[26],a[17],a[8]} = {a[52],a[43],a[34],a[25],a[16],a[7]};
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b[53],b[44],b[35],b[26],b[17],b[8]} = {b[52],b[43],b[34],b[25],b[16],b[7]};
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b1;
			b_sign = 1'b1;
			mode = mode_8x8;

			#1

			result[15:0] = result1[15:0] + result2[15:0];
			result[31:16] = result1[31:16] + result2[31:16];
			result[47:32] = result1[47:32] + result2[47:32];

			result_ideal_1 = $signed(a_0) * $signed(b_0) + $signed(a_3) * $signed(b_3);
			result_ideal_2 = $signed(a_1) * $signed(b_1) + $signed(a_4) * $signed(b_4);
			result_ideal_3 = $signed(a_2) * $signed(b_2) + $signed(a_5) * $signed(b_5);
			result_ideal = {{result_ideal_3[15:0]},{result_ideal_2[15:0]},{result_ideal_1[15:0]}};
			
			if  ( result_ideal != result) begin
				Error_counter = Error_counter + 1;
			end 
			
		end 	
		
		
		// check signed/unsigned SIMD 8x8
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a[53],a[44],a[35],a[26],a[17],a[8]} = {a[52],a[43],a[34],a[25],a[16],a[7]};
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b[53],b[44],b[35],b[26],b[17],b[8]} = 6'b0;
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b1;
			b_sign = 1'b0;
			mode = mode_8x8;

			#1

			result[15:0] = result1[15:0] + result2[15:0];
			result[31:16] = result1[31:16] + result2[31:16];
			result[47:32] = result1[47:32] + result2[47:32];

			result_ideal_1 = $signed(a_0) * $signed(b_0) + $signed(a_3) * $signed(b_3);
			result_ideal_2 = $signed(a_1) * $signed(b_1) + $signed(a_4) * $signed(b_4);
			result_ideal_3 = $signed(a_2) * $signed(b_2) + $signed(a_5) * $signed(b_5);
			result_ideal = {{result_ideal_3[15:0]},{result_ideal_2[15:0]},{result_ideal_1[15:0]}};
			
			if  ( result_ideal != result) begin
				Error_counter = Error_counter + 1;
			end 
			
		end 	
		
		// check unsigned/signed SIMD 8x8
		for (counter = 0; counter < test_max_counter; counter = counter + 1) begin 
			@(posedge clk);
			
			a = $random();
			{a[53],a[44],a[35],a[26],a[17],a[8]} = 6'b0;
			{a_5, a_4, a_3, a_2, a_1, a_0} = a;
	
			b = $random();
			{b[53],b[44],b[35],b[26],b[17],b[8]} = {b[52],b[43],b[34],b[25],b[16],b[7]};
			{b_5, b_4, b_3, b_2, b_1, b_0} = b;
			
			a_sign = 1'b0;
			b_sign = 1'b1;
			mode = mode_8x8;

			#1

			result[15:0] = result1[15:0] + result2[15:0];
			result[31:16] = result1[31:16] + result2[31:16];
			result[47:32] = result1[47:32] + result2[47:32];

			result_ideal_1 = $signed(a_0) * $signed(b_0) + $signed(a_3) * $signed(b_3);
			result_ideal_2 = $signed(a_1) * $signed(b_1) + $signed(a_4) * $signed(b_4);
			result_ideal_3 = $signed(a_2) * $signed(b_2) + $signed(a_5) * $signed(b_5);
			result_ideal = {{result_ideal_3[15:0]},{result_ideal_2[15:0]},{result_ideal_1[15:0]}};
			
			if  ( result_ideal != result) begin
				Error_counter = Error_counter + 1;
			end 
			
		end 	
		$display("Testing Finished: test uu/su/us/ss SIMD 8x8");
		
		
		
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
	
	
	
Multiplier_proposed			Multiplier_proposed_inst(
		.a(a),
		.b(b),
		
		.a_sign(a_sign),
		.b_sign(b_sign),
		
		.mode(mode),
		
		.result1(result1),
		.result2(result2)
 	); 

endmodule 
