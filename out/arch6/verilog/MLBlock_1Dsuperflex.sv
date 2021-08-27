module MLBlock_1Dsuperflex (
		clk, 
		reset,

		hp_en,

		I_in,
		I_en,

		W_in,
		W_en,
		W_out,
		
		Res_en,
		Res_cas_in,
		Res_cas_in_zero,
		Res_out,
		Res_cas_out,

		config_en,
		config_in,
		config_out
	);
	
	///////// Parameters
	parameter MAC_UNITS = 12; 

	parameter PORT_I_SIZE = 4; 
	parameter PORT_W_SIZE = 1;		// Other values are not supported 
	parameter PORT_RES_SIZE = 4; 

	localparam PORT_I_SIZE_P1_LOG2 = $clog2(PORT_I_SIZE + 1);
	localparam PORT_RES_SIZE_P1_LOG2 = $clog2(PORT_RES_SIZE + 1);

	parameter I_W = 8; 
	parameter I_D = 4; 
	localparam I_D_HALF = I_D / 2;

	parameter W_W = 8; 
	parameter W_D = 4; 

	parameter RES_W = 32; 
	parameter RES_D = 1; 
	localparam RES_D_CNTL = (RES_D > 1)? (RES_D-1): 1;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";		// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"

	///////// IOs
	input clk;
	input reset;

	input hp_en;

	input I_en;
	input [PORT_I_SIZE*I_W-1:0] I_in;
	
	input W_en;
	input [PORT_W_SIZE*W_W-1:0] W_in;
	output [PORT_W_SIZE*W_W-1:0] W_out;
	
	input Res_en;
	input [PORT_RES_SIZE*RES_W-1:0] Res_cas_in;
	input Res_cas_in_zero;
	output [PORT_RES_SIZE*RES_W-1:0] Res_out;
	output [PORT_RES_SIZE*RES_W-1:0] Res_cas_out;

	input config_en;
	input config_in;
	output config_out;
		
	///////// Configurations
	reg [PORT_RES_SIZE*MAC_UNITS-1:0] conf_out_units;
	reg [PORT_I_SIZE_P1_LOG2*MAC_UNITS-1:0] config_I;
	reg [PORT_RES_SIZE_P1_LOG2*MAC_UNITS-1:0] config_Res;

	reg [I_D_HALF-1:0] conf_a_mux;
	reg [RES_D_CNTL-1:0] conf_acc_depth;

	integer l, m;
	always @ (posedge clk) begin
		if (config_en) begin 
			conf_out_units[0] <= config_in;
			for (l = 1; l < (PORT_RES_SIZE*MAC_UNITS); l = l + 1)begin
				conf_out_units[l] <= conf_out_units[l-1];
			end 
			config_I[0] <= conf_out_units[PORT_RES_SIZE*MAC_UNITS-1];
			for (l = 1; l < (PORT_I_SIZE_P1_LOG2*MAC_UNITS); l = l + 1)begin
				config_I[l] <= config_I[l-1];
			end 
			config_Res[0] <= config_I[PORT_I_SIZE_P1_LOG2*MAC_UNITS-1];
			for (l = 1; l < (PORT_RES_SIZE_P1_LOG2*MAC_UNITS); l = l + 1)begin
				config_Res[l] <= config_Res[l-1];
			end 
			conf_a_mux[0] <= config_Res[PORT_RES_SIZE_P1_LOG2*MAC_UNITS-1];
			for (l = 1; l < I_D_HALF; l = l + 1)begin
				conf_a_mux[l] <= conf_a_mux[l-1];
			end 
			conf_acc_depth[0] <= conf_a_mux[I_D_HALF-1];
			for (m = 1; m < RES_D_CNTL; m = m + 1)begin
				conf_acc_depth[m] <= conf_acc_depth[m-1];
			end 
		end
	end 


	///////// internal signals
	wire [I_W-1:0] I_in_temp [PORT_I_SIZE-1:0];
	wire [I_W-1:0] I_cascade [MAC_UNITS-1:0];

	wire [W_W-1:0] W_in_temp [MAC_UNITS:0];
	assign W_in_temp[0] = W_in;
	assign W_out = W_in_temp[MAC_UNITS];

	wire [RES_W-1:0] Res_cas_in_temp [PORT_RES_SIZE-1:0];
	wire [RES_W-1:0] Res_cascade [MAC_UNITS-1:0];
	wire [RES_W-1:0] Res_out_temp [PORT_RES_SIZE-1:0];
	assign Res_cas_out = Res_out; 

	wire [MAC_UNITS:0] config_in_mac_units;
	assign config_in_mac_units[0] = (RES_D > 1) ? conf_acc_depth[RES_D_CNTL-1] : conf_a_mux[I_D_HALF-1];
	assign config_out = config_in_mac_units[MAC_UNITS];

	genvar i,j,k;
	generate 
		
		for (j = 0; j < PORT_I_SIZE; j = j + 1) begin 
			assign I_in_temp[j] = I_in[(j+1)*I_W-1:j*I_W];
		end 

		for (k = 0; k < PORT_RES_SIZE; k = k + 1) begin 
			assign Res_cas_in_temp[k] = (Res_cas_in_zero) ? 0 : Res_cas_in[(k+1)*RES_W-1:k*RES_W];
			assign Res_out[(k+1)*RES_W-1:k*RES_W] = Res_out_temp[k];
		end 

		for (i = 0; i < MAC_UNITS; i = i + 1) begin 

			wire [I_W-1:0] I_configs_local [PORT_I_SIZE:0];
			for (j = 0; j < PORT_I_SIZE; j = j + 1) begin 
				assign I_configs_local[j] = I_in_temp[j];
			end 
			if (i == 0) begin 
				assign I_configs_local[PORT_I_SIZE] = {I_W{1'bx}};
			end else begin 
				assign I_configs_local[PORT_I_SIZE] = I_cascade[i-1];
			end 

			wire [RES_W-1:0] Res_configs_local [PORT_RES_SIZE:0];
			for (j = 0; j < PORT_RES_SIZE; j = j + 1) begin 
				assign Res_configs_local[j] = Res_cas_in_temp[j];
			end 
			if (i == 0) begin 
				assign Res_configs_local[PORT_RES_SIZE] = {RES_W{1'bx}};
			end else begin 
				assign Res_configs_local[PORT_RES_SIZE] = Res_cascade[i-1];
			end 

			defparam MAC_unit_inst.N_OF_COFIGS_I = PORT_I_SIZE + 1;
			defparam MAC_unit_inst.N_OF_COFIGS_RES = PORT_RES_SIZE + 1;
			defparam MAC_unit_inst.I_W = I_W;
			defparam MAC_unit_inst.I_D = I_D;
			defparam MAC_unit_inst.W_W = W_W;
			defparam MAC_unit_inst.W_D = W_D;
			defparam MAC_unit_inst.RES_W = RES_W;
			defparam MAC_unit_inst.RES_D = RES_D;
			defparam MAC_unit_inst.SHIFTER_TYPE = SHIFTER_TYPE;
			MAC_unit MAC_unit_inst(
				.clk(clk), 
				.reset(reset),

				.config_I(config_I[((i+1)*PORT_I_SIZE_P1_LOG2)-1 : i*PORT_I_SIZE_P1_LOG2]),
				.config_Res(config_Res[((i+1)*PORT_RES_SIZE_P1_LOG2)-1 : i*PORT_RES_SIZE_P1_LOG2]),
				.hp_en(hp_en),

				.I_configs(I_configs_local),
				.I_en(I_en),
				.I_mux(conf_a_mux),
				.I_cascade(I_cascade[i]),

				.W_in(W_in_temp[i]),
				.W_en(W_en),
				.W_out(W_in_temp[i+1]),

				.Res_configs(Res_configs_local),
				.Res_en(Res_en),
				.Res_depth(conf_acc_depth),
				.Res_cascade(Res_cascade[i]),

				.config_en(config_en),
				.config_in(config_in_mac_units[i]),
				.config_out(config_in_mac_units[i+1])
			);

			defparam out_unit_inst.WIDTH = RES_W;
			defparam out_unit_inst.N_OUT = PORT_RES_SIZE;
			out_unit	out_unit_inst(
				.in(Res_cascade[i]),
				.addr(conf_out_units[((i+1)*PORT_RES_SIZE)-1 : i*PORT_RES_SIZE]),
				.out(Res_out_temp)
			);

		end 

	endgenerate 

endmodule 
