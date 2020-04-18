/*****************************************************************
*	Configuration bits order :
*			AUTORESET_PATDET[0] <= configuration_input;
*			AUTORESET_PATDET[1] <= AUTORESET_PATDET[0];
*			AUTORESET_PRIORITY <= AUTORESET_PATDET[1];
*			IS_RSTP_INVERTED <= AUTORESET_PRIORITY;
*			configuration_output = IS_RSTP_INVERTED
*****************************************************************/
`timescale 1 ns / 100 ps  
module output_manager (
		input clk,

		input RSTP,
		input CEP,
		
		input inter_MULTSIGNOUT,
		input inter_CARRYCASCOUT,
		input [7:0] inter_XOROUT,
		input [3:0] inter_CARRYOUT,
		input [47:0] inter_P,
		
		input PATTERNDETECT,		
		input PATTERNBDETECT,
		
		input PREG,

		output reg MULTSIGNOUT,
		output reg CARRYCASCOUT,
		output reg [7:0] XOROUT,
		output reg [3:0] CARRYOUT,
		output reg [47:0] P,
					
		input configuration_input,
		input configuration_enable,
		output configuration_output
	);	
	
	// parameter 
	parameter input_freezed = 1'b0;
	
	// configuring bits
	reg [1:0] AUTORESET_PATDET;
	reg AUTORESET_PRIORITY;
	reg IS_RSTP_INVERTED;
		
	always@(posedge clk)begin
		if (configuration_enable)begin
			AUTORESET_PATDET[0] <= configuration_input;
			AUTORESET_PATDET[1] <= AUTORESET_PATDET[0];
			AUTORESET_PRIORITY <= AUTORESET_PATDET[1];
			IS_RSTP_INVERTED <= AUTORESET_PRIORITY;
		end
	end
	assign configuration_output = IS_RSTP_INVERTED;
	
	// output_manager	
	reg inter_MULTSIGNOUT_reg;
	reg [47:0] inter_PCOUT_reg;
	reg inter_CARRYCASCOUT_reg;
	reg [7:0] inter_XOROUT_reg;
	reg [3:0] inter_CARRYOUT_reg;	
	reg [47:0] inter_P_reg;
	
	wire RSTP_xored;
	assign RSTP_xored = IS_RSTP_INVERTED ^ RSTP;
	
	always@(posedge clk) begin
		if (RSTP_xored) begin
			inter_P_reg <= 48'b0;
		end
		else begin
			case (AUTORESET_PATDET) 
				2'b00: begin
					if (CEP) begin
						inter_P_reg <= inter_P;
					end	
				end
				2'b01: begin
					if ((AUTORESET_PRIORITY && CEP && PATTERNDETECT) || ((~AUTORESET_PRIORITY)  && PATTERNDETECT))begin
							inter_P_reg <= 48'b0;
					end else if (CEP) begin
						inter_P_reg <= inter_P;
					end	
				end
				2'b10: begin
					if ((AUTORESET_PRIORITY && CEP && PATTERNBDETECT) || ((~AUTORESET_PRIORITY)  && PATTERNBDETECT))begin
							inter_P_reg <= 48'b0;
					end else if (CEP) begin
						inter_P_reg <= inter_P;
					end	
				end
			endcase
		end	
		
	end
	
	always@(posedge clk) begin
		if (RSTP_xored) begin
			inter_MULTSIGNOUT_reg <= 1'b0;
			inter_CARRYCASCOUT_reg <= 1'b0;
			inter_XOROUT_reg <= 8'b0;
			inter_CARRYOUT_reg <= 4'b0;	
		end	
		else if (CEP) begin
			inter_MULTSIGNOUT_reg <= inter_MULTSIGNOUT;
			inter_CARRYCASCOUT_reg <= inter_CARRYCASCOUT;
			inter_XOROUT_reg <= inter_XOROUT;
			inter_CARRYOUT_reg <= inter_CARRYOUT;
		end	
	end
	
	always@(*)begin
		if (input_freezed | PREG) begin
			MULTSIGNOUT = inter_MULTSIGNOUT_reg;
			XOROUT = inter_XOROUT_reg;
			CARRYOUT = inter_CARRYOUT_reg;
		end
		else begin
			MULTSIGNOUT = inter_MULTSIGNOUT;
			XOROUT = inter_XOROUT;
			CARRYOUT = inter_CARRYOUT;
		end
	end
	
	always@(*)begin
		if (input_freezed | PREG) begin
			CARRYCASCOUT = inter_CARRYCASCOUT_reg;
			P = inter_P_reg;
		end
		else begin
			CARRYCASCOUT = inter_CARRYCASCOUT;
			P = inter_P;
		end
	end
	
	
endmodule
	
	