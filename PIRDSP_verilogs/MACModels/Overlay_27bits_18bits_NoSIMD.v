`timescale 1 ns / 100 ps 
module Overlay_27bits_18bits_NoSIMD(
		input clk,
		input reset,
				
		input [26:0] a,
		input [17:0] b,
		
		input [47:0] result_2,
		input CIN,
		
		output reg [47:0] S_reg,
		
		output reg COUT_reg
);

wire [44:0] result_0;
wire [44:0] result_1;

reg [47:0] result_0_reg;
reg [47:0] result_1_reg;

wire [47:0] S;
wire COUT;

ALU_T_27bits_18bits_NoSIMD 	ALU_T_27bits_18bits_NoSIMD_inst(
		
		.W(result_0_reg),
		.Y(result_1_reg),
		.X(result_2),

		.CIN(CIN),
		
		.S(S),
		
		.COUT(COUT)
);

	
	Multiplier_xilinx Multiplier_xilinx_inst (
		.a(a),
		.b(b),

		.result1(result_0),
		.result2(result_1)
 	); 


always @ (posedge clk)begin
	if(reset)begin
		result_0_reg <= 0;
		result_1_reg <= 0;
		S_reg <= 0;
		COUT_reg <= 0;
	end
	else begin
		result_0_reg <= {{3'b000},{result_0}};
		result_1_reg <= {{3{result_1[44]}},{result_1}};;
		S_reg <= S;
		COUT_reg <= COUT;
	end
end

endmodule
