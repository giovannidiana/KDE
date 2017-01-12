#!/bin/bash

gridsize=30
folder=pdf3D_bs
label=pdf3D_Hlscv
frac=1

GT="QL404"

for Food in "1" "2.00e+07" "6.30e+07" "6.30e+08" "2.00e+09" "1.10e+10" 
do
    for group in `seq 21 40`
    do
      Rscript code3D_bs.R $GT $Food $gridsize $folder $label$group $group $frac
    done
done
