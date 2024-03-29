module state_machine(
		clk,
		reset, 
		
		hp_en, 

		a_s,
		b_s,

		b_addr,	
		shifter_mode,
		acc_mode,
		
		config_en,
		config_in,
		config_out
	);
	
	///////// Parameters
	parameter SHIFTER_TYPE = "2Wx2V_by_WxV";
	parameter SHIFTER_MODE_WIDTH = 2;
	localparam SHIFTER_MODE_WIDTH_TEMP = (SHIFTER_MODE_WIDTH == 0)? 1 : SHIFTER_MODE_WIDTH;		

	parameter B_D = 4;
	localparam B_D_LOG2 = $clog2(B_D);

	localparam CNTR_MEM_D = (SHIFTER_TYPE == "BYPASS") ? 1 : 4;

	localparam CNTR_MEM_D_LOG2 = $clog2(CNTR_MEM_D);
	localparam CNTR_MEM_W = 1 + 1 + B_D_LOG2 + SHIFTER_MODE_WIDTH + 1;
	localparam CNTR_MEM_SIZE = CNTR_MEM_W * CNTR_MEM_D;


	///////// IOs
	input clk;
	input reset;

	input hp_en;

	output a_s;
	output b_s;

	output [B_D_LOG2-1 : 0] b_addr;
	output [SHIFTER_MODE_WIDTH_TEMP-1 : 0] shifter_mode; 
	output acc_mode;

	input config_en;
	input config_in;
	output config_out;


	///////// Configurations
	reg [CNTR_MEM_D_LOG2-1 : 0] conf_cntr_counter_limit;
	// a_s, b_s, b_addr_inc, shifter_mode, acc_mode,
	reg [CNTR_MEM_SIZE-1 : 0] conf_cntr_mem;

	reg [B_D_LOG2-1 : 0] conf_b_addr_base_limit;
	reg [B_D_LOG2-1 : 0] conf_b_addr_step;

	integer i, j, k, l;
	always @ (posedge clk) begin
		if (config_en) begin 
						
			conf_cntr_counter_limit[0] <= config_in;
			for (i = 1; i < CNTR_MEM_D_LOG2; i = i + 1)begin
				conf_cntr_counter_limit[i] <= conf_cntr_counter_limit[i-1];
			end 
			
			conf_cntr_mem[0] <= (SHIFTER_TYPE != "BYPASS") ? conf_cntr_counter_limit[CNTR_MEM_D_LOG2-1] : config_in;
			for (j = 1; j < CNTR_MEM_SIZE; j = j + 1) begin
				conf_cntr_mem[j] <= conf_cntr_mem[j-1];
			end 

			conf_b_addr_base_limit[0] <= conf_cntr_mem[CNTR_MEM_SIZE-1];
			for (k = 1; k < B_D_LOG2; k = k + 1)begin
				conf_b_addr_base_limit[k] <= conf_b_addr_base_limit[k-1];
			end 
			
			conf_b_addr_step[0] <= conf_b_addr_base_limit[B_D_LOG2-1];
			for (l = 1; l < B_D_LOG2; l = l + 1)begin
				conf_b_addr_step[l] <= conf_b_addr_step[l-1];
			end 
		end
	end 
	assign config_out = conf_b_addr_step[B_D_LOG2-1];


	///////// internal signals
	wire [B_D_LOG2-1 : 0] b_addr_inc;

	// cntr_counter
	reg [B_D_LOG2-1 : 0] b_addr_base;
	reg [CNTR_MEM_D_LOG2-1 : 0] cntr_counter; 

	always @ (posedge clk) begin
		if (reset) begin
			cntr_counter <= 0;
			b_addr_base <= 0;
		end else if (hp_en) begin
			if (cntr_counter == conf_cntr_counter_limit) begin
				cntr_counter <= 0;
				b_addr_base <= b_addr_base + conf_b_addr_step;
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

			if (SHIFTER_MODE_WIDTH == 0) begin 
				assign {a_s, b_s, b_addr_inc, acc_mode} = conf_cntr_mem_2d[cntr_counter];
				assign shifter_mode = 0;
			end else begin 
				assign {a_s, b_s, b_addr_inc, shifter_mode, acc_mode} = conf_cntr_mem_2d[cntr_counter];
			end 
		end 

		else begin 
			if (SHIFTER_MODE_WIDTH == 0) begin 
				assign {a_s, b_s, b_addr_inc, acc_mode} = conf_cntr_mem;
				assign shifter_mode = 0;
			end else begin 
				assign {a_s, b_s, b_addr_inc, shifter_mode, acc_mode} = conf_cntr_mem;
			end 
		end 
		
	endgenerate

	assign b_addr = b_addr_base + b_addr_inc;

endmodule 
