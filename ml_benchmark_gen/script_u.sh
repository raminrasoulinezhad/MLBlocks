DSP=2256 # 360, 1368, 9024, 12288
NUM_CORES=38

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
    './exp.sh {layer_file}  {mlb_file}  {DSP}' \
	::: layer_file $FILE_LAYERS \
	::: mlb_file $FILE_MLBS \
	::: DSP $DSP

for FILE_LAYER in ./layers/*; do 

	FILE_LAYER_NAME="${FILE_LAYER#*layers/}"
	FILE_LAYER_NAME="${FILE_LAYER_NAME%.*}"

	for FILE_MLB in ./mlbs/*; do 

		FILE_MLB_NAME="${FILE_MLB#*mlbs/}"
		FILE_MLB_NAME="${FILE_MLB_NAME%.*}"

		sed -n 's/.*with estimated cycle count *//p' ./results/temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out >> results/outputs/scores.out
	done

	echo ''  >> results/outputs/scores.out
done
