module out_unit(
		in,

		addr,

		out
	);
	
	parameter WIDTH = 8;
	parameter N_OUT = 4;

	input [WIDTH-1:0] in;
	input [N_OUT-1:0] addr;
	output reg [WIDTH-1:0] out [N_OUT-1:0];

	integer i;
	always @ (*) begin
		for (i = 0; i < N_OUT; i = i + 1) begin 
			if (addr[i] == 1'b1) begin 
				out[i] = in;
			end else begin
				out[i] = {WIDTH{1'bz}};
			end 
		end 
	end 

endmodule 
