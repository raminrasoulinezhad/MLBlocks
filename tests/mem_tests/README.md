# Parts:

| name                   | Note      | Vivado        | LUT     | FF      | DSP  | RAMB18 |
| :--------------------- | :-------- | :------------ | ------: | ------: | ---- | -----: |
| xczu28dr-ffvg1517-2-e  | RFSoC     | 2018.2,2019.2 |   425 K |   850 K | 4272 |   2160 |
| xcvu37p-fsvh2892-2-e   | supertile | 2019.2        | 1.303 M | 2.607 M | 9024 |        |

# Experiments:
	
### MLUT memories:

	./runs
	python3 tabulate.py
	cat tabulate.txt

invidicual run can be done by:

	make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=8  type=S  part=xczu28dr-ffvg1517-2-e


# Issues:

## Memory pragmas:

source:  https://www.xilinx.com/support/documentation/sw_manuals/xilinx14_7/xst_v6s6.pdf, page 416

	(*ram_style="{auto|block|distributed|pipe_distributed|block_power1|block_power2}"*)

## MLUTs:

source: https://www.xilinx.com/support/documentation/user_guides/ug474_7Series_CLB.pdf, page 24

### Cost functions:

**Single port**
	cost(addr_w, d_w) = alfa(addr_w) * d_w + beta(addr_w)

	alfa(addr_w) = cost(addr_w, 2) - cost(addr_w, 1)
	beta(addr_w) = cost(addr_w, 1) - alfa(addr_w)

**Dual port**

## URAM:

### Arhitecture:

	single clock, 
	syncronous, 
	each column 16 URAM, 
	4K x 72 (288kb),
	1 URAM = 8 BRAM,
	latency = 1, 2, 3, or 4 (1-3 is more practical)
	data_out reset
	No predefined values at all. it will initialized by zero
	during no / write operation ==> out register remain without any chnage

