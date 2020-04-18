/*****************************************************************
* 	this module is defined by us to control Multiplier modes and input signs
* 	interpretation of the MULUMODE signal:
*		MULTMODE[0] --> a_sign
*		MULTMODE[1] --> b_sign
*		MULTMODE[3:2] --> SIMD mode (regarding fracture level)
******************************************************************
*	Configuration bits order :
*			MULTMODEREG <= configuration_input;
*			IS_MULTMODE_INVERTED <= {{IS_MULTMODE_INVERTED[2:0]},{MULTMODEREG}};
*			IS_RSTMULTMODE_INVERTED <= IS_MULTMODE_INVERTED[3];
*			configuration_output = IS_RSTMULTMODE_INVERTED;
*****************************************************************/
`timescale 1 ns / 100 ps   
module mult_chain_stream_mode_manager_small (
		input clk,
		
		input [3:0] MULTMODE_in,		
		input RSTMULTMODE,
		input CEMULTMODE,
		output [3:0] MULTMODE,
				
		input configuration_input,
		input configuration_enable,
		output configuration_output
	);
	
	// configuring bits
	reg MULTMODEREG;
	reg [3:0] IS_MULTMODE_INVERTED;
	reg IS_RSTMULTMODE_INVERTED;
	
	always@(posedge clk)begin
		if (configuration_enable)begin
			MULTMODEREG <= configuration_input;
			IS_MULTMODE_INVERTED <= {{IS_MULTMODE_INVERTED[2:0]},{MULTMODEREG}};
			IS_RSTMULTMODE_INVERTED <= IS_MULTMODE_INVERTED[3];
		end
	end
	assign configuration_output = IS_RSTMULTMODE_INVERTED;
	
	
	// multmode_manager
	wire [3:0] MULTMODE_in_xored;
	assign MULTMODE_in_xored = IS_MULTMODE_INVERTED ^ MULTMODE_in;
	
	wire RSTMULTMODE_xored;
	assign RSTMULTMODE_xored = IS_RSTMULTMODE_INVERTED ^ RSTMULTMODE;
	

	reg [3:0] MULTMODE_in_reg;
	always @(posedge clk) begin
		if (RSTMULTMODE_xored)begin
			MULTMODE_in_reg <= 4'b0000;
			end
		else if (CEMULTMODE)begin
			MULTMODE_in_reg <= MULTMODE_in_xored;
			end
	end
	
	assign MULTMODE = (MULTMODEREG) ? MULTMODE_in_reg: MULTMODE_in_xored;
endmodule
