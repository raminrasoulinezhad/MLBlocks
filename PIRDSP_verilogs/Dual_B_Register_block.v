/*****************************************************************
*	Configuration bits order :
*			B_INPUT <= configuration_input;
*			BMULTSEL <= B_INPUT;
*			BREG[0] <= BMULTSEL;
*			BREG[1] <= BREG[0];
*			BCASCREG[0] <= BREG[1];
*			BCASCREG[1] <= BCASCREG[0];
*			IS_RSTB_INVERTED <= BCASCREG[1];
*			configuration_output = IS_RSTB_INVERTED
*****************************************************************/
`timescale 1 ns / 100 ps  
module Dual_B_Register_block(
		input clk,
		
		input [17:0] B,
		input [17:0] BCIN,
		input [17:0] AD_DATA,
		
		input CEB1,
		input CEB2,
		input RSTB,
		
		input [4:0] INMODE,
		input INMODEB,
		
		output [17:0] BCOUT,
		output [17:0] X_MUX,
		output [17:0] B_MULT,
		output [17:0] B2B1,
					
		input configuration_input,
		input configuration_enable,
		output configuration_output
	);

	parameter input_freezed = 1'b0;
	
	// configuring bits
	reg B_INPUT;
	reg BMULTSEL;
	reg [1:0] BREG;
	reg [1:0] BCASCREG;
	reg IS_RSTB_INVERTED;
		
	always@(posedge clk)begin
		if (configuration_enable)begin
			B_INPUT <= configuration_input;
			BMULTSEL <= B_INPUT;
			BREG[0] <= BMULTSEL;
			BREG[1] <= BREG[0];
			BCASCREG[0] <= BREG[1];
			BCASCREG[1] <= BCASCREG[0];
			IS_RSTB_INVERTED <= BCASCREG[1];
		end
	end
	assign configuration_output = IS_RSTB_INVERTED;
	
	// B
	wire [17:0] b_bcin_mux2to1;
	wire [17:0] b_bcin_mux2to1_reg1;
	wire [17:0] b_bcin_mux2to1_reg2;

	wire [17:0] b_mult_temp;

	reg [17:0] B1;
	reg [17:0] B2;
	
	assign b_bcin_mux2to1 = (B_INPUT) ? BCIN : B;
	assign b_bcin_mux2to1_reg1 = (input_freezed | BREG[1]) ?  B1: b_bcin_mux2to1;
	assign b_bcin_mux2to1_reg2 = (input_freezed | BREG[1]) ?  B2: b_bcin_mux2to1;

	wire RSTB_xored;
	assign RSTB_xored = IS_RSTB_INVERTED ^ RSTB;
	
	always@(posedge clk) begin
		if (RSTB_xored) 
			B1 <= 18'b0;
		else if (CEB1) 
			B1 <= b_bcin_mux2to1;
	end
	always@(posedge clk) begin
		if (RSTB_xored) 
			B2 <= 18'b0;
		else if (CEB2) 
			B2 <= b_bcin_mux2to1_reg1;
	end
	
	assign BCOUT = (BCASCREG[0]^BREG[0]) ?  B1 : b_bcin_mux2to1_reg2;   //  BREG = 0 ==>  BCASCREG = 0 // BREG = 1 ==>  BCASCREG = 1 // BREG = 2 ==>  BCASCREG = 1/2 // if there is a difference in BREG[0],  BCASCREG[0] ==> BCOUT should use the just B1 Reg
	assign X_MUX = b_bcin_mux2to1_reg2;
	assign b_mult_temp = (INMODE[4]) ? B1 :  b_bcin_mux2to1_reg2;
	
	assign B2B1 = (b_mult_temp) & ({18{INMODEB}});
	assign B_MULT = (BMULTSEL) ? (AD_DATA[17:0]) : B2B1;
	
endmodule