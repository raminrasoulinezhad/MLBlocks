module stream_mem (
		clk, 
		reset,

		in,
		en, 

		addr,
		out,
		
		cascade
	);

	///////// Parameters
	parameter WIDTH = 8;
	parameter DEPTH = 4;

	localparam DEPTH_LOG2 = $clog2(DEPTH);

	///////// IOs
	input clk;
	input reset;

	input [WIDTH-1:0] in;
	input en;

	output [WIDTH-1:0] out;
	input [DEPTH_LOG2-1:0] addr;

	output [WIDTH-1:0] cascade;

	///////// internal signals
	reg [WIDTH-1:0] mem [DEPTH-1:0];
	
	integer i;
	always @ (posedge clk) begin
		if (reset) begin
			for (i = 0; i < DEPTH; i = i + 1) begin
				mem[i] <= 0;
			end 
		end else if (en) begin
			mem[0] <= in;
			for (i = 1; i < DEPTH; i = i + 1) begin
				mem[i] <= mem[i-1];
			end 
		end
	end

	assign cascade = mem[DEPTH-1];

	assign out = mem[addr];

endmodule 
