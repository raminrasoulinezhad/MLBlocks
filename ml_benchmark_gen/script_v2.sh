DSP=$1 
NUM_CORES=$2
AREA_RATIO_MODE=$3

rm -f results/outputs/scores.out
rm -f results/outputs/mlbs_orders.out
rm -f results/outputs/layers_orders.out

echo "" > results/outputs/scores.out
echo "" > results/outputs/mlbs_orders.out
echo "" > results/outputs/layers_orders.out

for FILE_MLB in ./layers/*; do 
	echo $FILE_MLB; 
	OUTPUT_NAME="${FILE_MLB#*layers/}"
	OUTPUT_NAME="${OUTPUT_NAME%.*}"
	echo $OUTPUT_NAME >> results/outputs/layers_orders.out
done

for FILE_MLB in ./mlbs/*; do 
	echo $FILE_MLB; 
	OUTPUT_NAME="${FILE_MLB#*mlbs/}"
	OUTPUT_NAME="${OUTPUT_NAME%.*}"
	echo $OUTPUT_NAME >> results/outputs/mlbs_orders.out
done

FILE_LAYERS=./layers/*
FILE_MLBS=./mlbs/*

parallel --bar --gnu -j${NUM_CORES} --header : \
    './exp_v2.sh {layer_file}  {mlb_file}  {DSP}  {AREA_RATIO_MODE} ' \
	::: layer_file $FILE_LAYERS \
	::: mlb_file $FILE_MLBS \
	::: DSP $DSP \
	::: AREA_RATIO_MODE $AREA_RATIO_MODE

for FILE_LAYER in ./layers/*; do 

	FILE_LAYER_NAME="${FILE_LAYER#*layers/}"
	FILE_LAYER_NAME="${FILE_LAYER_NAME%.*}"

	for FILE_MLB in ./mlbs/*; do 

		FILE_MLB_NAME="${FILE_MLB#*mlbs/}"
		FILE_MLB_NAME="${FILE_MLB_NAME%.*}"

		if [ -s "./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out" ] 
		then
			echo "./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out has some data."
			cycles=$(sed -n 's/.*with estimated cycle count *//p' ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out)
			digits=${#cycles}
			if [ $digits -eq 0 ]
			then  
				echo "549755813887[0m" >> results/outputs/scores.out
				# (2 ^ 39) - 1 + three extra character
			else
				sed -n 's/.*with estimated cycle count *//p' ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out >> results/outputs/scores.out	
			fi
		else
			echo "./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out is empty."
			sed -n 's/.*with estimated cycle count *//p' ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out >> results/outputs/scores.out
		fi
		
	done

	echo ''  >> results/outputs/scores.out
done

python3  plot_speedup_per_benchmarks.py
cp -r results/outputs results/DSP$DSP 
cp -r results/temp results/tempDSP$DSP 

