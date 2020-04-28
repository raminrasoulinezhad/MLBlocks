module MLBlock_sample (
		clk, 
		reset,

		hp_en,

		a, 
		a_en,

		b,
		b_cas_in,
		b_cas_out,
		b_en,

		res_out,

		res_cas_in,
		res_cas_out,

		config_en,
		config_in,
		config_out

	);
	
	///////// Parameters
	parameter PE_W = 3;
	parameter PE_H = 4; //4

	parameter PR_CAS = (PE_W > PE_H) ? PE_W : PE_H;

	parameter A_W = 8;
	parameter A_D = 6;
	
	parameter B_W = 8;
	parameter B_D = 4;

	parameter RES_W = 32;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";	// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx" 
	// "BYPASS"				: 8x8 						: MODE_WIDTH = 0
	// "2Wx2V_by_WxV"		: 8x8, 8x16, 8x24, 16x16	: MODE_WIDTH = 2
	// "2Wx2V_by_WxV_apx" 	: 8x8, 8x16, 16x16(apx)		: MODE_WIDTH = 2

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

	output [PR_CAS*RES_W-1:0] res_out;

	input [PR_CAS*RES_W-1:0] res_cas_in;
	output [PR_CAS*RES_W-1:0] res_cas_out;

	input config_en;
	input config_in;
	output config_out;

	defparam MLBlock_inst.PE_W = PE_W;
	defparam MLBlock_inst.PE_H = PE_H;

	defparam MLBlock_inst.A_W = A_W;
	defparam MLBlock_inst.A_D = A_D;
	defparam MLBlock_inst.B_W = B_W;
	defparam MLBlock_inst.B_D = B_D;
	defparam MLBlock_inst.RES_W = RES_W;
	defparam MLBlock_inst.SHIFTER_TYPE = SHIFTER_TYPE;
	MLBlock MLBlock_inst(
		.clk(clk), 
		.reset(reset),

		.hp_en(hp_en),

		.a(a), 
		.a_out(),
		.a_en(a_en),

		.b(b),
		.b_cas_in(b_cas_in),
		.b_cas_out(b_cas_out),
		.b_en(b_en),

		.res_out(res_out),

		.res_cas_in(res_cas_in),
		.res_cas_out(res_cas_out),

		.config_en(config_en),
		.config_in(config_in),
		.config_out(config_out)
	);

endmodule 
