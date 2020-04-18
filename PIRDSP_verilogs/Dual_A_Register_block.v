/*****************************************************************
*	Configuration bits order :
*			A_INPUT <= configuration_input;
*			AMULTSEL <= A_INPUT;
*			AREG[0] <= AMULTSEL;
*			AREG[1] <= AREG[0];
*			ACASCREG[0] <= AREG[1];
*			ACASCREG[1] <= ACASCREG[0];
*			IS_RSTA_INVERTED <= ACASCREG[1];
*			configuration_output = IS_RSTA_INVERTED
*****************************************************************/
`timescale 1 ns / 100 ps  
module Dual_A_Register_block(
		input clk,
		
		input [29:0] A,
		input [29:0] ACIN,
		input [26:0] AD_DATA,
		
		input CEA1,
		input CEA2,
		input RSTA,
		
		input [4:0] INMODE,
		input INMODEA,
		
		output [29:0] ACOUT,
		output [29:0] X_MUX,
		output [26:0] A_MULT,
		output [26:0] A2A1,
				
		input configuration_input,
		input configuration_enable,
		output configuration_output
	);

	parameter input_freezed = 1'b0;
	
	// configuring bits
	reg A_INPUT;
	reg AMULTSEL;
	reg [1:0] AREG;
	reg [1:0] ACASCREG;
	reg IS_RSTA_INVERTED;
	
	always@(posedge clk)begin
		if (configuration_enable)begin
			A_INPUT <= configuration_input;
			AMULTSEL <= A_INPUT;
			AREG[0] <= AMULTSEL;
			AREG[1] <= AREG[0];
			ACASCREG[0] <= AREG[1];
			ACASCREG[1] <= ACASCREG[0];
			IS_RSTA_INVERTED <= ACASCREG[1];
		end
	end
	assign configuration_output = IS_RSTA_INVERTED;
	
	
	// A
	wire [29:0] a_acin_mux2to1;
	wire [29:0] a_acin_mux2to1_reg1;
	wire [29:0] a_acin_mux2to1_reg2;
	wire [26:0] a_mult_temp;
	
	reg [29:0] A1;
	reg [29:0] A2;
	
	
	assign a_acin_mux2to1 = (A_INPUT) ? ACIN : A;
	assign a_acin_mux2to1_reg1 = (input_freezed | AREG[1]) ?  A1: a_acin_mux2to1;
	assign a_acin_mux2to1_reg2 = (input_freezed | AREG[1]) ?  A2: a_acin_mux2to1;

	wire RSTA_xored;
	assign RSTA_xored = IS_RSTA_INVERTED ^ RSTA;
	
	always@(posedge clk) begin
		if (RSTA_xored) 
			A1 <= 30'b0;
		else if (CEA1) 
			A1 <= a_acin_mux2to1;
	end
	always@(posedge clk) begin
		if (RSTA_xored) 
			A2 <= 30'b0;
		else if (CEA2) 
			A2 <= a_acin_mux2to1_reg1;
	end

	assign ACOUT = (ACASCREG[0]^AREG[0]) ? A1 : a_acin_mux2to1_reg2;
	assign X_MUX= a_acin_mux2to1_reg2;
	
	assign a_mult_temp = (INMODE[0]) ? A1[26:0]: a_acin_mux2to1_reg2[26:0];
	
	assign A2A1 = (a_mult_temp) & ({27{INMODEA}});
	
	assign A_MULT = (AMULTSEL) ? AD_DATA: A2A1;
endmodule
