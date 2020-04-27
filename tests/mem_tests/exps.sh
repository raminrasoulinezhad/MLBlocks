make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=5   type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=6   type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=7   type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=8   type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=9   type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=10  type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=11  type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=12  type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=13  type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=14  type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=15  type=S  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/ram_s_256x16  top=ram_mlut  d_w=16  addr_w=16  type=S  part=xczu28dr-ffvg1517-2-e task=synth




make  mem  p_dir=./workspace/bram_DP_18_10  		top=ram_bram  d_w=18  addr_w=10  type=DP  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/bram_DP_18_10_imps  	top=ram_bram  d_w=18  addr_w=10  type=DP  part=xczu28dr-ffvg1517-2-e task=impl

make  mem  p_dir=./workspace/bram_SDP_36_8  		top=ram_bram  d_w=36  addr_w=8  type=SDP  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/bram_SDP_36_8_imps  	top=ram_bram  d_w=36  addr_w=8  type=SDP  part=xczu28dr-ffvg1517-2-e task=impl
make  mem  p_dir=./workspace/bram_SDP_36_9  		top=ram_bram  d_w=36  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/bram_SDP_36_9_imps  	top=ram_bram  d_w=36  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=impl

make  mem  p_dir=./workspace/bram_sdp_FIFO_18  		top=bram_sdp_FIFO  d_w=18  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/bram_sdp_FIFO_imps_18  top=bram_sdp_FIFO  d_w=18  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=impl
make  mem  p_dir=./workspace/bram_sdp_FIFO_36  		top=bram_sdp_FIFO  d_w=36  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=synth
make  mem  p_dir=./workspace/bram_sdp_FIFO_imps_36  top=bram_sdp_FIFO  d_w=36  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=impl




make  mem  p_dir=./workspace/bram_sdp_FIFO_three_cascaded_36_impl  top=bram_sdp_FIFO_three_cascaded  d_w=36  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=impl
make  mem  p_dir=./workspace/bram_sdp_FIFO_three_cascaded_18_impl  top=bram_sdp_FIFO_three_cascaded  d_w=18  addr_w=9  type=SDP  part=xczu28dr-ffvg1517-2-e task=impl




startgroup 
create_pblock pblock_selected
resize_pblock pblock_selected -add {SLICE_X83Y335:SLICE_X89Y344 DSP48E2_X15Y134:DSP48E2_X16Y137 RAMB18_X8Y134:RAMB18_X8Y137 RAMB36_X8Y67:RAMB36_X8Y68} -remove {SLICE_X85Y335:SLICE_X89Y344 DSP48E2_X16Y134:DSP48E2_X16Y137 RAMB18_X8Y134:RAMB18_X8Y137 RAMB36_X8Y67:RAMB36_X8Y68} -locs keep_all
add_cells_to_pblock pblock_selected [get_cells [list bram_sdp_FIFO_inst_2 bram_sdp_FIFO_inst_1 bram_sdp_FIFO_inst_0]] -clear_locs
endgroup

create_pblock pblock_selected
add_cells_to_pblock [get_pblocks pblock_selected] [get_cells -quiet [list bram_sdp_FIFO_inst_0 bram_sdp_FIFO_inst_1 bram_sdp_FIFO_inst_2]]
resize_pblock [get_pblocks pblock_selected] -add {SLICE_X83Y335:SLICE_X89Y344}
resize_pblock [get_pblocks pblock_selected] -add {DSP48E2_X15Y134:DSP48E2_X16Y137}
resize_pblock [get_pblocks pblock_selected] -add {RAMB18_X8Y134:RAMB18_X8Y137}
resize_pblock [get_pblocks pblock_selected] -add {RAMB36_X8Y67:RAMB36_X8Y68}

