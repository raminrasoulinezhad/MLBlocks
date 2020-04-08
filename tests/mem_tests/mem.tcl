create_project project_1 [lindex $argv 0] -part [lindex $argv 6]

add_files -norecurse ../../src/mem.v
add_files -fileset constrs_1 -norecurse ./Cons.xdc

update_compile_order -fileset sources_1
update_compile_order -fileset sources_1

create_run synth -flow {Vivado Synthesis 2018}
create_run impl -parent_run synth -flow {Vivado Implementation 2018}

set_property top [lindex $argv 1] [current_fileset]
set_property generic "DATA_WIDTH=[lindex $argv 2] ADDR_WIDTH=[lindex $argv 3] RAM_TYPE=[lindex $argv 4] MEM_INIT=[lindex $argv 5]" [current_fileset] 

reset_run synth
reset_run impl

launch_runs synth -jobs 4
wait_on_run synth

exit 
