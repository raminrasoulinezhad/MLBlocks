DSP=$1 
NUM_CORES=$2
AREA_RATIO_MODE=$3
enable_exp=$4
dir_outputs=$5
dir_temp=$6

rm -f $dir_outputs/scores.out
rm -f $dir_outputs/mlbs_orders.out
rm -f $dir_outputs/layers_orders.out

echo "" > $dir_outputs/scores.out
echo "" > $dir_outputs/mlbs_orders.out
echo "" > $dir_outputs/layers_orders.out

for FILE_MLB in ./layers/*; do 
	echo $FILE_MLB; 
	OUTPUT_NAME="${FILE_MLB#*layers/}"
	OUTPUT_NAME="${OUTPUT_NAME%.*}"
	echo $OUTPUT_NAME >> $dir_outputs/layers_orders.out
done

for FILE_MLB in ./mlbs/*; do 
	echo $FILE_MLB; 
	OUTPUT_NAME="${FILE_MLB#*mlbs/}"
	OUTPUT_NAME="${OUTPUT_NAME%.*}"
	echo $OUTPUT_NAME >> $dir_outputs/mlbs_orders.out
done

FILE_LAYERS=./layers/*
FILE_MLBS=./mlbs/*

if [ $enable_exp -eq 1 ]
then  
	parallel --bar --gnu -j${NUM_CORES} --header : \
		'./exp.sh {layer_file}  {mlb_file}  {DSP}  {AREA_RATIO_MODE} ' \
		::: layer_file $FILE_LAYERS \
		::: mlb_file $FILE_MLBS \
		::: DSP $DSP \
		::: AREA_RATIO_MODE $AREA_RATIO_MODE
fi

for FILE_LAYER in ./layers/*; do 

	FILE_LAYER_NAME="${FILE_LAYER#*layers/}"
	FILE_LAYER_NAME="${FILE_LAYER_NAME%.*}"

	for FILE_MLB in ./mlbs/*; do 

		FILE_MLB_NAME="${FILE_MLB#*mlbs/}"
		FILE_MLB_NAME="${FILE_MLB_NAME%.*}"

		if [ -s "$dir_temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out" ] 
		then
			echo "$dir_temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out has some data."
			cycles=$(sed -n 's/.*with estimated cycle count *//p' $dir_temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out)
			digits=${#cycles}
			if [ $digits -eq 0 ]
			then  
				echo "549755813887[0m" >> $dir_outputs/scores.out
				# (2 ^ 39) - 1 + three extra character
			else
				sed -n 's/.*with estimated cycle count *//p' $dir_temp/out$FILE_LAYER_NAME$FILE_MLB_NAME.out >> $dir_outputs/scores.out	
			fi
		else
			echo "549755813887[0m" >> $dir_outputs/scores.out
		fi
	done
	echo ''  >> $dir_outputs/scores.out
done
