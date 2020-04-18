/**********************************************************************
*
* 	Developer:			SeyedRamin Rasoulinezhad
*
*	Email: 					raminrasoolinezhad@gmail.com
* 	
*	Design Title:		Xilinx DSP48E2
* 	
*	Design source: 	According UG579-Ultrascale-dsp.pdf
*
*	Date 					19 Oct. 2018
* 
* *********************************************************************
*
*	Modules:				
*			(Input registers & multiplexers):
*					- Dual_A_Register_block
*					- Dual_B_Register_block
*					- C_Register_block
*					- D_Register_block
*					- XYZW_manager
*					- carry_in_manager
*
*			(Operation manager registers):
*					- operation_manager
*					- inmode_manager
*
*			(Operation & Computation):
*					- Multiplier_xilinx
*					- multiplier_output_manager
*					- ALU
*					- pattern_detection
*					- wide_xor_block
*					
*			(Output registers):
*					- output_manager
*
**********************************************************************/
`timescale 1 ns / 100 ps  
module DSP(
		// Inputs and output according Page 49 in According UG579-Ultrascale-dsp.pdf
		
		// Inputs
		input clk,		
		
		input [29:0] A,
		input [17:0] B,
		input [47:0] C,
		input [26:0] D,
		
		input [8:0] OPMODE_in,
		input [3:0] ALUMODE_in,
		input [2:0] CARRYINSEL_in,	
		
		input CARRYIN,
		input [4:0] INMODE_in,
		
		input CEB1,
		input CEB2,		
		input CEA1,
		input CEA2,
		input CEAD,
		input CED,
		input CEC,
		input CEP,
		input CEM,
		input CECARRYIN,
		input CEALUMODE,		
		input CECTRL,
		input CEINMODE,	
		
		input RSTCTRL,
		input RSTALUMODE,
		input RSTD,
		input RSTC,
		input RSTB,
		input RSTA,
		input RSTP,
		input RSTM,				
		input RSTALLCARRYIN,
		input RSTINMODE,	
			
		input [29:0] ACIN,
		input [17:0] BCIN,
		input [47:0] PCIN,
		input CARRYCASCIN,
		//input MULTSIGNIN,				//	<------------------ Question: sued for 96 MAC --> to forward carry bit from a ALU to next ALU as we use 4 bit adders.
		// End of Inputs
		
		
		// Outputs
		output [29:0] ACOUT,
		output [17:0] BCOUT,
		output [47:0] PCOUT,
		
		output [47:0] P,	
		
		output [3:0] CARRYOUT,			
		output CARRYCASCOUT,	
		output MULTSIGNOUT,
		
		output PATTERNDETECT,		
		output PATTERNBDETECT,
		
		output OVERFLOW,			
		output UNDERFLOW,		
		
		output [7:0] XOROUT,		
		// End of Outputs
		
		input configuration_input,
		input configuration_enable
	);  
	
	// Parameters 
	parameter input_freezed = 1'b0;
	parameter enable_preadder_bypass = 1'b0;
	
/*******************************************************
*		InterConnections 
*******************************************************/
// (Input registers & multiplexers):
	wire [47:0] X_MUX;
	wire [17:0] B_MULT;
	wire [26:0] A_MULT;
	wire [26:0] AD_DATA;
	wire [47:0] C_MUX;
	
	wire [17:0] B2B1;
	wire [26:0] A2A1;
		
	wire CIN;	
	
	wire [47:0] W;
	wire [47:0] Z;
	wire [47:0] Y;
	wire [47:0] X;	
// (Operation manager registers):
	wire [8:0] OPMODE;
	wire [2:0] CARRYINSEL;
	wire [3:0] ALUMODE;
	
	wire [4:0] INMODE;
	
// (Operation & Computation):
	wire PATTERNDETECTPAST;
	wire PATTERNBDETECTPAST;
	
	wire [89:0] M_temp;
	wire [89:0] M;
	
// (Output registers):
	wire inter_MULTSIGNOUT;
	wire inter_CARRYCASCOUT;
	wire [7:0] inter_XOROUT;
	wire [3:0] inter_CARRYOUT;
	wire [47:0] S;
	wire PREG_w;
	wire MREG_w;
	
	assign inter_CARRYCASCOUT = inter_CARRYOUT[3];
	assign inter_MULTSIGNOUT = inter_CARRYOUT[3];
	
// Configurations	
	wire configuration_output_from_Dual_A_Register_block_inst;
	wire configuration_output_from_Dual_B_Register_block_inst;
	wire configuration_output_from_C_Register_block_inst;
	wire configuration_output_from_D_Register_block_inst;
	wire configuration_output_from_XYZW_manager_block_inst;
	wire configuration_output_from_carry_in_manager_block_inst;
	wire configuration_output_from_operation_manager_block_inst;
	wire configuration_output_from_inmode_manager_block_inst;
	wire configuration_output_from_multiplier_output_manager_block_inst;
	wire configuration_output_from_multiplier_ALU_block_inst;
	wire configuration_output_from_pattern_detection_block_inst;
	wire configuration_output_from_wide_xor_block_block_inst;
	
/*******************************************************
*			(Input registers & multiplexers):
*					- Dual_A_Register_block
*					- Dual_B_Register_block
*					- C_Register_block
*					- D_Register_block
*					- XYZW_manager
*					- carry_in_manager
*******************************************************/
	wire INMODEA;
	wire INMODEB;
	
	Dual_A_Register_block 			Dual_A_Register_block_inst(
		.clk(clk),

		.A(A),
		.ACIN(ACIN),
		.AD_DATA(AD_DATA),

		.CEA1(CEA1),
		.CEA2(CEA2),
		.RSTA(RSTA),

		.INMODE(INMODE),
		.INMODEA(INMODEA),
		
		.ACOUT(ACOUT),
		.X_MUX(X_MUX[47:18]),
		.A_MULT(A_MULT),
		.A2A1(A2A1),
		
		.configuration_input(configuration_input),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_Dual_A_Register_block_inst)
	);
	
	Dual_B_Register_block 			Dual_B_Register_block_inst(
		.clk(clk),
		.B(B),
		.BCIN(BCIN),
		.AD_DATA(AD_DATA[17:0]),
	    
		.CEB1(CEB1),
		.CEB2(CEB2),
		.RSTB(RSTB),
		
		.INMODE(INMODE),
		.INMODEB(INMODEB),
		
		.BCOUT(BCOUT),
		.X_MUX(X_MUX[17:0]),
		.B_MULT(B_MULT),
		.B2B1(B2B1),
		
		.configuration_input(configuration_output_from_Dual_A_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_Dual_B_Register_block_inst)
	);
	
	defparam C_Register_block_inst.input_freezed = input_freezed;
	C_Register_block 					C_Register_block_inst(
		.clk(clk),
		
		.C(C),
	    
		.RSTC(RSTC),
		.CEC(CEC),

		.C_MUX(C_MUX),
				
		.configuration_input(configuration_output_from_Dual_B_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_C_Register_block_inst)
	);
	
	D_Register_block 					D_Register_block_inst(
		.clk(clk),
		
		.D(D),
		
		.CED(CED),
		.RSTD(RSTD),
		.CEAD(CEAD),
        
		.INMODE(INMODE),
        
		.A2A1(A2A1),
		.B2B1(B2B1),
		
		.AD_DATA(AD_DATA),
		.INMODEA(INMODEA),
		.INMODEB(INMODEB),

		.configuration_input(configuration_output_from_C_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_D_Register_block_inst)
	);

	XYZW_manager 	XYZW_manager_inst (
		.clk(clk),
		
		.OPMODE(OPMODE),
		.P(P),
		
		.C(C_MUX),
		
		.M1(M[44:0]),				
		.M2(M[89:45]),
		
		.AB(X_MUX),			
		.PCIN(PCIN),

		.W(W),
		.Z(Z),
		.Y(Y),
		.X(X),

		.configuration_input(configuration_output_from_D_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_XYZW_manager_block_inst)
	);	

	defparam carry_in_manager_inst.input_freezed = input_freezed;
	carry_in_manager 		carry_in_manager_inst(
		.clk(clk),
		
		.RSTALLCARRYIN(RSTALLCARRYIN),
        
		.CECARRYIN(CECARRYIN),
		.CEM(CEM),
		
		.CARRYIN(CARRYIN),
		.A_mult_msb(A_MULT[26]),
		.B_mult_msb(B_MULT[17]),
		.PCIN_msb(PCIN[47]),
		.P_msb(P[47]),
		
		.CARRYCASCIN(CARRYCASCIN),
		.CARRYCASCOUT(CARRYCASCOUT),
		.CARRYINSEL(CARRYINSEL),
				
		.CIN(CIN),
		.MREG(MREG_w),

		.configuration_input(configuration_output_from_XYZW_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_carry_in_manager_block_inst)
	);
	
/*******************************************************
*			(Operation manager registers):
*					- operation_manager
*					- inmode_manager
*******************************************************/

	operation_manager 		operation_manager_inst (
		.clk(clk),

		.RSTCTRL(RSTCTRL),
		.RSTALUMODE(RSTALUMODE),

		.CECTRL(CECTRL),
		.CEALUMODE(CEALUMODE),

		.OPMODE_in(OPMODE_in),
		.ALUMODE_in(ALUMODE_in),
		.CARRYINSEL_in(CARRYINSEL_in),
		
		.OPMODE(OPMODE),
		.ALUMODE(ALUMODE),
		.CARRYINSEL(CARRYINSEL),
		
		.configuration_input(configuration_output_from_carry_in_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_operation_manager_block_inst)
	);	
	
	inmode_manager 				inmode_manager_inst (
		.clk(clk),
		
		.INMODE_in(INMODE_in),
		.RSTINMODE(RSTINMODE),
		.CEINMODE(CEINMODE),
		
		.INMODE(INMODE),
		
		.configuration_input(configuration_output_from_operation_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_inmode_manager_block_inst)
	);

/*******************************************************
*			(Operation & Computation):
*					- Multiplier_xilinx
*					- multiplier_output_manager
*					- ALU
*					- pattern_detection
*					- wide_xor_block
*******************************************************/
	defparam Multiplier_xilinx_inst.input_freezed = input_freezed;
	Multiplier_xilinx 			Multiplier_xilinx_inst (
		.clk(clk),
		.a(A_MULT),
		.b(B_MULT),
		.result1(M_temp[44:0]),
		.result2(M_temp[89:45])
	); 
	
	defparam multiplier_output_manager_inst.input_freezed = input_freezed;
	multiplier_output_manager 			multiplier_output_manager_inst (
		.clk(clk),
		
		.M_temp(M_temp),
		.RSTM(RSTM),
		.CEM(CEM),
		
		.MREG(MREG_w),
		
		.M(M),
		
		.configuration_input(configuration_output_from_inmode_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_multiplier_output_manager_block_inst)
	);	

	ALU		ALU_inst(
		.clk(clk),
	
		.ALUMODE(ALUMODE),
		.OPMODE(OPMODE),

		.W(W),
		.Z(Z),
		.Y(Y),
		.X(X),
		
		.CIN(CIN),
		
		.S(S),
		.CARRYOUT(inter_CARRYOUT),
		
		.configuration_input(configuration_output_from_multiplier_output_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_multiplier_ALU_block_inst)
	);	

	defparam pattern_detection_inst.input_freezed = input_freezed;
	pattern_detection 			pattern_detection_inst(
		.clk(clk),
		
		.C_reg(C_MUX),
		.inter_P(S),
		
		.RSTP(RSTP),
		.CEP(CEP),
		
		.PREG(PREG_w),
		.PATTERNDETECT(PATTERNDETECT),
		.PATTERNBDETECT(PATTERNBDETECT),
		.PATTERNDETECTPAST(PATTERNDETECTPAST),
		.PATTERNBDETECTPAST(PATTERNBDETECTPAST),
		.Overflow(OVERFLOW),
		.Underflow(UNDERFLOW),
		
		.configuration_input(configuration_output_from_multiplier_ALU_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_pattern_detection_block_inst)
	);
	
	defparam wide_xor_block_inst.input_freezed = input_freezed;
	wide_xor_block 			wide_xor_block_inst (
		.clk(clk),
		.S(S),
		.XOROUT(inter_XOROUT),
				
		.configuration_input(configuration_output_from_pattern_detection_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(configuration_output_from_wide_xor_block_block_inst)
	);
		
/*******************************************************
*			(Output registers):
*					- output_manager
*******************************************************/
	
	defparam output_manager_inst.input_freezed = input_freezed;
	output_manager 		output_manager_inst (
		.clk(clk),
        
		.RSTP(RSTP),
		.CEP(CEP),
		
		.inter_MULTSIGNOUT(inter_MULTSIGNOUT),
		.inter_CARRYCASCOUT(inter_CARRYCASCOUT),
		.inter_XOROUT(inter_XOROUT),
		.inter_CARRYOUT(inter_CARRYOUT),
		.inter_P(S),
		
		.PATTERNDETECT(PATTERNDETECT),		
		.PATTERNBDETECT(PATTERNBDETECT),

		.PREG(PREG_w),
		
		.MULTSIGNOUT(MULTSIGNOUT),
		.CARRYCASCOUT(CARRYCASCOUT),
		.XOROUT(XOROUT),
		.CARRYOUT(CARRYOUT),
		.P(P),
						
		.configuration_input(configuration_output_from_wide_xor_block_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output()
	);	
	
	assign PCOUT = P;
	
endmodule
