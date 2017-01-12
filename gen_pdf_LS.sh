#!/bin/bash

gridsize=$1

for Food in "1.00e+00" "2.00e+07" "6.32e+07" "6.32e+08" "2.00e+09" "1.12e+10"  
do
 for GT in "N2" "QL101" "QL282" "QL300"
 do
    for group in 0 1 2 3 4 5
    do
       Rscript code1D_LS.R $GT $Food $gridsize pdf_LS $group
    done
 done

done
