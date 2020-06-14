module MLBlock (
		clk, 
		reset,

		hp_en,

		a_en,
		a, 
		a_out,

		b_en,
		b,
		b_cas_in,
		b_out,
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
	parameter PE_H = 4;

	parameter FLEX_A   = "FIXED_H";		// "FIXED_H", "FIXED_V", "FLEXIBLE"
	parameter FLEX_B   = "FIXED_V";		// "FIXED_V"
	parameter FLEX_RES = "FLEXIBLE";	// "FIXED_H", "FIXED_V", "FLEXIBLE"

	function integer port_sizer; 
		input [40*8:0] str;
		input integer pe_w;
		input integer pe_h;
		if (str == "FLEXIBLE") begin
			port_sizer = (pe_h > pe_w)? pe_h : pe_w;
		end else if (str == "FIXED_H") begin 
			port_sizer = pe_h;
		end else if (str == "FIXED_V") begin 
			port_sizer = pe_w;
		end else begin 
			port_sizer = -1;
		end 
	endfunction

	localparam PORT_A_SIZE   = port_sizer(FLEX_A,   PE_W, PE_H);
	localparam PORT_B_SIZE   = port_sizer(FLEX_B,   PE_W, PE_H);
	localparam PORT_RES_SIZE = port_sizer(FLEX_RES, PE_W, PE_H);

	parameter A_W = 8;
	parameter A_D = 4;
	localparam A_D_HALF = A_D / 2;
	
	parameter B_W = 8;
	parameter B_D = 4;

	parameter RES_W = 32;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";	// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"

	parameter ACC_D = 1;
	localparam ACC_D_CNTL = (ACC_D > 1)? (ACC_D-1): 1;

	///////// IOs
	input clk;
	input reset;

	input hp_en;

	input a_en;
	input [PORT_A_SIZE*A_W-1:0] a;
	output [PORT_A_SIZE*A_W-1:0] a_out;
	
	input b_en;
	input [PORT_B_SIZE*B_W-1:0] b;
	input [PORT_B_SIZE*B_W-1:0] b_cas_in;
	output [PORT_B_SIZE*B_W-1:0] b_out;
	output [PORT_B_SIZE*B_W-1:0] b_cas_out;
	
	input acc_en;
	input [PORT_RES_SIZE*RES_W-1:0] res_cas_in;
	output [PORT_RES_SIZE*RES_W-1:0] res_out;
	output [PORT_RES_SIZE*RES_W-1:0] res_cas_out;

	input config_en;
	input config_in;
	output config_out;

	///////// Configurations
	reg [A_D_HALF-1:0] conf_a_mux;
	reg conf_a_in_select;		// for primary model: fixed 0 (Horizontal)
	reg conf_b_in_select;		// for primary model: fixed 1 (Vertical)
	reg conf_res_in_select;		
	reg conf_res_cas_in_zero;
	reg conf_b_cas_in_select;
	reg [ACC_D_CNTL-1:0] conf_acc_depth;

	integer l, m;
	always @ (posedge clk) begin
		if (config_en) begin 
			conf_a_mux[0] <= config_in;
			for (l = 1; l < A_D_HALF; l = l + 1)begin
				conf_a_mux[l] <= conf_a_mux[l-1];
			end 
			conf_a_in_select <= conf_a_mux[A_D_HALF-1];
			conf_b_in_select <= conf_a_in_select;
			conf_res_in_select <= conf_b_in_select;
			conf_res_cas_in_zero <= conf_res_in_select;
			conf_b_cas_in_select <= conf_res_cas_in_zero;
			conf_acc_depth[0] <= conf_b_cas_in_select;
			for (m = 1; m < ACC_D_CNTL; m = m + 1)begin
				conf_acc_depth[m] <= conf_acc_depth[m-1];
			end 
		end
	end 
	wire config_in_pes;
	assign config_in_pes = (ACC_D > 1) ? conf_acc_depth[ACC_D_CNTL-1] : conf_b_cas_in_select;

	///////// internal signals
	wire [A_W-1:0] a_in_h_temp [PE_H-1:0][PE_W:0];
	wire [A_W-1:0] a_in_v_temp [PE_H:0][PE_W-1:0];

	wire [B_W-1:0] b_in_temp [PORT_B_SIZE-1:0];
	wire [B_W-1:0] b_in_h_temp [PE_H-1:0][PE_W:0];
	wire [B_W-1:0] b_in_v_temp [PE_H:0][PE_W-1:0];

	wire [RES_W-1:0] res_cas_in_temp [PORT_RES_SIZE-1:0];
	wire [RES_W-1:0] res_in_h_temp [PE_H-1:0][PE_W:0];
	wire [RES_W-1:0] res_in_v_temp [PE_H:0][PE_W-1:0];

	wire [0:0] config_in_temp [PE_H-1:0][PE_W:0];

	genvar i,j,k;
	generate 
		
		for (k = 0; k < PORT_RES_SIZE; k = k + 1) begin 
			
			assign res_cas_in_temp[k] = (conf_res_cas_in_zero) ? 0 : res_cas_in[(k+1)*RES_W-1:k*RES_W];

			if (k > (PE_H-1)) begin 
				assign res_out[(k+1)*RES_W-1:k*RES_W] = res_in_v_temp[PE_H][k]; 
			end else if (k > (PE_W-1)) begin 
				assign res_out[(k+1)*RES_W-1:k*RES_W] = res_in_h_temp[k][PE_W]; 
			end else begin 
				assign res_out[(k+1)*RES_W-1:k*RES_W] = (conf_res_in_select) ? res_in_v_temp[PE_H][k]: res_in_h_temp[k][PE_W]; 
			end 
			
			assign res_cas_out[(k+1)*RES_W-1:k*RES_W] = res_out[(k+1)*RES_W-1:k*RES_W];
		end 
		
		for (k = 0; k < PORT_B_SIZE; k = k + 1) begin 
			assign b_in_temp[k] = (conf_b_cas_in_select) ? b_cas_in[(k+1)*B_W-1:k*B_W] : b[(k+1)*B_W-1:k*B_W];

			if (k > (PE_H-1)) begin 
				assign b_out[(k+1)*B_W-1:k*B_W] = b_in_v_temp[PE_H][k]; 
			end else if (k > (PE_W-1)) begin 
				assign b_out[(k+1)*B_W-1:k*B_W] = b_in_h_temp[k][PE_W]; 
			end else begin 
				assign b_out[(k+1)*B_W-1:k*B_W] = (conf_b_in_select) ? b_in_v_temp[PE_H][k]: b_in_h_temp[k][PE_W]; 
			end 

			assign b_cas_out[(k+1)*B_W-1:k*B_W] = b_out[(k+1)*B_W-1:k*B_W];
		end 		

		assign config_in_temp[0][0] = config_in_pes;

		for (i = 0; i < PE_H; i = i + 1) begin 
			for (j = 0; j < PE_W; j = j + 1) begin 

				defparam pe_inst.A_W = A_W;
				defparam pe_inst.A_D = A_D;
				defparam pe_inst.B_W = B_W;
				defparam pe_inst.B_D = B_D;
				defparam pe_inst.RES_W = RES_W;
				defparam pe_inst.SHIFTER_TYPE = SHIFTER_TYPE;
				defparam pe_inst.ACC_D = ACC_D;
				pe pe_inst(
					.clk(clk), 
					.reset(reset),

					.hp_en(hp_en),

					.a_in_select(conf_a_in_select),
					.a_in_h(a_in_h_temp[i][j]),
					.a_in_v(a_in_v_temp[i][j]),

					.a_en(a_en),
					.a_mux(conf_a_mux),

					.a_out_h(a_in_h_temp[i][j+1]),
					.a_out_v(a_in_v_temp[i+1][j]),


					.b_in_select(conf_b_in_select),
					.b_in_h(b_in_h_temp[i][j]),
					.b_in_v(b_in_v_temp[i+1][j]),
					
					.b_en(b_en),
					
					.b_out_h(b_in_h_temp[i][j+1]),
					.b_out_v(b_in_v_temp[i][j]),


					.res_in_select(conf_res_in_select),
					.res_in_h(res_in_h_temp[i][j]),
					.res_in_v(res_in_v_temp[i][j]),

					.acc_en(acc_en),
					.acc_depth(conf_acc_depth),

					.res_out_h(res_in_h_temp[i][j+1]),
					.res_out_v(res_in_v_temp[i+1][j]),

					.config_en(config_en),
					.config_in(config_in_temp[i][j]),
					.config_out(config_in_temp[i][j+1])
				);


				if (j == 0) begin 
					if (FLEX_A != "FIXED_V") begin 
						assign a_in_h_temp[i][j] = a[(i+1)*A_W-1:i*A_W];
					end else begin
						assign a_in_h_temp[i][j] = 0;
					end 

					if (FLEX_B != "FIXED_V") begin 
						assign b_in_h_temp[i][j] = b_in_temp[i];
					end else begin
						assign b_in_h_temp[i][j] = 0;
					end 		

					if (FLEX_RES != "FIXED_V") begin 
						assign res_in_h_temp[i][j] = res_cas_in_temp[i];
					end else begin
						assign res_in_h_temp[i][j] = 0;
					end 			
				end 

				if (i == (PE_H-1)) begin 
					//assign b_in_v_temp[i+1][j] = (conf_b_cas_in_select) ? b_cas_in[(j+1)*B_W-1:j*B_W] : b[(j+1)*B_W-1:j*B_W];
					if (FLEX_B != "FIXED_H") begin 
						assign b_in_v_temp[i+1][j] = b_in_temp[j];
					end else begin
						assign b_in_v_temp[i+1][j] = 0;
					end 
				end 

				if (i == 0) begin 
					if (FLEX_A != "FIXED_H") begin 
						assign a_in_v_temp[i][j] = a[(j+1)*A_W-1:j*A_W];
					end else begin
						assign a_in_v_temp[i][j] = 0;
					end 				

					if (FLEX_RES != "FIXED_H") begin 
						assign res_in_v_temp[i][j] = res_cas_in_temp[j];
					end else begin
						assign res_in_v_temp[i][j] = 0;
					end 
				end 

				if (j == (PE_W-1))begin
					if (i == (PE_H-1))begin
						assign config_out = config_in_temp[i][j+1];
					end else begin
						assign config_in_temp[i+1][0] = config_in_temp[i][j+1];
					end 
					
					assign a_out[(i+1)*A_W-1:i*A_W] = a_in_h_temp[i][j+1];
				end 
				
			end 
		end

	endgenerate 

endmodule 
