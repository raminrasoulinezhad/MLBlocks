module MLBlock (
		clk, 
		reset,

		hp_en,

		a, 
		a_out,
		a_en,

		b,
		b_cas_in,
		b_cas_out,
		b_en,

		acc_en,
		res_out,

		res_cas_in,
		res_cas_out,

		config_en,
		config_in,
		config_out

	);
	
	///////// Parameters
	parameter PE_W = 3;
	parameter PE_H = 4;

	localparam PR_CAS = (PE_W > PE_H) ? PE_W : PE_H;

	parameter A_W = 8;
	parameter A_D = 4;
	localparam A_D_HALF = A_D / 2;
	
	parameter B_W = 8;
	parameter B_D = 4;

	parameter RES_W = 32;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";	// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx" 
	// "BYPASS"				: 8x8 						: MODE_WIDTH = 0
	// "2Wx2V_by_WxV"		: 8x8, 8x16, 8x24, 16x16	: MODE_WIDTH = 2
	// "2Wx2V_by_WxV_apx" 	: 8x8, 8x16, 16x16(apx)		: MODE_WIDTH = 2

	parameter ACC_D = 1;
	localparam ACC_D_CNTL = (ACC_D > 1)? (ACC_D-1): 1;

	///////// IOs
	input clk;
	input reset;

	input hp_en;

	input [PE_H*A_W-1:0] a;
	output [PE_H*A_W-1:0] a_out;
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

	///////// Configurations
	reg [A_D_HALF-1:0] conf_a_mux;
	reg conf_res_in_select;
	reg conf_res_cas_in_zero;
	reg conf_res_cas_h_v;
	reg conf_b_cas;
	reg [ACC_D_CNTL-1:0] conf_acc_depth;

	integer l, m;
	always @ (posedge clk) begin
		if (config_en) begin 
			conf_a_mux[0] <= config_in;
			for (l = 1; l < A_D_HALF; l = l + 1)begin
				conf_a_mux[l] <= conf_a_mux[l-1];
			end 
			conf_res_in_select <= conf_a_mux[A_D_HALF-1];
			conf_res_cas_in_zero <= conf_res_in_select;
			conf_res_cas_h_v <= conf_res_cas_in_zero;
			conf_b_cas <= conf_res_cas_h_v;
			conf_acc_depth[0] <= conf_b_cas;
			for (m = 1; m < ACC_D_CNTL; m = m + 1)begin
				conf_acc_depth[m] <= conf_acc_depth[m-1];
			end 
		end
	end 
	wire config_in_pes;
	assign config_in_pes = (ACC_D > 1) ? conf_acc_depth[ACC_D_CNTL-1] : conf_b_cas;

	///////// internal signals
	wire [RES_W-1:0] res_cas_in_temp [PR_CAS-1:0];

	wire [A_W-1:0] a_temp [PE_H-1:0][PE_W:0];

	wire [B_W-1:0] b_temp [PE_H:0][PE_W-1:0];

	wire [RES_W-1:0] res_in_h_temp [PE_H-1:0][PE_W:0];
	wire [RES_W-1:0] res_in_v_temp [PE_H:0][PE_W-1:0];

	wire [0:0] config_in_temp [PE_H-1:0][PE_W:0];

	genvar i,j,k;
	generate 
		
		for (k = 0; k < PR_CAS; k = k + 1) begin 
			
			assign res_cas_in_temp[k] = (conf_res_cas_in_zero) ? 0 : res_cas_in[(k+1)*RES_W-1:k*RES_W];

			if (k > (PE_H-1)) begin 
				assign res_cas_out[(k+1)*RES_W-1:k*RES_W] = res_in_v_temp[PE_H][k]; 
			end else if (k > (PE_W-1)) begin 
				assign res_cas_out[(k+1)*RES_W-1:k*RES_W] = res_in_h_temp[k][PE_W]; 
			end else begin 
				assign res_cas_out[(k+1)*RES_W-1:k*RES_W] = (conf_res_cas_h_v) ? res_in_v_temp[PE_H][k]: res_in_h_temp[k][PE_W]; 
			end 
			
			assign res_out[(k+1)*RES_W-1:k*RES_W] = res_cas_out[(k+1)*RES_W-1:k*RES_W];
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

					.a(a_temp[i][j]),
					.a_en(a_en),
					.a_mux(conf_a_mux),
					.a_out(a_temp[i][j+1]),

					.b(b_temp[i+1][j]),
					.b_en(b_en),
					.b_out(b_temp[i][j]),

					.acc_en(acc_en),
					.acc_depth(conf_acc_depth),

					.res_in_select(conf_res_in_select),
					.res_in_h(res_in_h_temp[i][j]),
					.res_in_v(res_in_v_temp[i][j]),

					.res_out_h(res_in_h_temp[i][j+1]),
					.res_out_v(res_in_v_temp[i+1][j]),

					.config_en(config_en),
					.config_in(config_in_temp[i][j]),
					.config_out(config_in_temp[i][j+1])
				);


				if (j == 0) begin 
					assign a_temp[i][j] = a[(i+1)*A_W-1:i*A_W];
					assign res_in_h_temp[i][j] = res_cas_in_temp[i];
				end 

				if (i == (PE_H-1)) begin 
					assign b_temp[i+1][j] = (conf_b_cas) ? b_cas_in[(j+1)*B_W-1:j*B_W] : b[(j+1)*B_W-1:j*B_W];
				end 

				if (i == 0) begin 
					assign res_in_v_temp[i][j] = res_cas_in_temp[j];
					assign b_cas_out[(j+1)*B_W-1:j*B_W] = b_temp[i][j];
				end 

				if (j == (PE_W-1))begin
					if (i == (PE_H-1))begin
						assign config_out = config_in_temp[i][j+1];
					end else begin
						assign config_in_temp[i+1][0] = config_in_temp[i][j+1];
					end 
					
					assign a_out[(i+1)*A_W-1:i*A_W] = a_temp[i][j+1];
				end 
				
			end 
		end

	endgenerate 

endmodule 
