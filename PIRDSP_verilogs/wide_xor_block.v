/*****************************************************************
*	Configuration bits order :
*			XORSIMD <= configuration_input;
*			onfiguration_output = XORSIMD;
*****************************************************************/
`timescale 1 ns / 100 ps  
module wide_xor_block (
		input clk,
	
		input [47:0] S,
		output [7:0] XOROUT,
		
		input configuration_input,
		input configuration_enable,
		output configuration_output
	);
	
	// parameter 
	parameter input_freezed = 1'b0;
	
	reg [47:0] S_temp;
	always @ (*) begin
		if (input_freezed)begin
			S_temp = 48'b0;
		end
		else begin
			S_temp = S;
		end
	end
	
	
	// configuring bits
	reg XORSIMD;
		
	always@(posedge clk)begin
		if (configuration_enable)begin
			XORSIMD <= configuration_input;
		end
	end
	assign configuration_output = XORSIMD;
	
	
	// wide_xor_block
	wire XOR12A;
	wire XOR12B;
	wire XOR12C;
	wire XOR12D;
	wire XOR12E;
	wire XOR12F;
	wire XOR12G;
	wire XOR12H;
	
	wire XOR24A;
	wire XOR24B;
	wire XOR24C;
	wire XOR24D;
	
	wire XOR48A;
	wire XOR48B;
	
	wire XOR96;
	
	
	assign XOR12A = ^S_temp[5:0];
	assign XOR12B = ^S_temp[11:6];
	assign XOR12C = ^S_temp[17:12];
	assign XOR12D = ^S_temp[23:18];
	assign XOR12E = ^S_temp[29:24];
	assign XOR12F = ^S_temp[35:30];
	assign XOR12G = ^S_temp[41:36];
	assign XOR12H = ^S_temp[47:42];
	
	
	assign XOR24A = XOR12A ^ XOR12B;
	assign XOR24B = XOR12C ^ XOR12D;
	assign XOR24C = XOR12E ^ XOR12F;
	assign XOR24D = XOR12G ^ XOR12H;
	
	assign XOR48A = XOR24A ^ XOR24B;
	assign XOR48B = XOR24C ^ XOR24D;
	
	assign XOR96 = XOR48A ^ XOR48B;
	
	assign XOROUT[0] = (XORSIMD)	? XOR24A	: XOR12A;
	assign XOROUT[1] = (XORSIMD)	? XOR48A	: XOR12B;
	assign XOROUT[2] = (XORSIMD)	? XOR24B	: XOR12C;
	assign XOROUT[3] = (XORSIMD)	? XOR96  	: XOR12D;
	assign XOROUT[4] = (XORSIMD)	? XOR24C	: XOR12E;
	assign XOROUT[5] = (XORSIMD)	? XOR48B	: XOR12F;
	assign XOROUT[6] = (XORSIMD)	? XOR24D	: XOR12G;
	assign XOROUT[7] = XOR12H;
endmodule
