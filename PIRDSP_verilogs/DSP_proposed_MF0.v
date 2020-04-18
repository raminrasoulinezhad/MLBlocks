`timescale 1 ns / 100 ps  
module DSP_proposed_MF0(

		// Inputs
		clk,		
		A,
		B,
		C,
		D,

		OPMODE_in,
		ALUMODE_in,
		CARRYINSEL_in,			
		CARRYIN,
		INMODE_in,
		MULTMODE_in,	

		CEB1,
		CEB2,		
		CEA1,
		CEA2,
		CEAD,
		CED,
		CEC,
		CEP,
		CEM,
		CECARRYIN,
		CEALUMODE,		
		CECTRL,
		CEINMODE,	
		CEMULTMODE,		

		RSTCTRL,
		RSTALUMODE,
		RSTD,
		RSTC,
		RSTB,
		RSTA,
		RSTP,
		RSTM,				
		RSTALLCARRYIN,
		RSTINMODE,	
		RSTMULTMODE,			
		ACIN,
		BCIN,				
		PCIN,
		CARRYCASCIN,
		
		// Outputs
		ACOUT,
		BCOUT,			
		PCOUT,
		P,
		P_SIMD_carry,
		CARRYCASCOUT,	
		MULTSIGNOUT,
		PATTERNDETECT,		
		PATTERNBDETECT,
		OVERFLOW,			
		UNDERFLOW,		
		XOROUT,		
		// End of Outputs
		
		configuration_input,
		configuration_enable
	);  

/*******************************************************
*		Parameters  
*******************************************************/
	parameter input_freezed = 1'b0;	
	parameter precision_loss_width = 4;
	
	parameter force_Cin_AB_reg = 1'b1;
/*******************************************************
*		Input / Outputs
*******************************************************/
		// Inputs
		input clk;
		
		input [29:0] A;
		input [17:0] B;
		input [47:0] C;
		input [26:0] D;
			
		input [8:0] OPMODE_in;
		input [3:0] ALUMODE_in;
		input [2:0] CARRYINSEL_in;	
		
		input CARRYIN;
		input [4:0] INMODE_in;
		input [3:0] MULTMODE_in;			// new
				
		input CEB1;
		input CEB2;		
		input CEA1;
		input CEA2;
		input CEAD;
		input CED;
		input CEC;
		input CEP;
		input CEM;
		input CECARRYIN;
		input CEALUMODE;		
		input CECTRL;
		input CEINMODE;	
		input CEMULTMODE;				// new
		
		input RSTCTRL;
		input RSTALUMODE;
		input RSTD;
		input RSTC;
		input RSTB;
		input RSTA;
		input RSTP;
		input RSTM;				
		input RSTALLCARRYIN;
		input RSTINMODE;
		input RSTMULTMODE;
			
		input [29:0] ACIN;
		input [17:0] BCIN;				
		input [47:0] PCIN;
		input CARRYCASCIN;
		
		// Outputs
		output [29:0] ACOUT;
		output [17:0] BCOUT;			
		output [47:0] PCOUT;
		
		output [47:0] P;
		output [precision_loss_width-1:0] P_SIMD_carry;	// NEW (DoM : Depends on Multiplier)
		
		output CARRYCASCOUT;
		output MULTSIGNOUT;
		
		output PATTERNDETECT;		
		output PATTERNBDETECT;
		
		output OVERFLOW;
		output UNDERFLOW;		
		
		output [7:0] XOROUT;		
		// End of Outputs
		
		input configuration_input;
		input configuration_enable;
		
		
/*******************************************************
*		InterConnections 
*******************************************************/
// (Input registers & multiplexers):
	wire [47:0] X_MUX;
	
	wire [26:0] A_MULT;			
	wire [17:0] B_MULT;			
		
	wire [26:0] AD_DATA;
	wire [47:0] C_MUX;
	
	wire [47:0] C_reg;
	wire [26:0] D_reg;
	
	wire [17:0] B2B1;
	wire [26:0] A2A1;
		
	wire CIN;	
	
	wire [47:0] W;
	wire [47:0] Z;
	wire [47:0] Y;
	wire [47:0] X;	
	wire [precision_loss_width-1:0] M_SIMD_carry_Mux;		// NEW (DoM : Depends on Multiplier)
// (Operation manager registers):
	wire [8:0] OPMODE;
	wire [2:0] CARRYINSEL;
	wire [3:0] ALUMODE;
	
	wire [4:0] INMODE;
	wire INMODEA;
	wire INMODEB;
	wire [3:0] MULTMODE;
	
	wire  [precision_loss_width-1:0] result_SIMD_carry;		// New (DoM : Depends on Multiplier)
	wire [precision_loss_width-1:0] M_SIMD;						// New (DoM : Depends on Multiplier)
	wire [precision_loss_width-1:0] result_SIMD_carry_out; 	// New (DoM : Depends on Multiplier)
// (Operation & Computation):
	wire PATTERNDETECTPAST;
	wire PATTERNBDETECTPAST;
	
	wire [89:0] M_temp;
	wire [89:0] M;
	
// (Output registers):
	wire [7:0] inter_XOROUT;
	
	wire COUT;																	//new
	wire [47:0] S;
	wire PREG;
	wire MREG;
	
	
// Configurations	
	wire COF_Dual_A_Register_block_inst;
	wire COF_Dual_B_Register_block_inst;
	wire COF_C_Register_block_inst;
	wire COF_D_Register_block_inst;
	wire COF_XYZW_manager_block_inst;
	wire COF_carry_in_manager_block_inst;
	wire COF_operation_manager_block_inst;
	wire COF_inmode_manager_block_inst;
	wire COF_multmode_manager_block_inst;						//new
	wire COF_multiplier_output_manager_block_inst;
	wire COF_multiplier_ALU_block_inst;
	wire COF_pattern_detection_block_inst;
	wire COF_wide_xor_block_block_inst;
	
/*******************************************************
*			(Input registers & multiplexers):
*					- Dual_A_Register_block
*					- Dual_B_Register_block
*					- C_Register_block
*					- D_Register_block
*					- XYZW_manager
*					- carry_in_manager
*******************************************************/

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
		.configuration_output(COF_Dual_A_Register_block_inst)
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
		
		.configuration_input(COF_Dual_A_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_Dual_B_Register_block_inst)
	);

	defparam C_Register_block_RegOut_inst.input_freezed = input_freezed;
	C_Register_block_RegOut					C_Register_block_RegOut_inst(
		.clk(clk),
		
		.C(C),
	    
		.RSTC(RSTC),
		.CEC(CEC),

		.C_MUX(C_MUX),
		.C_reg(C_reg),
				
		.configuration_input(COF_Dual_B_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_C_Register_block_inst)
	);
	
	D_Register_block_RegOut 					D_Register_block_RegOut_inst(
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
		.D_reg(D_reg),
		
		.configuration_input(COF_C_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_D_Register_block_inst)
	);
	
	defparam XYZW_manager_proposed_inst.precision_loss_width = precision_loss_width;
	XYZW_manager_proposed 	XYZW_manager_proposed_inst (
		.clk(clk),
		
		.OPMODE(OPMODE),
		.P(P),
		
		.C(C_MUX),
		
		.M1(M[44:0]),				
		.M2(M[89:45]),
		.M_SIMD_carry(M_SIMD),
		
		.AB(X_MUX),			
		.PCIN(PCIN),

		.W(W),
		.Z(Z),
		.Y(Y),
		.X(X),
		.M_SIMD_carry_Mux(M_SIMD_carry_Mux),

		.configuration_input(COF_D_Register_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_XYZW_manager_block_inst)
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
		.MREG(MREG),

		.configuration_input(COF_XYZW_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_carry_in_manager_block_inst)
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
		
		.configuration_input(COF_carry_in_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_operation_manager_block_inst)
	);	
	
	inmode_manager 				inmode_manager_inst (
		.clk(clk),
		
		.INMODE_in(INMODE_in),
		.RSTINMODE(RSTINMODE),
		.CEINMODE(CEINMODE),
		
		.INMODE(INMODE),
		
		.configuration_input(COF_operation_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_inmode_manager_block_inst)
	);

	mult_chain_stream_mode_manager_small 		mult_chain_stream_mode_manager_small_inst (
		.clk(clk),
		
		.MULTMODE_in(MULTMODE_in),
		.RSTMULTMODE(RSTMULTMODE),
		.CEMULTMODE(CEMULTMODE),
		.MULTMODE(MULTMODE),
		
		.configuration_input(COF_inmode_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_multmode_manager_block_inst)
	);
	
/*******************************************************
*			(Operation & Computation):
*					- Multiplier_xilinx
*					- multiplier_output_manager
*					- ALU
*					- pattern_detection
*					- wide_xor_block
*******************************************************/		
	multiplier_T_C3x2_F0_27bits_18bits_HighLevelDescribed_auto 			multiplier_T_C3x2_F0_27bits_18bits_HighLevelDescribed_auto_inst (
		.clk(clk),
		.reset(RSTM),
		
		.a({{D_reg[26:0]},{A_MULT}}),
		.b({{C_reg[35:0]},{B_MULT}}),		
		
		.a_sign(MULTMODE[0]),			
		.b_sign(MULTMODE[1]),			
		
		.mode(MULTMODE[3:2]),				
		
		.result_0(M_temp[44:0]),		
		.result_1(M_temp[89:45]),	
		.result_SIMD_carry(result_SIMD_carry)	
	); 
	
	defparam multiplier_output_manager_proposed_inst.input_freezed = input_freezed;
	defparam multiplier_output_manager_proposed_inst.precision_loss_width = precision_loss_width;
	multiplier_output_manager_proposed 			multiplier_output_manager_proposed_inst (
		.clk(clk),
		
		.M_temp(M_temp),
		.result_SIMD_carry(result_SIMD_carry),
		
		.RSTM(RSTM),
		.CEM(CEM),
		
		.MREG(MREG),
		
		.M(M),
		.M_SIMD(M_SIMD),
		
		.configuration_input(COF_multmode_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_multiplier_output_manager_block_inst)
	);	
		
	ALU_T_C3x2_F0_27bits_18bits_HighLevelDescribed_auto_DSP48E2_new		ALU_T_C3x2_F0_27bits_18bits_HighLevelDescribed_auto_DSP48E2_new_inst(
		.ALUMODE(ALUMODE),
		.OPMODE(OPMODE),

		.USE_SIMD(MULTMODE[3:2]),
		
		.W(W),
		.Z(Z),
		.Y(Y),
		.X(X),
		
		.CIN(CIN),
		
		.S(S),
		
		.COUT(COUT),
		
		.result_SIMD_carry_in(M_SIMD_carry_Mux),	
		.result_SIMD_carry_out(result_SIMD_carry_out)
	);	

	defparam pattern_detection_inst.input_freezed = input_freezed;
	pattern_detection 			pattern_detection_inst(
		.clk(clk),
		
		.C_reg(C_MUX),
		.inter_P(S),
		
		.RSTP(RSTP),
		.CEP(CEP),
		
		.PREG(PREG),
		.PATTERNDETECT(PATTERNDETECT),
		.PATTERNBDETECT(PATTERNBDETECT),
		.PATTERNDETECTPAST(PATTERNDETECTPAST),
		.PATTERNBDETECTPAST(PATTERNBDETECTPAST),
		.Overflow(OVERFLOW),
		.Underflow(UNDERFLOW),
		
		.configuration_input(COF_multiplier_output_manager_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_pattern_detection_block_inst)
	);
	
	defparam wide_xor_block_inst.input_freezed = input_freezed;
	wide_xor_block 			wide_xor_block_inst (
		.clk(clk),
		.S(S),
		.XOROUT(inter_XOROUT),
				
		.configuration_input(COF_pattern_detection_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output(COF_wide_xor_block_block_inst)
	);
		
/*******************************************************
*			(Output registers):
*					- output_manager
*******************************************************/
	
	defparam output_manager_proposed_inst.input_freezed = input_freezed;
	defparam output_manager_proposed_inst.precision_loss_width = precision_loss_width;
	output_manager_proposed 		output_manager_proposed_inst (
		.clk(clk),
        
		.RSTP(RSTP),
		.CEP(CEP),
		
		.inter_MULTSIGNOUT(COUT),
		.inter_CARRYCASCOUT(COUT),
		.inter_XOROUT(inter_XOROUT),
		.inter_P(S),
		.inter_result_SIMD_carry_out(result_SIMD_carry_out),
		
		.PATTERNDETECT(PATTERNDETECT),		
		.PATTERNBDETECT(PATTERNBDETECT),

		.PREG(PREG),
		
		.MULTSIGNOUT(MULTSIGNOUT),
		.CARRYCASCOUT(CARRYCASCOUT),
		.XOROUT(XOROUT),
		.P(P),
		.P_SIMD_carry(P_SIMD_carry),
		
		.configuration_input(COF_wide_xor_block_block_inst),
		.configuration_enable(configuration_enable),
		.configuration_output()
	);	
	
	assign PCOUT = P;
	
endmodule
