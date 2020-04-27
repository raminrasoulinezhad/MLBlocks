create_clock -period 3.000 -name clk -waveform {0.000 1.500} [get_ports clk]

create_pblock pblock_selected
add_cells_to_pblock [get_pblocks pblock_selected] [get_cells -quiet [list bram_sdp_FIFO_inst_0 bram_sdp_FIFO_inst_1 bram_sdp_FIFO_inst_2]]
resize_pblock [get_pblocks pblock_selected] -add {SLICE_X83Y335:SLICE_X89Y344}
resize_pblock [get_pblocks pblock_selected] -add {DSP48E2_X15Y134:DSP48E2_X16Y137}
resize_pblock [get_pblocks pblock_selected] -add {RAMB18_X8Y134:RAMB18_X8Y137}
resize_pblock [get_pblocks pblock_selected] -add {RAMB36_X8Y67:RAMB36_X8Y68}
