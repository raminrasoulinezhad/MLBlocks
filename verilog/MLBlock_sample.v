module MLBlock_sample (
		clk, 
		reset,

		hp_en,

		a_en,
		a, 
		
		b_en,
		b,
		b_cas_in,
		b_cas_out,
		
		acc_en,
		res_cas_in,
		res_out,
		res_cas_out,

		config_en,
		config_in,
		config_out

	);
	
	///////// Parameters
	parameter PE_W = 3;
	parameter PE_H = 4; //4

	parameter FLEX_A   = "FIXED_H";		// "FIXED_H", "FIXED_V", "FLEXIBLE"
	parameter FLEX_B   = "FIXED_V";		// "FIXED_V"
	parameter FLEX_RES = "FLEXIBLE";	// "FIXED_H", "FIXED_V", "FLEXIBLE"

	parameter PR_CAS = (PE_W > PE_H) ? PE_W : PE_H;

	parameter A_W = 8;
	parameter A_D = 6; //6
	
	parameter B_W = 8;
	parameter B_D = 4; //4

	parameter RES_W = 32;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";	// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"
	parameter ACC_D = 2; //2

	///////// IOs
	input clk;
	input reset;

	input hp_en;

	input [PE_H*A_W-1:0] a;
	input a_en;

	input [PE_W*B_W-1:0] b;
	input [PE_W*B_W-1:0] b_cas_in;
	output [PE_W*B_W-1:0] b_cas_out;
	input b_en;

	input acc_en;
	output [PR_CAS*RES_W-1:0] res_out;

	input [PR_CAS*RES_W-1:0] res_cas_in;
	output [PR_CAS*RES_W-1:0] res_cas_out;

	input config_en;
	input config_in;
	output config_out;

	defparam MLBlock_inst.PE_W = PE_W;
	defparam MLBlock_inst.PE_H = PE_H;

	defparam MLBlock_inst.FLEX_A = FLEX_A;
	defparam MLBlock_inst.FLEX_B = FLEX_B;
	defparam MLBlock_inst.FLEX_RES = FLEX_RES;

	defparam MLBlock_inst.A_W = A_W;
	defparam MLBlock_inst.A_D = A_D;
	defparam MLBlock_inst.B_W = B_W;
	defparam MLBlock_inst.B_D = B_D;
	defparam MLBlock_inst.RES_W = RES_W;
	defparam MLBlock_inst.SHIFTER_TYPE = SHIFTER_TYPE;
	defparam MLBlock_inst.ACC_D = ACC_D;
	MLBlock MLBlock_inst(
		.clk(clk), 
		.reset(reset),

		.hp_en(hp_en),

		.a_en(a_en),
		.a(a), 
		.a_out(),
		
		.b_en(b_en),
		.b(b),
		.b_cas_in(b_cas_in),
		.b_out(),
		.b_cas_out(b_cas_out),
		
		.acc_en(acc_en),
		.res_cas_in(res_cas_in),
		.res_out(res_out),
		.res_cas_out(res_cas_out),

		.config_en(config_en),
		.config_in(config_in),
		.config_out(config_out)
	);

endmodule 
