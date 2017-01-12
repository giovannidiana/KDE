#!/bin/bash

gridsize=$1
folder=$2
label=$3
frac=$4
nn=$5
GT=$6

for Food in "1" "2.00e+07" "6.30e+07" "6.30e+08" "2.00e+09" "1.10e+10" 
do
    for group in 1 2 3 4 5
    do
      Rscript code3D_kNN.R $GT $Food $gridsize $folder $label $group $frac $nn
    done

done
