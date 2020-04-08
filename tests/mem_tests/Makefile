mem:
	rm -rf $(p_dir)
	vivado -mode batch -source mem.tcl -tclargs $(p_dir) $(top) $(d_w) $(addr_w) $(type) zero.mem $(part)
	rm -rf vivado*

clean:
	rm -rf vivado*
	rm -rf project*
	rm -rf nohup.out
