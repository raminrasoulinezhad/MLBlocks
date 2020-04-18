/*****************************************************************
*	Configuration bits order :
*			RND <= {{RND[46:0]},{configuration_input}};
*			configuration_output = RND[47];
*****************************************************************/
`timescale 1 ns / 100 ps   
module XYZW_manager (
		input clk,
		
		input [8:0] OPMODE,
		input [47:0] P,
		
		input [47:0] C,
		
		input [44:0] M1,
		input [44:0] M2,
		
		input [47:0] AB,
		input [47:0] PCIN,

		output reg [47:0] W,
		output reg [47:0] Z,
		output reg [47:0] Y,
		output reg [47:0] X,
			
		input configuration_input,
		input configuration_enable,
		output configuration_output
	);	
	
	// configuring bits
	reg [47:0] RND;
	
	always@(posedge clk)begin
		if (configuration_enable)begin
			RND <= {{RND[46:0]},{configuration_input}};
		end
	end
	assign configuration_output = RND[47];	
	
	
	// XYZW
	always@(*)begin
		case(OPMODE[8:7])
			2'b00: W = 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
			2'b01: W = P;
			2'b10: W = RND;
			2'b11: W = C;	
		endcase
	end

	always@(*)begin
		case(OPMODE[1:0])
			2'b00: X = 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
			2'b01: X = {{3{M1[44]}},{M1}};
			2'b10: X = P;
			2'b11: X = AB;	
		endcase
	end

	always@(*)begin
		case(OPMODE[3:2])
			2'b00: Y = 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
			2'b01: Y = {{3{M2[44]}},{M2}};
			2'b10: Y = 48'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
			2'b11: Y = C;	
		endcase
	end
	
	
	always@(*)begin
		case(OPMODE[6:4])
			3'b000: Z = 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
			3'b001: Z = PCIN;
			3'b010: Z = P;
			3'b011: Z = C;
			
			3'b100: Z = P;
			3'b101: Z = { {17{PCIN[47]}}, {PCIN[47:17]} };
			3'b110: Z = { {17{P[47]}}, {P[47:17]} };
			3'b111: Z = 48'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx;			
		endcase
	end
	
endmodule 
	