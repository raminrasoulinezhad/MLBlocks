module RF_2R1W_8_30bit (
		clk, 
	
		read_addr_0,
		read_addr_1,

		write_data,
		write_enable,
		
		read_data_0,
		read_data_1
	);
	
	/////////////////////////////////////
	parameter RF_width = 30;
	parameter RF_size = 8;
	parameter RF_addr_size = $clog2(RF_size);
	
	/////////////////////////////////////
	input clk;

	input [RF_addr_size-1:0] read_addr_0;
	input [RF_addr_size-1:0] read_addr_1;
	
	input [RF_width-1:0] write_data;
	input write_enable;
	
	output reg [RF_width-1:0] read_data_0;
	output reg [RF_width-1:0] read_data_1;

	/////////////////////////////////////
	integer i;
	
	
	/////////////////////////////////////
	reg [RF_width-1:0] RF [RF_size-1:0];
	
	always @ (posedge clk) begin
		if (write_enable) begin
			RF[0] <= write_data;
			for (i = 1; i < RF_size; i = i + 1) begin
				RF[i] <= RF[i-1];
			end
		end
	end
	
	always @ (*) begin
		read_data_0 = RF[read_addr_0];
		read_data_1 = RF[read_addr_1];
	end
	
endmodule
