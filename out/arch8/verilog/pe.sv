module pe (
		clk, 
		reset,

		hp_en,


		a_in_select,
		a_in_h,
		a_in_v,
		
		a_en,
		a_mux,

		a_out_h,
		a_out_v,


		b_in_select,
		b_in_h,
		b_in_v,

		b_en,
		
		b_out_h,
		b_out_v,


		res_in_select,
		res_in_h,
		res_in_v,

		acc_en,
		acc_depth,

		res_out_h,
		res_out_v,

		config_en,
		config_in,
		config_out
	);

	///////// Parameters
	parameter A_W = 8;
	parameter A_D = 4;
	localparam A_D_HALF = A_D / 2;
	
	parameter B_W = 8;
	parameter B_D = 4;
	localparam B_D_LOG2 = $clog2(B_D);

	parameter RES_W = 32;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV"; // "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv" 
	
	function integer func_mode_width_selector; 
		input [40*8:0] str;
		// "BYPASS"					: 8x8 						: MODE_WIDTH = 0
		// "2Wx2V_by_WxV"			: 8x8, 8x16, 8x24, 16x16	: MODE_WIDTH = 2
		// "2Wx2V_by_WxV_apx" 		: 8x8, 8x16, 16x16(apx)		: MODE_WIDTH = 1	
		// "2Wx2V_by_WxV_apx_adv" 	: 8x8, 8x16, 16x16(apx_adv)	: MODE_WIDTH = 2
		if (str == "BYPASS") begin
			func_mode_width_selector = 0;	// 2
		end else if (str == "2Wx2V_by_WxV") begin 
			func_mode_width_selector = 2;
		end else if (str == "2Wx2V_by_WxV_apx") begin 
			func_mode_width_selector = 1;	// 2 
		end else if (str == "2Wx2V_by_WxV_apx_adv") begin 
			func_mode_width_selector = 2;
		end else begin 
			func_mode_width_selector = -1;
		end 
	endfunction

	localparam SHIFTER_MODE_WIDTH = func_mode_width_selector(SHIFTER_TYPE);
	
	localparam SHIFTER_OUT_WIDTH = RES_W;

	localparam ACC_TYPE = (SHIFTER_TYPE == "BYPASS") ? ("FEEDFORWARD") : ("FEEDBACK");	// "FEEDBACK", "FEEDFORWARD"
	localparam ACC_WIDTH = RES_W;
	parameter ACC_D = 1;
	localparam ACC_D_CNTL = (ACC_D > 1)? (ACC_D-1): 1;

	///////// IOs
	input clk;
	input reset;

	input hp_en;
	
	input a_in_select;
	input [A_W-1:0] a_in_h;
	input [A_W-1:0] a_in_v;
	
	input a_en;
	input [A_D_HALF-1:0] a_mux;
	
	output [A_W-1:0] a_out_h;
	output [A_W-1:0] a_out_v;


	input b_in_select;
	input [B_W-1:0] b_in_h;
	input [B_W-1:0] b_in_v;
	
	input b_en;
	
	output [B_W-1:0] b_out_h;
	output [B_W-1:0] b_out_v;
	

	input acc_en;
	input [ACC_D_CNTL-1:0] acc_depth;

	input res_in_select;
	input [RES_W-1:0] res_in_h;
	input [RES_W-1:0] res_in_v;

	output [RES_W-1:0] res_out_h;
	output [RES_W-1:0] res_out_v;

	input config_en;
	input config_in;
	output config_out;

	///////// internal signals
	
	wire [A_W-1:0] a;
	wire [A_W-1:0] a_out;
	assign a = (a_in_select == 1'b1) ? a_in_v : a_in_h; 
	assign a_out_h = a_out;
	assign a_out_v = a_out;

	wire [B_W-1:0] b;
	wire [B_W-1:0] b_out;
	assign b = (b_in_select == 1'b1) ? b_in_v : b_in_h; 
	assign b_out_h = b_out;
	assign b_out_v = b_out;

	wire [RES_W-1:0] res_in;
	wire [RES_W-1:0] res_out;
	assign res_in = (res_in_select == 1'b1) ? res_in_v : res_in_h;
	assign res_out_h = res_out;
	assign res_out_v = res_out;

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
	

	defparam stream_flex_inst.WIDTH = A_W;
	defparam stream_flex_inst.DEPTH = A_D;
	stream_flex stream_flex_inst(
		.clk(clk), 
		.reset(reset),

		.in(a),
		.en(a_en),

		.out(mult_in_a),

		.depth(a_mux),
		.cascade(a_out)
	);

	defparam stream_mem_inst.WIDTH = B_W;
	defparam stream_mem_inst.DEPTH = B_D;
	stream_mem stream_mem_inst (
		.clk(clk), 
		.reset(reset),

		.in(b),
		.en(b_en),

		.addr(b_addr),
		.out(mult_in_b),

		.cascade(b_out)
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
	defparam shifter_inst.OUT_WIDTH = SHIFTER_OUT_WIDTH;
	defparam shifter_inst.TYPE = SHIFTER_TYPE;
	defparam shifter_inst.MODE_WIDTH = SHIFTER_MODE_WIDTH;
	shifter shifter_inst(
		.in(mult_res),
		.in_s(shifter_sign),

		.mode(shifter_mode),

		.out(shifter_res)
	);
	
	defparam accumulator_inst.TYPE = ACC_TYPE;
	defparam accumulator_inst.WIDTH = ACC_WIDTH;
	defparam accumulator_inst.DEPTH = ACC_D;
	accumulator accumulator_inst(
		.clk(clk), 
		.reset(reset),

		.Res_in(res_in),
		.Res_en(acc_en),

		.Res_mode(acc_mode),
		.Res_depth(acc_depth),

		.mult_result(shifter_res),

		.Res_cascade(res_out)
	);

	defparam state_machine_inst.SHIFTER_TYPE = SHIFTER_TYPE;
	defparam state_machine_inst.SHIFTER_MODE_WIDTH = SHIFTER_MODE_WIDTH;
	defparam state_machine_inst.B_D = B_D;
	state_machine state_machine_inst(
		.clk(clk), 
		.reset(reset),
		
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
