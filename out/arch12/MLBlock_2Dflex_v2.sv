module MLBlock_2Dflex_v2 (
		clk, 
		reset,

		configg,
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
	// architecture and precision parameters
	`include "MLBlock_2Dflex_v2_params.sv"

	///////// IOs
	input clk;
	input reset;

	input [N_OF_COFIGS_LOG2-1:0] configg;
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
	reg [I_S_LOG2-1:0] conf_a_speed;
	reg [I_D_LOG2-1:0] conf_a_mux;
	reg [RES_D_LOG2-1:0] conf_acc_depth;

	integer l, m, n;
	always @ (posedge clk) begin
		if (config_en) begin 
			
			conf_a_speed[0] <= config_in;
			
			for (n = 1; n < I_S_LOG2; n = n + 1)begin
				conf_a_speed[n] <= conf_a_speed[n-1];
			end 

			if (I_S > 1) begin 
				conf_a_mux[0] <= conf_a_speed[I_S_LOG2-1];
			end else begin 
				conf_a_mux[0] <= config_in;
			end 
			
			for (l = 1; l < I_D_LOG2; l = l + 1)begin
				conf_a_mux[l] <= conf_a_mux[l-1];
			end 
			
			conf_acc_depth[0] <= conf_a_mux[I_D_LOG2-1];
			
			for (m = 1; m < RES_D_LOG2; m = m + 1)begin
				conf_acc_depth[m] <= conf_acc_depth[m-1];
			end 
		end
	end 

	///////// internal signals
	wire [I_W-1:0] I_in_temp [PORT_I_SIZE-1:0];
	wire [I_W-1:0] I_configs [MAC_UNITS-1:0][N_OF_COFIGS-1:0][I_S-1:0];
	wire [I_W-1:0] I_cascade [MAC_UNITS-1:0][I_S-1:0];

	wire [W_W-1:0] W_in_temp [MAC_UNITS:0];
	assign W_in_temp[0] = W_in;
	assign W_out = W_in_temp[MAC_UNITS];

	wire [RES_W-1:0] Res_cas_in_temp [PORT_RES_SIZE-1:0];
	wire [RES_W-1:0] Res_configs [MAC_UNITS-1:0][N_OF_COFIGS-1:0];
	wire [RES_W-1:0] Res_cascade [MAC_UNITS-1:0];
	wire [RES_W-1:0] Res_out_temp [PORT_RES_SIZE-1:0][N_OF_COFIGS-1:0];
	assign Res_cas_out = Res_out; 


	wire [MAC_UNITS:0] config_in_mac_units;
	assign config_in_mac_units[0] = (RES_D > 1) ? conf_acc_depth[RES_D_LOG2-1] : conf_a_mux[I_D_LOG2-1];
	assign config_out = config_in_mac_units[MAC_UNITS];
	
	`include "MLBlock_2Dflex_v2_interconnects.sv"

	genvar i,j,k;
	generate 
		
		for (j = 0; j < PORT_I_SIZE; j = j + 1) begin 
			assign I_in_temp[j] = I_in[(j+1)*I_W-1:j*I_W];
		end 

		for (k = 0; k < PORT_RES_SIZE; k = k + 1) begin 
			assign Res_cas_in_temp[k] = (Res_cas_in_zero) ? 0 : Res_cas_in[(k+1)*RES_W-1:k*RES_W];
			assign Res_out[(k+1)*RES_W-1:k*RES_W] = Res_out_temp[k][configg];
		end 

		for (i = 0; i < MAC_UNITS; i = i + 1) begin 

			wire [I_W-1:0] I_configs_local [N_OF_COFIGS-1:0][I_S-1:0];
			for (j = 0; j < N_OF_COFIGS; j = j + 1) begin 
				assign I_configs_local[j] = I_configs[i][j];
			end 
			wire [RES_W-1:0] Res_configs_local [N_OF_COFIGS-1:0];
			for (j = 0; j < N_OF_COFIGS; j = j + 1) begin 
				assign Res_configs_local[j] = Res_configs[i][j];
			end 

			defparam MAC_unit_v2_inst.N_OF_COFIGS_I = N_OF_COFIGS;
			defparam MAC_unit_v2_inst.N_OF_COFIGS_RES = N_OF_COFIGS;
			defparam MAC_unit_v2_inst.I_W = I_W;
			defparam MAC_unit_v2_inst.I_D = I_D;
			defparam MAC_unit_v2_inst.I_S = I_S;
			defparam MAC_unit_v2_inst.W_W = W_W;
			defparam MAC_unit_v2_inst.W_D = W_D;
			defparam MAC_unit_v2_inst.RES_W = RES_W;
			defparam MAC_unit_v2_inst.RES_D = RES_D;
			defparam MAC_unit_v2_inst.SHIFTER_TYPE = SHIFTER_TYPE;
			MAC_unit_v2 MAC_unit_v2_inst(
				.clk(clk), 
				.reset(reset),

				.config_I(configg),
				.config_Res(configg),
				.hp_en(hp_en),

				.I_configs(I_configs_local),
				.I_en(I_en),
				.I_mux(conf_a_mux),
				.I_speed(conf_a_speed),
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

		end 

	endgenerate 

endmodule 
