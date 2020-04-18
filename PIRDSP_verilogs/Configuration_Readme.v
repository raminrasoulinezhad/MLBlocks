// in order of bit stream
/*****************************************************************
*	Configuration bits order (205 = 7+7+2+4+48+4+18+7+1+2+100+1+4):
* *** A (7)
*			A_INPUT <= configuration_input;
*			AMULTSEL <= A_INPUT;
*			AREG[0] <= AMULTSEL;
*			AREG[1] <= AREG[0];
*			ACASCREG[0] <= AREG[1];
*			ACASCREG[1] <= ACASCREG[0];
*			IS_RSTA_INVERTED <= ACASCREG[1];
* *** B (7)
*			B_INPUT <= IS_RSTA_INVERTED;
*			BMULTSEL <= B_INPUT;
*			BREG[0] <= BMULTSEL;
*			BREG[1] <= BREG[0];
*			BCASCREG[0] <= BREG[1];
*			BCASCREG[1] <= BCASCREG[0];
*			IS_RSTB_INVERTED <= BCASCREG[1];
* *** C (2)
*			IS_RSTC_INVERTED <= IS_RSTB_INVERTED;
*			CREG <= IS_RSTC_INVERTED;
* *** D  (4)
*			PREADDINSEL <= CREG;
*			ADREG <= PREADDINSEL;
*			DREG <= ADREG;
*			IS_RSTD_INVERTED <= DREG;
* *** XYZW (48)
*			RND <= {{RND[46:0]},{IS_RSTD_INVERTED}};
* *** carry_in_manager (4)
*			CARRYINREG <=  RND[47];
*			MREG <= CARRYINREG;
*			IS_CARRYIN_INVERTED <= MREG;
*			IS_RSTALLCARRYIN_INVERTED <= IS_CARRYIN_INVERTED;
* *** operation_manager (18)
*			OPMODEREG <= IS_RSTALLCARRYIN_INVERTED;
*			ALUMODEREG <= OPMODEREG;
*			CARRYINSELREG <= ALUMODEREG;
*			IS_ALUMODE_INVERTED <= {{IS_ALUMODE_INVERTED[2:0]},{CARRYINSELREG}};
*			IS_OPMODE_INVERTED <= {{IS_OPMODE_INVERTED[7:0]},{IS_ALUMODE_INVERTED[3]}};
*			IS_RSTALUMODE_INVERTED <= IS_OPMODE_INVERTED[8];
*			IS_RSTCTRL_INVERTED <= IS_RSTALUMODE_INVERTED;
* *** inmode_manager (7)
*			INMODEREG <= IS_RSTCTRL_INVERTED;
*			IS_INMODE_INVERTED <= {{IS_INMODE_INVERTED[3:0]},{INMODEREG}};
*			IS_RSTINMODE_INVERTED <= IS_INMODE_INVERTED[4];
* *** multiplier_output_manager (1)
*			IS_RSTM_INVERTED <= IS_RSTINMODE_INVERTED;
* *** ALU (2)
*			USE_SIMD[0] <= IS_RSTM_INVERTED;
*			USE_SIMD[1] <= USE_SIMD[0];
* *** pattern_detection (100)
*			PATTERN <= {{PATTERN[46:0]},{USE_SIMD[1]}};
*			SEL_PATTERN <= PATTERN[47];
*			SEL_MASK <= {{SEL_MASK[0]},{SEL_PATTERN}};
*			PREG <= SEL_MASK[1];
*			MASK <= {{MASK[46:0]},{PREG}};
* *** wide_xor_block (1)
*			XORSIMD <= MASK[47];
* *** output_manager (4)
*			AUTORESET_PATDET[0] <= XORSIMD;
*			AUTORESET_PATDET[1] <= AUTORESET_PATDET[0];
*			AUTORESET_PRIORITY <= AUTORESET_PATDET[1];
*			IS_RSTP_INVERTED <= AUTORESET_PRIORITY;
*			configuration_output = IS_RSTP_INVERTED
*****************************************************************/

`timescale 1 ns / 100 ps   

// without any order (just like datasheet categories)
module Configuration_bits_list (
		//////////////////// Attributes ////////////////////
		//////////////////// Register Control Attributes
		input [1:0] ACASCREG,										//default 1
		input ADREG,														//default 1
		input ALUMODEREG,											//default 1
		input [1:0] AREG,													//default 1
		input [1:0] BCASCREG,										//default 1
		input [1:0] BREG,													//default 1
		input CARRYINREG,											//default 1
		input CARRYINSELREG,										//default 1
		input CREG,                   										//default 1
		input DREG,                  											//default 1
		input INMODEREG,												//default 1
		input MREG,                  											//default 1
		input OPMODEREG,      										//default 1
		input PREG,                   										//default 1
		//////////////////// Feature Control Attributes
		input A_INPUT,														//default 0
		input B_INPUT,														//default 0
		input PREADDINSEL, 											// 0 = A (def), 1 = B 
		input BMULTSEL,													//default 0
		input AMULTSEL,													//default 0
		//input [1:0] USE_MULT,										//default 1				// Power saving attribute (is not supported in our implementation)					
		input [47:0] RND,													//default 48'b0
		input [1:0] USE_SIMD,											//default 0
		//input USE_WIDEXOR										//default (def 0) 		// Power saving attribute (is not supported in our implementation)	
		input XORSIMD,													//default 1
		//////////////////// Pattern Detector Attributes
		input [1:0] AUTORESET_PATDET,					//NO_RESET, RESET_MATCH, RESET_NOT_MATCH (NO_RESET)	
		input AUTORESET_PRIORITY,							//RESET, CEP (RESET), 0/1
		input [47:0] MASK,													//default (0011...11)
		input [47:0] PATTERN,											//default (0000...00)
		input [1:0] SEL_MASK,											//default 0
		input SEL_PATTERN,											//default 0
		//input USE_PATTERN_DETECT 						//default 0				 speed specification and Simulation Model purposes only (is not supported in our implementation)	
		//////////////////// Optional Inversion Attributes
		input [3:0] IS_ALUMODE_INVERTED,				//default 4'b0
		input IS_CARRYIN_INVERTED,             			//default 0
		//input IS_CLK_INVERTED,                      			//default 0				is not supported in our implementation
		input [4:0] IS_INMODE_INVERTED,      				//default 5'b0
		input [8:0] IS_OPMODE_INVERTED,     			//default 9'b0
		input IS_RSTA_INVERTED,                   				//default 0
		input IS_RSTALLCARRYIN_INVERTED, 			//default 0
		
		input IS_RSTALUMODE_INVERTED,				//default 0
		input IS_RSTB_INVERTED,                               	//default 0
		input IS_RSTC_INVERTED,								//default 0
		input IS_RSTCTRL_INVERTED,                       	//default 0
		input IS_RSTD_INVERTED,								//default 0
		input IS_RSTINMODE_INVERTED,                  	//default 0
		input IS_RSTM_INVERTED,                              	//default 0
		input IS_RSTP_INVERTED                                	//default 0
);


endmodule
