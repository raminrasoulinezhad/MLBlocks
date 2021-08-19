out_dir=../../out
projects_dir=projects

cons_name=Cons.xdc
tcl_name=fpga.tcl


mkdir -p ./$projects_dir
cp -r $out_dir/* ./$projects_dir

for test_dir in ./$projects_dir/*/; do
    echo "$test_dir"
    
    cp $cons_name  $test_dir/
    cp $tcl_name  $test_dir/

    pushd $test_dir

    vivado -mode batch -source ./$tcl_name & 

    popd

done
