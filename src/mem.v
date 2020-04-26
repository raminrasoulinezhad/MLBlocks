// RAM_TYPE = "S", "D", "Q", "SD", "RD"
//	S: single port(a port for both read and write)
//	D: dual port(a port for both read and write + a port for read )
//	Q: quad port(a port for both read and write + three ports for read )
//	SD: simple dual port (a port for write + a port for read)
//	RD: real dual port (two ports for read and write)

(*ram_style="distributed"*)
module ram_mlut #(DATA_WIDTH=16, ADDR_WIDTH=8, RAM_TYPE="S", MEM_INIT="zero.mem") (
		input clk,
		input rst,
		// port A 
		input [DATA_WIDTH-1: 0] din_a,
		output [DATA_WIDTH-1: 0] dout_a,
		input [ADDR_WIDTH-1: 0] addr_a,
		input wen_a,
		// port B 
		input [DATA_WIDTH-1: 0] din_b,
		output [DATA_WIDTH-1: 0] dout_b,
		input [ADDR_WIDTH-1: 0] addr_b,
		input wen_b,
		// port C 
		output [DATA_WIDTH-1: 0] dout_c,
		input [ADDR_WIDTH-1: 0] addr_c,
		// port D
		output [DATA_WIDTH-1: 0] dout_d,
		input [ADDR_WIDTH-1: 0] addr_d
	);

	localparam RAM_DEPTH = (1<<ADDR_WIDTH);

	// internal variables
	reg [DATA_WIDTH-1:0] ram [0:RAM_DEPTH-1];
	
	// simulation only
	integer i;
	initial begin
		if (MEM_INIT == "ZERO") begin 
			$readmemh(MEM_INIT, ram);
		end else begin 
			for (i = 0; i < RAM_DEPTH; i = i + 1) begin
				ram[i] = 0;
			end
		end 
	end

	// port A: write
	always @(posedge clk) begin : portA
		if (wen_a) begin
			ram[addr_a] <= din_a;
		end
	end

	// port B: write
	always @(posedge clk) begin : portB
		if ((wen_b) && (RAM_TYPE == "RD")) begin
			ram[addr_b] <= din_b;
		end
	end
	
	// read ports 
	assign dout_a = (RAM_TYPE != "SD")? ram[addr_a] : 0;
	assign dout_b = (RAM_TYPE != "S") ? ram[addr_b] : 0;
	assign dout_c = (RAM_TYPE == "Q") ? ram[addr_c] : 0;
	assign dout_d = (RAM_TYPE == "Q") ? ram[addr_d] : 0;

endmodule


