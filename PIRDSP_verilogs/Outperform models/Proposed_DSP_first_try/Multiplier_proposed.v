`timescale 1 ns / 100 ps  
module Multiplier_proposed(
		input [53:0] a,
		input [53:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [47:0] result1,	
		output reg [47:0] result2	
 	); 
	
	// functionality modes 
	parameter mode_27x18 		= 2'b00;
	parameter mode_8x8 			= 2'b01;
	parameter mode_sum_9x9 	= 2'b10;
	parameter mode_sum_4x4 	= 2'b11;
	
	// internal signal for half mode detection
	reg HALF;
	
	// input of partial multipliers 
	reg [8:0] A_0;
	reg [8:0] A_1;
	reg [8:0] A_2;
	reg [8:0] A_3;
	reg [8:0] A_4;
	reg [8:0] A_5;

	reg [8:0] B_0;
	reg [8:0] B_1;
	reg [8:0] B_2;
	reg [8:0] B_3;
	reg [8:0] B_4;
	reg [8:0] B_5;
	
	wire [17:0] C_0;
	wire [17:0] C_1;
	wire [17:0] C_2;
	wire [17:0] C_3;
	wire [17:0] C_4;
	wire [17:0] C_5;
	
	reg A_sign_0;
	reg A_sign_1;
	reg A_sign_2;
	reg A_sign_3;
	reg A_sign_4;
	reg A_sign_5;
	
	reg B_sign_0;
	reg B_sign_1;
	reg B_sign_2;
	reg B_sign_3;
	reg B_sign_4;
	reg B_sign_5;
	
	// to assign the input to six 9x9 multiplieres
	always @(*) begin
		case (mode)
			mode_27x18: begin
				A_0 = a[8:0];
				A_1 = a[17:9];
				A_2 = a[8:0];
				A_3 = a[17:9];
				A_4 = a[26:18];
				A_5 = a[26:18];
				
				B_0 = b[8:0];
				B_1 = b[8:0];
				B_2 = b[17:9];
				B_3 = b[17:9];
				B_4 = b[8:0];
			    B_5 = b[17:9];
			end 
			mode_8x8, mode_sum_4x4, mode_sum_9x9: begin
				A_0 = a[8:0];
				A_1 = a[17:9];
				A_2 = a[26:18];
				A_3 = a[35:27];
				A_4 = a[44:36];
				A_5 = a[53:45];
				
				B_0 = b[8:0];
				B_1 = b[17:9];
				B_2 = b[26:18];
				B_3 = b[35:27];
				B_4 = b[44:36];
			    B_5 = b[53:45];
			end
		endcase 
	end 
	
	// to assign the sign controller to the six 9x9 multiplier 
	reg mode_SIMD;
	always@(*) begin
		case (mode)
			mode_27x18: begin
				mode_SIMD = 1'b0;
				
				A_sign_0 = 0;
				A_sign_1 = 0;
				A_sign_2 = 0;
				A_sign_3 = 0;
				A_sign_4 = a_sign;
				A_sign_5 = a_sign;
				
				B_sign_0 = 0;
				B_sign_1 = 0;
				B_sign_2 = b_sign;
				B_sign_3 = b_sign;
				B_sign_4 = 0;
				B_sign_5 = b_sign;
			end 
			mode_8x8, mode_sum_4x4, mode_sum_9x9: begin
				mode_SIMD = 1'b1;
				
				A_sign_0 = a_sign;
				A_sign_1 = a_sign;
				A_sign_2 = a_sign;
				A_sign_3 = a_sign;
				A_sign_4 = a_sign;
				A_sign_5 = a_sign;
				
				B_sign_0 = b_sign;
				B_sign_1 = b_sign;
				B_sign_2 = b_sign;
				B_sign_3 = b_sign;
				B_sign_4 = b_sign;
				B_sign_5 = b_sign;
			end
		endcase 
	end 
	
	// to extract half mode from 2-bit mode input 
	always @(*) begin
		case (mode)
			mode_27x18, mode_sum_9x9, mode_8x8: begin
				HALF = 1'b0;
			end 
			mode_sum_4x4: begin
				HALF = 1'b1;
			end
		endcase 
	end 
	
	// instances of 9x9 s/u multipliers 
	multiplier_9bits_9bits_HighLevelDescribed 			multiplier_9bits_9bits_HighLevelDescribed_inst_0 (
		.A(A_0),
		.B(B_0),
		
		.A_sign(A_sign_0),
		.B_sign(B_sign_0),
		
		.HALF(HALF), 			
		
		.C(C_0)
	);
	
	multiplier_9bits_9bits_HighLevelDescribed 			multiplier_9bits_9bits_HighLevelDescribed_inst_1 (
		.A(A_1),
		.B(B_1),
		
		.A_sign(A_sign_1),
		.B_sign(B_sign_1),
		
		.HALF(HALF), 			
		
		.C(C_1)
	);
	
	multiplier_9bits_9bits_HighLevelDescribed 			multiplier_9bits_9bits_HighLevelDescribed_inst_2 (
		.A(A_2),
		.B(B_2),
		
		.A_sign(A_sign_2),
		.B_sign(B_sign_2),
		
		.HALF(HALF), 			
		
		.C(C_2)
	);
	
	multiplier_9bits_9bits_HighLevelDescribed 			multiplier_9bits_9bits_HighLevelDescribed_inst_3 (
		.A(A_3),
		.B(B_3),
		
		.A_sign(A_sign_3),
		.B_sign(B_sign_3),
		
		.HALF(HALF), 			
		
		.C(C_3)
	);
	
	multiplier_9bits_9bits_HighLevelDescribed 			multiplier_9bits_9bits_HighLevelDescribed_inst_4 (
		.A(A_4),
		.B(B_4),
		
		.A_sign(A_sign_4),
		.B_sign(B_sign_4),
		
		.HALF(HALF), 			
		
		.C(C_4)
	);
	
	
	multiplier_9bits_9bits_HighLevelDescribed 			multiplier_9bits_9bits_HighLevelDescribed_inst_5 (
		.A(A_5),
		.B(B_5),
		
		.A_sign(A_sign_5),
		.B_sign(B_sign_5),
		
		.HALF(HALF), 			
		
		.C(C_5)
	);
	

	
	// to implement shifters for SIMD modes
	reg   [17:0] C_0_shifted;
	reg   [26:0] C_3_shifted;
	reg   [26:0] C_4_shifted;
	always @ (*) begin
		case (mode)
			mode_27x18, mode_8x8: begin 
				C_0_shifted = {{9'b0}, {C_0[17:9]}};	
				C_3_shifted = {{9{C_3[17]&(A_sign_3|B_sign_3)}}, {C_3}};	
				C_4_shifted = {{9{C_4[17]&(A_sign_4|B_sign_4)}}, {C_4}};	
			end 
			mode_sum_4x4, mode_sum_9x9: begin
				C_0_shifted = {C_0};
				C_3_shifted = {{C_3}, {9'b0}};	
				C_4_shifted = {{C_4}, {9'b0}};	
			end
		endcase 
	end 
	
	// to assign output pairs 
	// these pairs are diparted
	// for mode 8x8 there is a wide multiplexer
	always @ (*) begin
		if (mode == mode_8x8) begin
			result1 = {C_2[15:0],C_1[15:0],C_0[15:0]};
			result2 = {C_5[15:0],C_4[15:0],C_3[15:0]};
		end
		else begin 
			result1[8:0] = C_0[8:0];
			result1[44:9] = C_0_shifted + C_1 + C_2 + {{C_3_shifted[8:0]},{9'b0}};
			result1[18:17] =  result1[18:17]  & {2{~HALF}};
			result1[47:45] = {3{result1[44] & (a_sign|b_sign)}};	
			
			result2[17:0] = 18'b0;
			result2[26:18] = C_4_shifted[8:0];
			result2[44:27] = C_5 + {18{C_2[17]&(A_sign_2||B_sign_2)&(~mode_SIMD)}} + C_3_shifted[26:9] + C_4_shifted[26:9];
			result2[36:35] =  result2[36:35]  & {2{~HALF}};
			result2[47:45] = {3{result2[44] & (a_sign|b_sign)}};	
		end 
	end 
	
endmodule
