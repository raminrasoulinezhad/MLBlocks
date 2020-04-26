module MLBlobk (
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
	parameter PE_H = 4;

	parameter PR_CAS = (PE_W > PE_H) ? PE_W : PE_H;

	parameter A_W = 8;
	
	parameter B_W = 8;
	parameter B_D = 4;

	parameter RES_W = 32;

	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";	// "2Wx2V_by_WxV", "BYPASS"

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

	///////// Configurations
	reg conf_res_cas_in_zero;
	reg conf_res_cas_h_v;
	reg conf_b_cas;

	always @ (posedge clk) begin
		if (config_en) begin 
			conf_res_cas_in_zero <= config_in;
			conf_res_cas_h_v <= conf_res_cas_in_zero;
			conf_b_cas <= conf_res_cas_h_v;
		end
	end 
	wire config_in_pes;
	assign config_in_pes = conf_b_cas;

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
				defparam pe_inst.B_W = B_W;
				defparam pe_inst.B_D = B_D;
				defparam pe_inst.RES_W = RES_W;
				defparam pe_inst.SHIFTER_TYPE = SHIFTER_TYPE;
				pe pe_inst(
					.clk(clk), 
					.reset(reset),

					.hp_en(hp_en),

					.a(a_temp[i][j]),
					.a_en(a_en),
					.a_out(a_temp[i][j+1]),

					.b(b_temp[i+1][j]),
					.b_en(b_en),
					.b_out(b_temp[i][j]),

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
				end 
				
			end 
		end

	endgenerate 

endmodule 
