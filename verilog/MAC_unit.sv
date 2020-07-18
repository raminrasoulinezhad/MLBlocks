module MAC_unit (
		clk, 
		reset,

		configg,
		hp_en,

		I_configs,
		I_en,
		I_mux,
		I_cascade,

		W_in,
		W_en,
		W_out,

		Res_configs,	
		Res_en,
		Res_depth,
		Res_cascade,

		config_en,
		config_in,
		config_out
	);

	///////// Parameters
	parameter N_OF_COFIGS = 4;
	localparam N_OF_COFIGS_LOG2 = $clog2(N_OF_COFIGS);

	parameter I_W = 8;
	parameter I_D = 4;
	localparam I_D_HALF = I_D / 2;
	
	parameter W_W = 8;
	parameter W_D = 4;
	localparam W_D_LOG2 = $clog2(W_D);

	parameter RES_W = 32;
	parameter RES_D = 1;
	localparam RES_D_CNTL = (RES_D > 1)? (RES_D-1): 1;

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

	///////// IOs
	input clk;
	input reset;

	input hp_en;
	
	input [N_OF_COFIGS_LOG2-1:0] configg;
		
	input [I_W-1:0] I_configs [N_OF_COFIGS-1:0];
	input I_en;
	input [I_D_HALF-1:0] I_mux;
	output [I_W-1:0] I_cascade;

	input [W_W-1:0] W_in;
	input W_en;
	output [W_W-1:0] W_out;

	input [RES_W-1:0] Res_configs [N_OF_COFIGS-1:0];
	input Res_en;
	input [RES_D_CNTL-1:0] Res_depth;
	output [RES_W-1:0] Res_cascade;

	input config_en;
	input config_in;
	output config_out;

	///////// internal signals
	wire [I_W-1:0] I_in;
	assign I_in = I_configs[configg]; 

	wire [RES_W-1:0] Res_in;
	assign Res_in = Res_configs[configg];

	wire [W_D_LOG2-1:0] b_addr;

	wire [I_W-1:0] mult_in_a;
	wire [W_W-1:0] mult_in_b;

	wire mult_in_a_s;
	wire mult_in_b_s;
	
	wire [I_W+W_W-1:0] mult_res;

	wire shifter_sign;
	wire [RES_W-1:0] shifter_res;

	wire [SHIFTER_MODE_WIDTH-1:0] shifter_mode;
	wire acc_mode;
	

	defparam stream_flex_inst.WIDTH = I_W;
	defparam stream_flex_inst.DEPTH = I_D;
	stream_flex stream_flex_inst(
		.clk(clk), 
		.reset(reset),

		.in(I_in),
		.en(I_en),

		.out(mult_in_a),

		.depth(I_mux),
		.cascade(I_cascade)
	);

	defparam stream_mem_inst.WIDTH = W_W;
	defparam stream_mem_inst.DEPTH = W_D;
	stream_mem stream_mem_inst (
		.clk(clk), 
		.reset(reset),

		.in(W_in),
		.en(W_en),

		.addr(b_addr),
		.out(mult_in_b),
		
		.cascade(W_out)
	);

	defparam mult_flex_inst.A_W = I_W;
	defparam mult_flex_inst.B_W = W_W;
	mult_flex mult_flex_inst(
		.a(mult_in_a),
		.a_s(mult_in_a_s),

		.b(mult_in_b),
		.b_s(mult_in_b_s),

		.res(mult_res)
	);

	assign shifter_sign = mult_in_a_s | mult_in_b_s;

	defparam shifter_inst.A_W = I_W;
	defparam shifter_inst.B_W = W_W;
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
	defparam accumulator_inst.WIDTH = RES_W;
	defparam accumulator_inst.DEPTH = RES_D;
	accumulator accumulator_inst(
		.clk(clk), 
		.reset(reset),

		.Res_in(Res_in),
		.Res_en(Res_en),

		.Res_mode(acc_mode),
		.Res_depth(Res_depth),

		.mult_result(shifter_res),

		.Res_cascade(Res_cascade)
	);

	defparam state_machine_inst.SHIFTER_TYPE = SHIFTER_TYPE;
	defparam state_machine_inst.SHIFTER_MODE_WIDTH = SHIFTER_MODE_WIDTH;
	defparam state_machine_inst.B_D = W_D;
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
