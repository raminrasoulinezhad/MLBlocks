.PHONY: clear pir dotproduct arch12

all: clean pir dotproduct arch12

# ASIC 
#### yosys quant.ys
# FPGA
#### yosys -s synth_xilinx.ys ../quantizers/quant.v | tee quant.log

pir: 
	yosys pir.ys | tee pir.log

dotproduct: 
	yosys dotproduct.ys | tee dotproduct.log

arch12:
	yosys arch12.ys | tee arch12.log

# Clean
clean: 
	rm -rf *.edif
	rm -rf *.log
	rm -rf *.stat

