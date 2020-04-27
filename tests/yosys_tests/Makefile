.PHONY: clear pir dotproduct

all: clean pir dotproduct

# ASIC 
#### yosys quant.ys
# FPGA
#### yosys -s synth_xilinx.ys ../quantizers/quant.v | tee quant.log

pir: 
	yosys pir.ys | tee pir.log

dotproduct: 
	yosys dotproduct.ys | tee dotproduct.log

# Clean
clean: 
	rm -rf *.edif
	rm -rf *.log
	rm -rf *.stat

