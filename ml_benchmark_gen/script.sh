#verilog_ml_benchmark_generator generate-accelerator-verilog \
#						--act_buffer_definition ./tests/input_spec_intel_8.yaml \
#						--weight_buffer_definition ./tests/input_spec_intel_8.yaml \
#						--emif_definition ./tests/emif_spec_intel.yaml \
#						--eb_definition ./results/mlbs/mlb_spec_xilinx_mode1.yaml \
#						--include_sv_sim_models False \
#						--layer_definition ./results/layers/conv_t_1_spec.yaml \
#						--eb_count 120 > ./results/temp/out.out
#

DSP=1080 # 360, 1368, 9024, 12288


rm -f results/outputs/scores.out
rm -f results/outputs/mlbs_orders.out
rm -f results/outputs/layers_orders.out

echo "" > results/outputs/scores.out
echo "" > results/outputs/mlbs_orders.out
echo "" > results/outputs/layers_orders.out

for FILE_MLB in ./results/layers/*; do 
	echo $FILE_MLB; 
	OUTPUT_NAME="${FILE_MLB#*layers/}"
	OUTPUT_NAME="${OUTPUT_NAME%.*}"
	echo $OUTPUT_NAME >> results/outputs/layers_orders.out
done

for FILE_MLB in ./results/mlbs/*; do 
	echo $FILE_MLB; 
	OUTPUT_NAME="${FILE_MLB#*mlbs/}"
	OUTPUT_NAME="${OUTPUT_NAME%.*}"
	echo $OUTPUT_NAME >> results/outputs/mlbs_orders.out
done

for FILE_LAYER in ./results/layers/*; do 

	FILE_LAYER_NAME="${FILE_LAYER#*layers/}"
	FILE_LAYER_NAME="${FILE_LAYER_NAME%.*}"

	for FILE_MLB in ./results/mlbs/*; do 

		FILE_MLB_NAME="${FILE_MLB#*mlbs/}"
		FILE_MLB_NAME="${FILE_MLB_NAME%.*}"

		if [ -f "./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out" ]; then
			echo " results for $FILE_LAYER_NAME and $FILE_MLB_NAME is ready."
		else 
			verilog_ml_benchmark_generator generate-accelerator-verilog \
						--act_buffer_definition ./tests/input_spec_intel_8.yaml \
						--weight_buffer_definition ./tests/input_spec_intel_8.yaml \
						--emif_definition ./tests/emif_spec_intel.yaml \
						--eb_definition $FILE_MLB \
						--include_sv_sim_models False \
						--layer_definition $FILE_LAYER \
						--eb_count ${DSP} > ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out & 
		fi

		#sed -n 's/.*with estimated cycle count *//p' ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out >> results/outputs/scores.out
	done

	wait

	for FILE_MLB in ./results/mlbs/*; do 

		FILE_MLB_NAME="${FILE_MLB#*mlbs/}"
		FILE_MLB_NAME="${FILE_MLB_NAME%.*}"

		sed -n 's/.*with estimated cycle count *//p' ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out >> results/outputs/scores.out
	done

	echo ''  >> results/outputs/scores.out
done
