module state_machine_v2 (
		clk,
		reset, 

		a_mux,
		res_in_select,
		
		hp_en, 

		a_s,
		b_s,

		b_addr_inc,	
		shifter_mode,
		acc_mode,
		
		config_en,
		config_in,
		config_out
	);
	
	///////// Parameters
	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";	// "2Wx2V_by_WxV", "BYPASS"
	parameter SHIFTER_MODE_WIDTH = 2;		

	parameter B_D = 4;
	localparam B_D_LOG2 = $clog2(B_D);

	parameter CNTR_MEM_D = 4;
	localparam CNTR_MEM_D_LOG2 = $clog2(CNTR_MEM_D);
	localparam CNTR_MEM_W = 1 + 1 + B_D_LOG2 + SHIFTER_MODE_WIDTH + 1;
	localparam CNTR_MEM_SIZE = CNTR_MEM_W * CNTR_MEM_D;


	///////// IOs
	input clk;
	input reset;

	output a_mux;
	output res_in_select;

	input hp_en;

	output a_s;
	output b_s;

	output [B_D_LOG2-1 : 0] b_addr_inc;
	output [SHIFTER_MODE_WIDTH-1 : 0] shifter_mode; 
	output acc_mode;

	input config_en;
	input config_in;
	output config_out;


	///////// Configurations
	reg conf_a_mux;
	reg conf_res_in_select;
	reg [CNTR_MEM_D_LOG2-1 : 0] conf_cntr_counter_limit;
	// a_s, b_s, b_addr_inc, shifter_mode, acc_mode,
	reg [CNTR_MEM_SIZE-1 : 0] conf_cntr_mem;

	integer i, j;
	always @ (posedge clk) begin
		if (config_en) begin 
			
			conf_a_mux <= config_in;
			conf_res_in_select <= conf_a_mux;
			
			conf_cntr_counter_limit[0] <= conf_res_in_select;
			for (i = 1; i < CNTR_MEM_D_LOG2; i = i + 1)begin
				conf_cntr_counter_limit[i] <= conf_cntr_counter_limit[i-1];
			end 
			
			conf_cntr_mem[0] <= (SHIFTER_TYPE != "BYPASS") ? conf_cntr_counter_limit[CNTR_MEM_D_LOG2-1] : conf_res_in_select;
			for (j = 1; j < CNTR_MEM_SIZE; j = j + 1) begin
				conf_cntr_mem[j] <= conf_cntr_mem[j-1];
			end 
			
		end
	end 
	assign config_out = conf_cntr_mem[CNTR_MEM_SIZE-1];


	///////// internal signals
	
	// a_mux, res_in_select
	assign a_mux = conf_a_mux;
	assign res_in_select = conf_res_in_select;

	// cntr_counter
	reg [CNTR_MEM_D_LOG2-1 : 0] cntr_counter; 

	always @ (posedge clk) begin
		if (reset) begin
			cntr_counter <= 0;
		end else if (hp_en) begin
			if (cntr_counter == conf_cntr_counter_limit) begin
				cntr_counter <= 0;
			end else begin
				cntr_counter <= cntr_counter + 1;
			end 
		end 
	end 
	
	genvar i_gen;
	generate 
		if (SHIFTER_TYPE != "BYPASS") begin 
			wire [CNTR_MEM_W-1 : 0] conf_cntr_mem_2d [CNTR_MEM_D-1 : 0];
			for (i_gen = 0; i_gen < CNTR_MEM_D; i_gen = i_gen + 1)begin 
				assign conf_cntr_mem_2d[i_gen] = conf_cntr_mem[CNTR_MEM_W*(i_gen+1)-1 : CNTR_MEM_W*i_gen];
			end 

			assign {a_s, b_s, b_addr_inc, shifter_mode, acc_mode} = conf_cntr_mem_2d[cntr_counter];
		end 

		else begin 
			assign {a_s, b_s, b_addr_inc, shifter_mode, acc_mode} = conf_cntr_mem;
		end 
	endgenerate

endmodule 
