module AND_NOR_21(
		input a,
		input b,
		input c,
		
		output out
	);
	
	wire temp_and;
	and and_inst (temp_and,a,b);
	nor (out, c, temp_and);
	
endmodule
