#!/bin/bash

gridsize=$1
seed=$2

for Food in "1" "2.00e+07" "6.30e+07" "6.30e+08" "2.00e+09" "1.10e+10" 
do
 for GT in "QL196" #"QL404" "QL402" "QL435"
 do
    Rscript code3D_randomized.R $GT $Food $gridsize pdf3D_WT-June $seed
 done

done
