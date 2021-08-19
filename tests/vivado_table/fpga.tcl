# ULTRA96 V2
# create_project project . -part xczu3eg-sbva484-1-e  

# Virtex UltraScale+
create_project project . -part xcvu5p-flva2104-1-i

add_files -norecurse {./MAC_unit_v2.sv}
add_files -norecurse {./accumulator_v2.sv}
add_files -norecurse {./mult_flex.sv}
add_files -norecurse {./shifter.sv}
add_files -norecurse {./state_machine.sv}
add_files -norecurse {./stream_flex_v2.sv}
add_files -norecurse {./stream_mem.sv}
add_files -norecurse {./MLBlock_2Dflex_v2.sv}
add_files -norecurse {./MAC_unit.sv}
add_files -norecurse {./accumulator.sv}
add_files -norecurse {./out_unit.sv}
add_files -norecurse {./stream_flex.sv}
add_files -norecurse {./MLBlock_1Dsuperflex.sv}
add_files -norecurse {./MLBlock.sv}
add_files -norecurse {./MLBlock_2Dflex.sv}
add_files -norecurse {./MLBlock_sample.sv}
add_files -norecurse {./adder.sv}
add_files -norecurse {./mux.sv}
add_files -norecurse {./pe.sv}



set_property top MLBlock_2Dflex_v2 [current_fileset]
add_files -fileset constrs_1 -norecurse ./Cons.xdc

update_compile_order -fileset sources_1
update_compile_order -fileset sources_1

create_run synth -flow {Vivado Synthesis 2018}
create_run impl -parent_run synth -flow {Vivado Implementation 2018}

set_property STEPS.SYNTH_DESIGN.ARGS.MAX_DSP 0 [get_runs synth]

reset_run impl
reset_run synth

launch_runs impl -jobs 4
wait_on_run impl

exit 

