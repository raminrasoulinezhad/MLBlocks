`timescale 1 ns / 100 ps   
module DSP_tb ();

/*******************************************************
*		Simulation Hyper parameters
*******************************************************/
parameter start_of_loading_configuration_bits = 2;
parameter reset_clock_period_counter = 2;
parameter simulation_start_clock_guard = 10;

parameter test_repeat_multiplier = 10000;
parameter test_repeat_mac = 10000;
parameter test_repeat_xor = 10000;
parameter test_repeat_pattern_detection = 10000;
parameter test_repeat_SIMD_ADDSUB = 10000;

integer Error_counter;
integer fscanf_output;
/*******************************************************
*		Clock generator 
*******************************************************/
	reg clk;
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
/*******************************************************
*		Loading Bit Stream file on configurable bits 
*******************************************************/
	
	parameter configurationbits_size = 205;
	// source of this lines: http://verilogcodes.blogspot.com/2017/11/file-reading-and-writingline-by-line-in.html
	// Great source http://www.angelfire.com/in/verilogfaq/pli.html
	// file identifier
    integer file_bitsream; 
	// string reader
	reg [100*8-1:0] string;

	integer i, j;
	
	reg [47:0] temp; 
	integer temp_size;
	reg [configurationbits_size-1:0] configurationbits;
	
	// read bit stream file 
	initial begin
		file_bitsream=$fopen("bitsream.txt","r"); 
		fscanf_output = $fscanf(file_bitsream,"%s\n",string); 
		fscanf_output = $fscanf(file_bitsream,"%s\n",string); 
		fscanf_output = $fscanf(file_bitsream,"%s\n",string); 
		fscanf_output = $fscanf(file_bitsream,"%s\n",string); 
		fscanf_output = $fscanf(file_bitsream,"%s\n",string); 	
		
		temp_size = 0;
		
		while (! $feof(file_bitsream)) begin

			fscanf_output = $fscanf(file_bitsream,"%s\n",string); 
			fscanf_output = $fscanf(file_bitsream,"%d\n",temp_size); 
			fscanf_output = $fscanf(file_bitsream,"%b\n",temp); 
	
			for (j = 0; j < temp_size; j = j + 1) begin
				configurationbits = {configurationbits[configurationbits_size-2:0], temp[0]};
				temp = {1'b0,temp[47:1]};
			end
			temp_size = 0;
		end 
		
		$fclose(file_bitsream);
	end    
      
	// streaming the configuration bits at 2th clock over 210 clock periods
	reg configuration_input;
	reg configuration_enable;
	initial begin
		configuration_input = 1'b0;
		configuration_enable = 1'b0;
		
		repeat (start_of_loading_configuration_bits) begin @(posedge(clk)); end

		configuration_enable = 1'b1;
		configuration_input = configurationbits[0];

		for (i = 0; i < configurationbits_size-1; i = i + 1) begin
			@(posedge clk)
			configurationbits = {1'b0, configurationbits[configurationbits_size-1:1]};
			configuration_input = configurationbits[0];
		end
		
		@(posedge clk)
		configuration_enable = 1'b0;
	end
		
/*******************************************************
*		DSP inputs 
*******************************************************/
	
	reg signed [29:0] A;
	reg signed [17:0] B;
	reg signed [47:0] C;
	reg signed [26:0] D;
	
	reg [29:0] ACIN;
	reg [17:0] BCIN;
	reg [47:0] PCIN;
	reg CARRYCASCIN;
	
	reg [8:0] OPMODE_in;
	reg [3:0] ALUMODE_in;
	reg [2:0] CARRYINSEL_in;
	
	reg CARRYIN;
	reg [4:0] INMODE_in;
	
	///////////////////////////////////////////////
	// a quick test (Multipliers & MAC & XOR)
	///////////////////////////////////////////////
	// temp values
	reg signed [47:0] P_old;
	reg signed [47:0] P_older;
	reg signed [47:0] PATTERN_old;
	reg signed [47:0] PATTERN_older;
	
	reg signed [11:0] C_0;
	reg signed [11:0] C_1;
	reg signed [11:0] C_2;
	reg signed [11:0] C_3;
	
	reg signed [11:0] PCIN_0;
	reg signed [11:0] PCIN_1;
	reg signed [11:0] PCIN_2;
	reg signed [11:0] PCIN_3;
	
	reg signed [11:0] P_0;
	reg signed [11:0] P_1;
	reg signed [11:0] P_2;
	reg signed [11:0] P_3;

	reg signed [11:0] P_old_0;
	reg signed [11:0] P_old_1;
	reg signed [11:0] P_old_2;
	reg signed [11:0] P_old_3;
	
	initial begin
		Error_counter = 0;
		
		// initial values after initial reset and configuring 
		///////////////////////////////////////////////
		repeat (start_of_loading_configuration_bits + configurationbits_size + reset_clock_period_counter+simulation_start_clock_guard) begin @(posedge(clk)); end
		
		A = 30'b11_1111_1111_1111_1111_1111_1111_1110;
		B = 18'b00_0000_0000_0000_0100;
		C = 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010;
		D = 27'b000_0000_0000_0000_0000_0000_0010;
		
		ACIN = 30'b00_0000_0000_0000_0000_0000_0000_0000;
		BCIN = 18'b00_0000_0000_0000_0000;
		PCIN = 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
		CARRYCASCIN = 0;
		
		//OPMODE_in = 9'b0_0010_0111;
		OPMODE_in = 9'b0_0000_0101;
		ALUMODE_in = 4'b0000;
		CARRYINSEL_in = 3'b000;
		
		CARRYIN = 1'b0;
		INMODE_in = 5'b0_0000;
		
		P_old = 48'b0;
		P_older = 48'b0;
		PATTERN_old = 48'b0;
		PATTERN_older = 48'b0;
		
		C_0 = 12'b0;
		C_1 = 12'b0;
		C_2 = 12'b0;
		C_3 = 12'b0;
		PCIN_0 = 12'b0;
		PCIN_1 = 12'b0;
		PCIN_2 = 12'b0;
		PCIN_3 = 12'b0;
		P_0 = 12'b0;
		P_1 = 12'b0;
		P_2 = 12'b0;
		P_3 = 12'b0;
		P_old_0 = 12'b0;
		P_old_1 = 12'b0;
		P_old_2 = 12'b0;
		P_old_3 = 12'b0;
		
		// test signed multipliers
		///////////////////////////////////////////////
		$display("Testing Started: signed multipliers");
		
		OPMODE_in = 9'b0_0000_0101;
		ALUMODE_in = 4'b0000;
		CARRYINSEL_in = 3'b000;
		
		CARRYIN = 1'b0;
		INMODE_in = 5'b0_0000;
		
		repeat (test_repeat_multiplier) begin
			
			@(posedge(clk));

			A[26:0] = $random;
			A[29:27] = {3{A[26]}};
			B = $random;
			C = $random;
			
			#1
			if  (A * B != P) begin
				$display("Error: \tA = %d, B = %d, P = %d", A, B, P);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct: \tA = %d, B = %d, P = %d", A, B, P);
			end 
		end
		$display("Testing Finished: signed multipliers");

	    		
		

		// test signed MAC
		///////////////////////////////////////////////
		$display("Testing Started: test signed MAC");		
		
		// in this mode we use PREG attribute to use registered P
		DSP_inst.pattern_detection_inst.PREG = 1;
		// 4 clk delay for disparting simulation output visually
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));		
		
		// to reset the P to zero
		OPMODE_in = 9'b0_0000_0101;
		A = 0;
		B = 0;
		#1
		CEP = 1'b1;
		@(posedge(clk));
		
		OPMODE_in = 9'b0_0010_0101;
		ALUMODE_in = 4'b0000;
		CARRYINSEL_in = 3'b000;
		INMODE_in = 5'b0_0000;
			
		repeat (test_repeat_mac) begin
			
			// source to learn random https://stackoverflow.com/questions/34011576/generating-random-numbers-in-verilog
			A[26:0] = $random;
			A[29:27] = {3{A[26]}};
			B = $random;
			P_old = P;

			@(posedge(clk));
			#1
			
			if  (((A * B) + P_old) != P) begin
				$display("Error: \tA = %d, B = %d, P_old= %d,  sum= %d, P = %d", A, B, P_old, ((A * B) + P_old), P);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct: \tA = %d, B = %d, P_old= %d,  sum= %d, P = %d", A, B, P_old, ((A * B) + P_old), P);
			end 
			
		end
		CEP = 1'b0;
		// after this mode we don't use PREG attribute to use registered P
		OPMODE_in = 9'b0_0001_1111;
		DSP_inst.pattern_detection_inst.PREG = 0;
		$display("Testing Finished: test signed MAC");
	
	
	
		// test XOR + (SIMD)
		///////////////////////////////////////////////
		$display("Testing Started: test XOR + (SIMD)");		
		
		// 4 clk delay for disparting simulation output visually
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));		

		ALUMODE_in = 4'b0100;
		INMODE_in = 5'b0_0000;
		OPMODE_in = 9'b0_0001_1111;
		
		repeat (test_repeat_xor) begin
			
			@(posedge(clk));

			A = $random;
			B = $random;
			C = $random;
			PCIN = $random;

			#1
			
			if  (( ({A,B}) ^ PCIN ^ C) != P) begin
				$display("Error: \tAB = %b, C= %b,  PCIN= %b, P = %b", ({A,B}), PCIN, C, P);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct: \tAB = %b, C= %b,  PCIN= %b, P = %b", {A,B}, PCIN, C, P);
			end 
			
			if  (((^( ({A,B}) ^ PCIN ^ C))) != XOROUT[3]) begin
				$display("Error: \tAB = %b, C= %b,  PCIN= %b, XOROUT[3] = %b", ({A,B}), PCIN, C, XOROUT[3]);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct: \tAB = %b, C= %b,  PCIN= %b, XOROUT[3] = %b", ({A,B}), PCIN, C, XOROUT[3]);
			end
		end
		$display("Testing Finished: test XOR + (SIMD)");
		
		
		
		
		
		// test Pattern Detection
		///////////////////////////////////////////////
		$display("Testing Started: test Pattern Detection");	
		// use P register to check autoreset abilities
		CEP = 1'b1;
		DSP_inst.pattern_detection_inst.PREG = 1'b1;
		DSP_inst.output_manager_inst.AUTORESET_PATDET = 2'b01;
		DSP_inst.pattern_detection_inst.MASK = 48'b111111111111111111111111111111111111111111100000;
		// prepare functionality or multipling A * B to generate different P
		ALUMODE_in = 4'b0000;
		INMODE_in = 5'b0_0000;
		OPMODE_in = 9'b0_0001_0101;
		
		// 4 clk delay for disparting simulation output visually
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));		
		
		repeat (test_repeat_pattern_detection) begin

			DSP_inst.pattern_detection_inst.PATTERN = $random;
			A[26:0] = $random;
			A[29:27] = {3{A[26]}};
			B = $random; 
            #1
			P_older = P_old;
			P_old = DSP_inst.S;
			
			PATTERN_older = PATTERN_old;
			PATTERN_old = DSP_inst.pattern_detection_inst.PATTERN;
			@(posedge(clk));
			
			#1
			
			if  ( (P_older[4:0] == PATTERN_older[4:0]) )   begin
				if (P!=0) begin
					$display("Error (time %d): \tP_old= %b, P = %b", $time(), P_old, P);
					Error_counter = Error_counter + 1;
				end else begin
					//$display("Correct: \tP_old= %b, P = %b", P_old, P);
				end 
			end
		end	
		CEP = 1'b0;
		DSP_inst.output_manager_inst.AUTORESET_PATDET = 2'b00;
		OPMODE_in = 9'b0_0000_0101;
		DSP_inst.pattern_detection_inst.PREG = 1'b0;
		$display("Testing Finished: test Pattern Detection");
		
		
		
		
		
		
		
		// test SIMD ADD-SUB
		///////////////////////////////////////////////
		$display("Testing Started: test SIMD ADD-SUB");	
		// use P register to check autoreset abilities
		CEP = 1'b1;
		DSP_inst.pattern_detection_inst.PREG = 1'b1;
		DSP_inst.ALU_inst.USE_SIMD = 2'b10;
		// 4 clk delay for disparting simulation output visually
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));		
		
		// to reset the P to zero
		OPMODE_in = 9'b0_0000_0101;
		A = 0;
		B = 0;
		@(posedge(clk));
		
		P_0 = 12'b0;
		P_1 = 12'b0;
		P_2 = 12'b0;
		P_3 = 12'b0;
		
		// prepare functionality for PCIN + P + C as 4 x12 bit add/sub
		ALUMODE_in = 4'b0000;
		INMODE_in = 5'b0_0000;
		OPMODE_in = 9'b0_0001_1110;
		

		repeat (test_repeat_SIMD_ADDSUB) begin

			P_old_0 = P_0;
			P_old_1 = P_1;
			P_old_2 = P_2;
			P_old_3 = P_3;

			C_0 = $random;
			C_1 = $random;
			C_2 = $random;
			C_3 = $random;
			PCIN_0 = $random;
			PCIN_1 = $random;
			PCIN_3 = $random;
			PCIN_2 = $random;
			
			C = {C_3, C_2, C_1, C_0};
			PCIN = {PCIN_3, PCIN_2, PCIN_1, PCIN_0}; 
			
			@(posedge(clk));
			
			#1
			
			P_0 = P[11:0];
			P_1 = P[23:12];
			P_2 = P[35:24];
			P_3 = P[47:36];

	
			if ((P_old_0 + C_0 + PCIN_0) != P_0) begin
				$display("Error (time %d): \tP_old= %b, C_0=%b, PCIN_0 = %b, P = %b", $time(), P_old_0, C_0, PCIN_0, P_0);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_0=%b, PCIN_0 = %b, P = %b", $time(), P_old_0, C_0, PCIN_0, P_0);
			end 
			if ((P_old_1 + C_1 + PCIN_1) != P_1) begin
				$display("Error (time %d): \tP_old= %b, C_1=%b, PCIN_1 = %b, P = %b", $time(), P_old_1, C_1, PCIN_1, P_1);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_1=%b, PCIN_1 = %b, P = %b", $time(), P_old_1, C_1, PCIN_1, P_1);
			end 
			if ((P_old_2 + C_2 + PCIN_2) != P_2) begin
				$display("Error (time %d): \tP_old= %b, C_2=%b, PCIN_2 = %b, P = %b", $time(), P_old_2, C_2, PCIN_2, P_2);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_2=%b, PCIN_2 = %b, P = %b", $time(), P_old_2, C_2, PCIN_2, P_2);
			end 
			if ((P_old_3 + C_3 + PCIN_3) != P_3) begin
				$display("Error (time %d): \tP_old= %b, C_3=%b, PCIN_3 = %b, P = %b", $time(), P_old_3, C_3, PCIN_3, P_3);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_3=%b, PCIN_3 = %b, P = %b", $time(), P_old_3, C_3, PCIN_3, P_3);
			end 
		end	
		
		
		
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));
		@(posedge(clk));		
		
		// to reset the P to zero
		OPMODE_in = 9'b0_0000_0101;
		A = 0;
		B = 0;
		@(posedge(clk));
		
		P_0 = 12'b0;
		P_1 = 12'b0;
		P_2 = 12'b0;
		P_3 = 12'b0;
		
		// prepare functionality for PCIN - (P + C) as 4 x12 bit add/sub
		ALUMODE_in = 4'b0011;
		INMODE_in = 5'b0_0000;
		OPMODE_in = 9'b0_0001_1110;
		

		repeat (test_repeat_SIMD_ADDSUB) begin

			P_old_0 = P_0;
			P_old_1 = P_1;
			P_old_2 = P_2;
			P_old_3 = P_3;

			C_0 = $random;
			C_1 = $random;
			C_2 = $random;
			C_3 = $random;
			PCIN_0 = $random;
			PCIN_1 = $random;
			PCIN_3 = $random;
			PCIN_2 = $random;
			
			C = {C_3, C_2, C_1, C_0};
			PCIN = {PCIN_3, PCIN_2, PCIN_1, PCIN_0}; 
			
			@(posedge(clk));
			
			#1
			
			P_0 = P[11:0];
			P_1 = P[23:12];
			P_2 = P[35:24];
			P_3 = P[47:36];

	
			if ((PCIN_0 - (P_old_0 + C_0)) != P_0) begin
				$display("Error (time %d): \tP_old= %b, C_0=%b, PCIN_0 = %b, P = %b", $time(), P_old_0, C_0, PCIN_0, P_0);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_0=%b, PCIN_0 = %b, P = %b", $time(), P_old_0, C_0, PCIN_0, P_0);
			end 
			if ((PCIN_1 - (P_old_1 + C_1)) != P_1) begin
				$display("Error (time %d): \tP_old= %b, C_1=%b, PCIN_1 = %b, P = %b", $time(), P_old_1, C_1, PCIN_1, P_1);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_1=%b, PCIN_1 = %b, P = %b", $time(), P_old_1, C_1, PCIN_1, P_1);
			end 
			if ((PCIN_2 - (P_old_2 + C_2)) != P_2) begin
				$display("Error (time %d): \tP_old= %b, C_2=%b, PCIN_2 = %b, P = %b", $time(), P_old_2, C_2, PCIN_2, P_2);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_2=%b, PCIN_2 = %b, P = %b", $time(), P_old_2, C_2, PCIN_2, P_2);
			end 
			if ((PCIN_3 - (P_old_3 + C_3)) != P_3) begin
				$display("Error (time %d): \tP_old= %b, C_3=%b, PCIN_3 = %b, P = %b", $time(), P_old_3, C_3, PCIN_3, P_3);
				Error_counter = Error_counter + 1;
			end else begin
				//$display("Correct (time %d): \tP_old= %b, C_3=%b, PCIN_3 = %b, P = %b", $time(), P_old_3, C_3, PCIN_3, P_3);
			end 
		end	
		
		
		
		CEP = 1'b0;
		OPMODE_in = 9'b0_0000_0000;
		DSP_inst.pattern_detection_inst.PREG = 1'b0;
		
		$display("Testing Finished: test SIMD ADD-SUB");
		
		
		
		
		
		
		$display(" ");
		if (Error_counter != 0)begin
			$display("--> Error: there was %d wrong answer", Error_counter);
		end else begin
			$display("--> Correct: there was no wrong answer :) ");
		end
		$display(" ");
		
		@(posedge(clk));
		@(posedge(clk));
		$finish();
	end
	
	
	
	reg CEB1;
	reg CEB2;		
	reg CEA1;
	reg CEA2;
	reg CEAD;
	reg CED;
	reg CEC;
	reg CEP;
	reg CEM;
	reg CECARRYIN;
	reg CEALUMODE;		
	reg CECTRL;
	reg CEINMODE;
	
	initial begin
		CEB1 = 1'b0;
		CEB2 = 1'b0;		
		CEA1 = 1'b0;
		CEA2 = 1'b0;
		CEAD = 1'b0;
		CED = 1'b0;
		CEC = 1'b0;
		CEP = 1'b0;
		CEM = 1'b0;
		CECARRYIN = 1'b0;
		CEALUMODE = 1'b0;		
		CECTRL = 1'b0;
		CEINMODE = 1'b0;
	end
	
	
	
	reg RSTCTRL;
	reg RSTALUMODE;
	reg RSTD;
	reg RSTC;
	reg RSTB;
	reg RSTA;
	reg RSTP;
	reg RSTM;	
	reg RSTALLCARRYIN;
	reg RSTINMODE;	
	
	// first 10 clock reset is active
	initial begin
		RSTCTRL = 1'b1;
		RSTALUMODE = 1'b1;
		RSTD = 1'b1;
		RSTC = 1'b1;
		RSTB = 1'b1;
		RSTA = 1'b1;
		RSTP = 1'b1;
		RSTM = 1'b1;	
		RSTALLCARRYIN = 1'b1;
		RSTINMODE = 1'b1;
		
		repeat (start_of_loading_configuration_bits + configurationbits_size + reset_clock_period_counter) begin @(posedge(clk)); end
		
		RSTCTRL = 1'b0;
		RSTALUMODE = 1'b0;
		RSTD = 1'b0;
		RSTC = 1'b0;
		RSTB = 1'b0;
		RSTA = 1'b0;
		RSTP = 1'b0;
		RSTM = 1'b0;	
		RSTALLCARRYIN = 1'b0;
		RSTINMODE = 1'b0;
	end

/*******************************************************
*		DSP outputs 
*******************************************************/

	wire signed [29:0] ACOUT;
	wire signed [17:0] BCOUT;
	wire signed [47:0] PCOUT;
	
	wire signed [47:0] P;
	
	wire [3:0] CARRYOUT;
	wire CARRYCASCOUT;	
	wire MULTSIGNOUT;
	
	wire PATTERNDETECT;		
	wire PATTERNBDETECT;
	
	wire OVERFLOW;
	wire UNDERFLOW;		
	
	wire [7:0] XOROUT;

	
/*******************************************************
*		DSP instantiating  
*******************************************************/

	DSP DSP_inst(
		.clk(clk),		
		
		.A(A),
		.B(B),
		.C(C),
		.D(D),
		
		.OPMODE_in(OPMODE_in),
		.ALUMODE_in(ALUMODE_in),
		.CARRYINSEL_in(CARRYINSEL_in),	
		
		.CARRYIN(CARRYIN),
		.INMODE_in(INMODE_in),
		
		.CEB1(CEB1),
		.CEB2(CEB2),		
		.CEA1(CEA1),
		.CEA2(CEA2),
		.CEAD(CEAD),
		.CED(CED),
		.CEC(CEC),
		.CEP(CEP),
		.CEM(CEM),
		.CECARRYIN(CECARRYIN),
		.CEALUMODE(CEALUMODE),		
		.CECTRL(CECTRL),
		.CEINMODE(CEINMODE),	
		
		.RSTCTRL(RSTCTRL),
		.RSTALUMODE(RSTALUMODE),
		.RSTD(RSTD),
		.RSTC(RSTC),
		.RSTB(RSTB),
		.RSTA(RSTA),
		.RSTP(RSTP),
		.RSTM(RSTM),				
		.RSTALLCARRYIN(RSTALLCARRYIN),
		.RSTINMODE(RSTINMODE),	
			
		.ACIN(ACIN),
		.BCIN(BCIN),
		.PCIN(PCIN),
		.CARRYCASCIN(CARRYCASCIN),
		
		// Outputs
		.ACOUT(ACOUT),
		.BCOUT(BCOUT),
		.PCOUT(PCOUT),
		
		.P(P),	
		
		.CARRYOUT(CARRYOUT),			
		.CARRYCASCOUT(CARRYCASCOUT),	
		.MULTSIGNOUT(MULTSIGNOUT),
		
		.PATTERNDETECT(PATTERNDETECT),		
		.PATTERNBDETECT(PATTERNBDETECT),
		
		.OVERFLOW(OVERFLOW),			
		.UNDERFLOW(UNDERFLOW),		
		
		.XOROUT(XOROUT),		
		
		// End of Outputs
		.configuration_input(configuration_input),
		.configuration_enable(configuration_enable)
	);  
	
endmodule