(*ram_style="ultra"*)
module ram_uram #(DATA_WIDTH=72, ADDR_WIDTH=12) (
		input clk,
		// port A 
		input en_a,
		input read_write_a,
		input [DATA_WIDTH-1: 0] din_a,
		output reg [DATA_WIDTH-1: 0] dout_a,
		input dout_a_rst,
		input [ADDR_WIDTH-1: 0] addr_a,
		input wen_a//,
		// port B
		//input en_b,
		//output reg [DATA_WIDTH-1: 0] dout_b,
		//input dout_b_rst,
		//input [ADDR_WIDTH-1: 0] addr_b
	);

	localparam RAM_DEPTH = (1<<ADDR_WIDTH);

	// internal variables
	reg [DATA_WIDTH-1:0] ram [0:RAM_DEPTH-1];

	// port A: write
	always @(posedge clk) begin : PortA
		if (dout_a_rst == 1'b1) begin
			dout_a <= 0;
		end else if (en_a == 1'b1) begin
			if (read_write_a == 1'b0) begin
				// read
				dout_a <= ram[addr_a];
			end else begin 
				// write
				if (wen_a) begin
					ram[addr_a] <= din_a;
				end
			end 
		end 
	end

	//always @(posedge clk) begin : PortB
	//	if (dout_b_rst == 1'b1) begin
	//		dout_b <= 0;
	//	end else if (en_b == 1'b1) begin
	//		dout_b <= ram[addr_b];
	//	end 
	//end

endmodule

(*ram_style="block"*)
module ram_bram #(DATA_WIDTH=18, ADDR_WIDTH=10, RAM_TYPE="DP") (
		input clk,
		input rst,
		// port A 
		input read_write_a,
		input [DATA_WIDTH-1: 0] din_a,
		output reg [DATA_WIDTH-1: 0] dout_a,
		input dout_a_rst,
		input [ADDR_WIDTH-1: 0] addr_a,
		input wen_a,
		// port B 
		input read_write_b,
		input [DATA_WIDTH-1: 0] din_b,
		output reg [DATA_WIDTH-1: 0] dout_b,
		input dout_b_rst,
		input [ADDR_WIDTH-1: 0] addr_b,
		input wen_b
	);

	localparam RAM_DEPTH = (1<<ADDR_WIDTH);

	// internal variables
	reg [DATA_WIDTH-1:0] ram [0:RAM_DEPTH-1];

	// port A: write
	always @(posedge clk) begin : portA
		if ((dout_a_rst == 1'b1)&&(RAM_TYPE!="SDP")) begin
			dout_a <= 0;
		end else begin
			if ((read_write_a == 1'b0)&&(RAM_TYPE!="SDP")) begin
				// read
				dout_a <= ram[addr_a];
			end else begin 
				// write
				if (wen_a) begin
					ram[addr_a] <= din_a;
				end
			end 
			
		end 
	end

	// port B: write
	always @(posedge clk) begin : portB
		if (dout_b_rst == 1'b1) begin
			dout_b <= 0;
		end else begin
			if ((read_write_b == 1'b0)||(RAM_TYPE=="SDP")) begin
				// read
				dout_b <= ram[addr_b];
			end else begin 
				// write
				if (wen_b) begin
					ram[addr_b] <= din_b;
				end
			end 
			
		end 
	end

endmodule



module bram_sdp_FIFO #(DATA_WIDTH=36) (
		input clk,
		input rst,

		input [DATA_WIDTH-1: 0] din,
		input din_en,

		output [DATA_WIDTH-1: 0] dout,
		input dout_en
	);

	
	localparam TOTAL_SIZE = 512;
	localparam COUNTER_SIZE = $clog2(TOTAL_SIZE);
	localparam ADDR_WIDTH = COUNTER_SIZE;


	reg [COUNTER_SIZE-1:0] counter_s;
	
	always @(posedge clk) begin
		if (rst == 1'b1)begin
			counter_s <= 0;
		end else if (din_en == 1'b1) begin
			counter_s <= counter_s + 1;
		end
	end 

	reg [COUNTER_SIZE-1:0] counter_e;

	always @(posedge clk) begin
		if (rst == 1'b1)begin
			counter_e <= 0;
		end else if (din_en == 1'b1) begin
			counter_e <= counter_e + 1;
		end
	end 


	ram_bram #(DATA_WIDTH, ADDR_WIDTH, "SDP") ram_bram_inst (
		.clk(clk),
		.rst(rst),
		// port A 
		.read_write_a(1'b1),
		.din_a(din),
		.dout_a(),
		.dout_a_rst(),
		.addr_a(counter_s),
		.wen_a(din_en),
		// port B 
		.read_write_b(1'b0),
		.din_b(),
		.dout_b(dout),
		.dout_b_rst(rst),
		.addr_b(counter_e),
		.wen_b(1'b0)
	);


endmodule 




module bram_sdp_FIFO_three_cascaded #(DATA_WIDTH=36) (
		input clk,
		input rst,

		input [DATA_WIDTH-1: 0] din,
		input din_en_0,
		input din_en_1,
		input din_en_2,

		output [DATA_WIDTH-1: 0] dout,
		input dout_en_0,
		input dout_en_1,
		input dout_en_2
	);
	
	wire temp_0_to_1;
	wire temp_1_to_2;

	bram_sdp_FIFO #(DATA_WIDTH) bram_sdp_FIFO_inst_0 (
		.clk(clk),
		.rst(rst),

		.din(din),
		.din_en(din_en_0),

		.dout(temp_0_to_1),
		.dout_en(dout_en_0)
	);

	bram_sdp_FIFO #(DATA_WIDTH) bram_sdp_FIFO_inst_1 (
		.clk(clk),
		.rst(rst),

		.din(temp_0_to_1),
		.din_en(din_en_1),

		.dout(temp_1_to_2),
		.dout_en(dout_en_1)
	);

	bram_sdp_FIFO #(DATA_WIDTH) bram_sdp_FIFO_inst_2 (
		.clk(clk),
		.rst(rst),

		.din(temp_1_to_2),
		.din_en(din_en_2),

		.dout(dout),
		.dout_en(dout_en_2)
	);

endmodule 