module pe (
		clk, 
		reset,

		hp_en,

		a,
		a_en,
		a_out,

		b,
		b_en,
		b_out,

		res_in_h,
		res_in_v,

		res_out_h,
		res_out_v,

		config_en,
		config_in,
		config_out
	);

	///////// Parameters
	parameter A_W = 8;
	
	parameter B_W = 8;
	parameter B_D = 4;
	localparam B_D_LOG2 = $clog2(B_D);

	parameter RES_W = 32;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";	// "2Wx2V_by_WxV", "BYPASS"
	localparam SHIFTER_MODE_WIDTH = 2;			// it is determined by SHIFTER_TYPE. for "2Wx2V_by_WxV" is 2. for "BYPASS" does not matter.
	localparam SHIFTER_OUT_WIDTH = RES_W;

	localparam ACC_TYPE = (SHIFTER_TYPE == "2Wx2V_by_WxV") ? ("FEEDBACK") : ("FEEDFORWARD");	// "FEEDBACK", "FEEDFORWARD"
	localparam ACC_WIDTH = RES_W;

	localparam CNTR_MEM_D = (SHIFTER_TYPE == "2Wx2V_by_WxV") ? 4 : 1;

	///////// IOs
	input clk;
	input reset;

	input hp_en;
	
	input [A_W-1:0] a;
	input a_en;
	output [A_W-1:0] a_out;

	input [B_W-1:0] b;
	input b_en;
	output [B_W-1:0] b_out;
	
	input [RES_W-1:0] res_in_h;
	input [RES_W-1:0] res_in_v;

	output [RES_W-1:0] res_out_h;
	output [RES_W-1:0] res_out_v;

	input config_en;
	input config_in;
	output config_out;

	///////// internal signals
	wire a_mux;
	wire res_in_select;

	wire [B_D_LOG2-1:0] b_addr;

	wire [A_W-1:0] mult_in_a;
	wire [B_W-1:0] mult_in_b;

	wire mult_in_a_s;
	wire mult_in_b_s;
	
	wire [A_W+B_W-1:0] mult_res;

	wire shifter_sign;
	wire [RES_W-1:0] shifter_res;

	wire [SHIFTER_MODE_WIDTH-1:0] shifter_mode;
	wire acc_mode;
	

	defparam stream_flex_inst.A_W = A_W;
	stream_flex stream_flex_inst(
		.clk(clk), 
		.reset(reset),

		.a(a),
		.a_en(a_en),

		.mult_out(mult_in_a),

		.a_mux(a_mux),
		.a_out(a_out)
	);

	defparam stream_mem_inst.B_W = B_W;
	defparam stream_mem_inst.B_D = B_D;
	stream_mem stream_mem_inst (
		.clk(clk), 
		.reset(reset),

		.b(b),
		.b_en(b_en),

		.mult_out(mult_in_b),
		.b_addr(b_addr),

		.b_out(b_out)
	);

	defparam mult_flex_inst.A_W = A_W;
	defparam mult_flex_inst.B_W = B_W;
	mult_flex mult_flex_inst(
		.a(mult_in_a),
		.a_s(mult_in_a_s),

		.b(mult_in_b),
		.b_s(mult_in_b_s),

		.res(mult_res)
	);

	assign shifter_sign = mult_in_a_s | mult_in_b_s;

	defparam shifter_inst.A_W = A_W;
	defparam shifter_inst.B_W = B_W;
	defparam shifter_inst.MODE_WIDTH = SHIFTER_MODE_WIDTH;
	defparam shifter_inst.OUT_WIDTH = SHIFTER_OUT_WIDTH;
	defparam shifter_inst.TYPE = SHIFTER_TYPE;
	shifter shifter_inst(
		.in(mult_res),
		.in_s(shifter_sign),

		.mode(shifter_mode),

		.out(shifter_res)
	);
	
	defparam accumulator_inst.TYPE = ACC_TYPE;
	defparam accumulator_inst.WIDTH = ACC_WIDTH;
	accumulator accumulator_inst(
		.clk(clk), 
		.reset(reset),

		.acc_mode(acc_mode),
		.res_in_select(res_in_select),

		.res_in_h(res_in_h),
		.res_in_v(res_in_v),

		.shifter_res(shifter_res),

		.res_out_h(res_out_h),
		.res_out_v(res_out_v)

	);

	defparam state_machine_inst.SHIFTER_TYPE = SHIFTER_TYPE;
	defparam state_machine_inst.SHIFTER_MODE_WIDTH = SHIFTER_MODE_WIDTH;
	defparam state_machine_inst.B_D = B_D;
	defparam state_machine_inst.CNTR_MEM_D = CNTR_MEM_D;
	state_machine state_machine_inst(
		.clk(clk), 
		.reset(reset),

		.a_mux(a_mux),
		.res_in_select(res_in_select),
		
		.hp_en(hp_en),

		.a_s(mult_in_a_s),
		.b_s(mult_in_b_s),

		.b_addr(b_addr),
		.shifter_mode(shifter_mode),
		.acc_mode(acc_mode),
		
		.config_en(config_en),
		.config_in(config_in),
		.config_out(config_out)
	);

endmodule 