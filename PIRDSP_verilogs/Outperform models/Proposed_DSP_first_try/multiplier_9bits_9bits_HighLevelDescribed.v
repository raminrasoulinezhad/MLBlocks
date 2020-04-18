`timescale 1 ns / 100 ps   
module multiplier_9bits_9bits_HighLevelDescribed (
		input [A_width-1:0] A,
		input [B_width-1:0] B,
		
		input A_sign,
		input B_sign,
		
		input HALF, 						// a selector bit to switch computation to half mode
		
		output [17:0] C
	);
	
	parameter A_width = 9;		// this parameter should be an odd number
	parameter B_width = 9;		// this parameter should be an odd number
	
	// to support both signed and unsiged multiplication
	// sign extention regarding extra sign identifier
	wire [A_width:0]  A_extended;			
	wire [B_width:0]  B_extended;			
	
	wire A_extended_9;
	wire B_extended_9;
	assign A_extended_9 = A_sign&(A[A_width-1]);
	assign B_extended_9 = B_sign&(B[B_width-1]);
	
	wire A_extended_4;
	wire B_extended_4;
	assign A_extended_4 = ((A[4] && (~HALF)) || (A[3] && HALF && A_sign));
	assign B_extended_4 = ((B[4] && (~HALF)) || (B[3] && HALF && B_sign));
	
	assign A_extended = {{A_extended_9}, {A[A_width-1:5]}, {A_extended_4}, {A[3:0]}};
    assign B_extended = {{B_extended_9}, {B[B_width-1:5]}, {B_extended_4}, {B[3:0]}};
	
	reg [B_width:0] PP [A_width:0];	
	integer i, j;
	
	always @(*) begin
		for (i = 0; i < (A_width + 1); i = i + 1 )begin 
			for (j = 0; j < (B_width + 1); j = j + 1 )begin 
				
				if (  (i < (A_width/2)) && (j < (B_width/2))  ) begin 
					PP[j][i] = (A_extended[i] && B_extended[j]);
				end 
				else if (  ((i ==(A_width/2)) && (j < (B_width/2))) || ((i < (A_width/2)) && (j == (B_width/2)))  ) begin
					PP[j][i] = (A_extended[i] && B_extended[j]) ^ (HALF);	
				end 
				
				else if (  (i > (A_width/2)) && (j > (B_width/2)) && (i < A_width)  && (j < B_width)  ) begin 
					PP[j][i] = (A_extended[i] && B_extended[j]);
				end 
				else if (  ((i == A_width) && (j > (B_width/2)) && (j < B_width)) || ((i > (A_width/2)) && (i < B_width) && (j == B_width))  ) begin
					PP[j][i] = ~(A_extended[i] && B_extended[j]);	
				end 
				
				else if (  ((i == A_width) && (j < ((B_width/2)+1) ))  || ((i < ((A_width/2)+1)) && (j == B_width))  ) begin
					PP[j][i] = ~((A_extended[i] && B_extended[j]) || HALF);	
				end 
				
				else begin
					PP[j][i] = (A_extended[i] && B_extended[j] && (~HALF));	
				end 
			end 	
		end 
	end 
	
	wire PP_extra_FULL;
	wire PP_extra_HALF;
	assign PP_extra_FULL = ~ HALF;
	assign PP_extra_HALF = HALF;
	
	// sum of PPs
	integer ii;
	reg [18:0] C_temp;
	
	always @(*) begin
		C_temp = 19'b0;
		for (ii = 0; ii < (B_width +1); ii = ii + 1 ) begin
			//C_temp = C_temp + {{(B_width-ii-1){1'b0}}, {PP[ii]}, {ii{1'b0}}};
			C_temp = C_temp + (PP[ii] << ii);
		end	
		C_temp = C_temp + {{3'b000}, {PP_extra_HALF}, {4'b0000}, {PP_extra_FULL}, {4'b0000}, {PP_extra_HALF}, {5'b00000}};
	end 
	
	assign C = {{C_temp[17:10]}, {(C_temp[9:8]) & ({2{(~HALF)}})}, {C_temp[7:0]}};

endmodule 
