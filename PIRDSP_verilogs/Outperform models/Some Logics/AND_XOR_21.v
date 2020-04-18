module AND_XOR_21(
		input a,
		input b,
		input c,
		
		output out
	);
	
	wire temp_and;
	and and_inst (temp_and,a,b);
	xor (out, c, temp_and);
	
endmodule