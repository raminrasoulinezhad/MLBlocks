FILE_LAYER=$1
FILE_MLB=$2
DSP=$3

echo $FILE_LAYER
echo $FILE_MLB

FILE_LAYER_NAME="${FILE_LAYER#*layers/}"
FILE_LAYER_NAME="${FILE_LAYER_NAME%.*}"

FILE_MLB_NAME="${FILE_MLB#*mlbs/}"
FILE_MLB_NAME="${FILE_MLB_NAME%.*}"

if [ -f "./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out" ]; then
	echo " results for $FILE_LAYER_NAME and $FILE_MLB_NAME is ready."
else 
	verilog_ml_benchmark_generator generate-accelerator-verilog \
				--act_buffer_definition ./verilog_ml_benchmark_generator/tests/input_spec_intel_8.yaml \
				--weight_buffer_definition ./verilog_ml_benchmark_generator/tests/input_spec_intel_8.yaml \
				--emif_definition ./verilog_ml_benchmark_generator/tests/emif_spec_intel.yaml \
				--eb_definition $FILE_MLB \
				--include_sv_sim_models False \
				--layer_definition $FILE_LAYER \
				--eb_count ${DSP} > ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out 
fi
