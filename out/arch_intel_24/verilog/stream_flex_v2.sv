module stream_flex_v2 (
		clk, 
		reset,

		in,
		en,

		out,

		depth,
		// depth: indicate the index of the last register in the stream
		speed,
		// data stream speed (stride of strem)
		cascade
	);

	///////// Parameters
	parameter WIDTH = 8;

	parameter DEPTH = 2;
	localparam DEPTH_LOG2 = $clog2(DEPTH);

	parameter SPEED = 1;
	localparam SPEED_LOG2 = (SPEED == 1) ? 1 : $clog2(SPEED);

	///////// IOs
	input clk;
	input reset;

	input [WIDTH-1:0] in [SPEED-1:0];
	input en;

	output [WIDTH-1:0] out;

	input [DEPTH_LOG2-1:0] depth;
	input [SPEED_LOG2-1:0] speed;

	output reg [WIDTH-1:0] cascade [SPEED-1:0];

	///////// internal signals
	reg [WIDTH-1:0] a_reg [DEPTH-1:0];
	reg [WIDTH-1:0] a_temp [DEPTH-1:0][SPEED-1:0];

	integer i, j;
	always @ (posedge clk)begin
		if (reset) begin 
			for (i = 0; i < DEPTH; i = i + 1) begin 
				a_reg[i] <= 0;
			end 
		end else if (en) begin
			if (SPEED == 1) begin 
				a_reg [0] <= in[0];
				for (j = 1; j < DEPTH; j = j + 1) begin 
					a_reg [j] <= a_reg[j-1];
				end 
			end else begin 
				for (j = 0; j < DEPTH; j = j + 1) begin 
					a_reg [j] <= a_temp[j][speed];
				end
			end 
		end 
	end

	integer k, m;
	always @ (*) begin 
		for (k = 0; k < DEPTH; k = k + 1) begin 
			for (m = 0; m < SPEED; m = m + 1) begin 
				if (k-m-1 < 0) begin 
					a_temp[k][m] = in[m-k];
				end else begin 
					a_temp[k][m] = a_reg[k-m-1];
				end 				
			end
		end 
	end 

	// multiplier input by I stream
	assign out = a_reg[0];

	// Cascade 	
	integer l;
	always @ (*) begin 
		for (k = 0; k < SPEED; k = k + 1) begin 
			cascade[k] = a_reg[depth-k];
		end 
	end

endmodule 
