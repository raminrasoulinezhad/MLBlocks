/*****************************************************************
*	Configuration bits order :
*			IS_RSTM_INVERTED <= configuration_input;
*			configuration_output = IS_RSTM_INVERTED;
*****************************************************************/
`timescale 1 ns / 100 ps   
module multiplier_output_manager (
		input clk,
		
		input [89:0] M_temp,
		input RSTM,
		input CEM,
		
		input MREG,
		
		output [89:0] M,
		
		input configuration_input,
		input configuration_enable,
		output configuration_output
	);	
	
	// parameters 
	parameter input_freezed = 1'b0;
	
	
	// configuring bits
	reg IS_RSTM_INVERTED;
		
	always@(posedge clk)begin
		if (configuration_enable)begin
			IS_RSTM_INVERTED <= configuration_input;
		end
	end
	assign configuration_output = IS_RSTM_INVERTED;
	
	
	// multiplier_output_manager
	reg [89:0] M_temp_reg;

	wire RSTM_xored;
	assign RSTM_xored = IS_RSTM_INVERTED ^ RSTM;
	
	always@ (posedge clk )begin
		if (RSTM_xored)
			M_temp_reg <= 90'b0;
		else if (CEM)
			M_temp_reg <= M_temp;
	end
	
	assign M = (MREG | input_freezed) ? M_temp_reg: M_temp;
	
endmodule 
	
	