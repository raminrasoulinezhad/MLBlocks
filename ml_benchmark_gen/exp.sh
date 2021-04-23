#!/bin/bash

FILE_LAYER=$1
FILE_MLB=$2
DSP=$3
AREA_RATIO_MODE=$4

echo $FILE_LAYER
echo $FILE_MLB
echo $DSP
echo $AREA_RATIO_MODE

FILE_LAYER_NAME="${FILE_LAYER#*layers/}"
FILE_LAYER_NAME="${FILE_LAYER_NAME%.*}"

FILE_MLB_NAME="${FILE_MLB#*mlbs/}"
FILE_MLB_NAME="${FILE_MLB_NAME%.*}"

# source: 
#	https://stackoverflow.com/questions/2237080/how-to-compare-strings-in-bash
#	https://stackoverflow.com/questions/2394988/get-ceiling-integer-from-number-in-linux-bash
#	https://unix.stackexchange.com/questions/168476/convert-a-float-to-the-next-integer-up-as-opposed-to-the-nearest

scale() {
  awk -vnumber="${1}" -vratio="${2}" '
  function scale(number,ratio){return int(number/ratio)}
  BEGIN{ print scale(number,ratio) }'
}

if [[ "${FILE_MLB_NAME,,}" == *"mlb12"* ]]
then
	if [[ "$AREA_RATIO_MODE" = "LP" ]]
	then
		EB=$( scale $DSP 0.85 )
	elif [[ "$AREA_RATIO_MODE" = "LHP" ]] 
	then 
		EB=$( scale $DSP 1.44 )
	elif [[ "$AREA_RATIO_MODE" = "None" ]] 
	then 
		EB=$DSP
	fi
elif [[ "${FILE_MLB_NAME,,}" == *"mlb9"* ]]
then
	if [[ "$AREA_RATIO_MODE" = "LP" ]]
	then
		EB=$( scale $DSP 0.66 )
	elif [[ "$AREA_RATIO_MODE" = "LHP" ]] 
	then 
		EB=$( scale $DSP 1.20 )
	elif [[ "$AREA_RATIO_MODE" = "None" ]] 
	then 
		EB=$DSP
	fi
elif [[ "${FILE_MLB_NAME,,}" == *"mlb8"* ]]
then
	if [[ "$AREA_RATIO_MODE" = "LP" ]]
	then
		EB=$( scale $DSP 0.56 )
	elif [[ "$AREA_RATIO_MODE" = "LHP" ]] 
	then 
		EB=$( scale $DSP 0.96 )
	elif [[ "$AREA_RATIO_MODE" = "None" ]] 
	then 
		EB=$DSP
	fi
elif [[ "${FILE_MLB_NAME,,}" == *"mlb6"* ]]
then
	if [[ "$AREA_RATIO_MODE" = "LP" ]]
	then
		EB=$( scale $DSP 0.46 )
	elif [[ "$AREA_RATIO_MODE" = "LHP" ]] 
	then 
		EB=$( scale $DSP 0.80 )
	elif [[ "$AREA_RATIO_MODE" = "None" ]] 
	then 
		EB=$DSP
	fi
else
	EB=$DSP
fi

echo $EB

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
				--eb_count ${EB} > ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out 
fi
