module shifter (
		in,
		in_s,

		mode,

		out
	);
	
	///////// Parameters
	parameter A_W = 8;
	parameter B_W = 8;
	
	parameter OUT_WIDTH = 32;

	parameter MODE_WIDTH = 2;

	parameter TYPE = "2Wx2V_by_WxV";	// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx" 
	// "BYPASS"				: 8x8 						: MODE_WIDTH = 0
	// "2Wx2V_by_WxV"		: 8x8, 8x16, 8x24, 16x16	: MODE_WIDTH = 2
	// "2Wx2V_by_WxV_apx" 	: 8x8, 8x16, 16x16(apx)		: MODE_WIDTH = 2

	localparam IN_WIDTH = A_W + B_W;
	localparam MIN_W = (A_W > B_W) ? B_W : A_W; 
	localparam MAX_W = (A_W < B_W) ? B_W : A_W; 

	// local parameter  for "BYPASS"
	localparam TYPE_BYPASS_EX = OUT_WIDTH - IN_WIDTH;

	// local parameter  for "2Wx2V_by_WxV"
	localparam TYPE_2WX2V_BY_WXV_MODE_00_EX = OUT_WIDTH - IN_WIDTH;
	localparam TYPE_2WX2V_BY_WXV_MODE_01_EX = OUT_WIDTH - IN_WIDTH - A_W; 
	localparam TYPE_2WX2V_BY_WXV_MODE_10_EX = OUT_WIDTH - IN_WIDTH - B_W; 
	localparam TYPE_2WX2V_BY_WXV_MODE_11_EX = OUT_WIDTH - IN_WIDTH - A_W - B_W; 

	localparam TYPE_2WX2V_BY_WXV_MODE_00_PAD = 0;
	localparam TYPE_2WX2V_BY_WXV_MODE_01_PAD = A_W; 
	localparam TYPE_2WX2V_BY_WXV_MODE_10_PAD = B_W; 
	localparam TYPE_2WX2V_BY_WXV_MODE_11_PAD = A_W + B_W; 

	// local parameter  for "2Wx2V_by_WxV_apx"
	localparam TYPE_2WX2V_BY_WXV_APX_MODE_00_EX = OUT_WIDTH - IN_WIDTH;
	localparam TYPE_2WX2V_BY_WXV_APX_MODE_01_EX = OUT_WIDTH - IN_WIDTH - A_W + MIN_W; 
	localparam TYPE_2WX2V_BY_WXV_APX_MODE_10_EX = OUT_WIDTH - IN_WIDTH - B_W + MIN_W; 
	localparam TYPE_2WX2V_BY_WXV_APX_MODE_11_EX = OUT_WIDTH - IN_WIDTH - A_W - B_W + MIN_W; 

	localparam TYPE_2WX2V_BY_WXV_APX_MODE_00_PAD = 0;
	localparam TYPE_2WX2V_BY_WXV_APX_MODE_01_PAD = A_W - MIN_W; 
	localparam TYPE_2WX2V_BY_WXV_APX_MODE_10_PAD = B_W - MIN_W; 
	localparam TYPE_2WX2V_BY_WXV_APX_MODE_11_PAD = A_W + B_W - MIN_W; 

	///////// IOs
	input [IN_WIDTH-1:0] in;
	input in_s;

	input [MODE_WIDTH-1:0] mode;

	output reg [OUT_WIDTH-1:0] out;
	
	///////// internal signals

	genvar i_gen;
	generate 
		if (TYPE == "2Wx2V_by_WxV") begin
			always @(*) begin
				if (mode == 2'b00) begin 
					out = {{TYPE_2WX2V_BY_WXV_MODE_00_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_MODE_00_PAD{1'b0}}};
					//out = {{TYPE_2WX2V_BY_WXV_MODE_00_EX{in_s & in[IN_WIDTH-1]}},{in}};
				end else if (mode == 2'b01) begin
					out = {{TYPE_2WX2V_BY_WXV_MODE_01_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_MODE_01_PAD{1'b0}}};
				end else if (mode == 2'b10) begin
					out = {{TYPE_2WX2V_BY_WXV_MODE_10_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_MODE_10_PAD{1'b0}}};
				end else begin
					out = {{TYPE_2WX2V_BY_WXV_MODE_11_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_MODE_11_PAD{1'b0}}};
				end 
			end
		end 

		else if (TYPE == "2Wx2V_by_WxV_apx") begin
			always @(*) begin
				if (mode == 2'b00) begin 
					out = {{TYPE_2WX2V_BY_WXV_APX_MODE_00_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_APX_MODE_00_PAD{1'b0}}};
				end else if (mode == 2'b01) begin
					out = {{TYPE_2WX2V_BY_WXV_APX_MODE_01_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_APX_MODE_01_PAD{1'b0}}};
				end else if (mode == 2'b10) begin
					out = {{TYPE_2WX2V_BY_WXV_APX_MODE_10_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_APX_MODE_10_PAD{1'b0}}};
				end else begin
					out = {{TYPE_2WX2V_BY_WXV_APX_MODE_11_EX{in_s & in[IN_WIDTH-1]}},{in},{TYPE_2WX2V_BY_WXV_APX_MODE_11_PAD{1'b0}}};
				end 
			end
		end 
		
		else if (TYPE == "BYPASS") begin
			always @(*) begin
				out = {{TYPE_BYPASS_EX{in_s & in[IN_WIDTH-1]}},{in}};
			end
		end

	endgenerate

endmodule 
