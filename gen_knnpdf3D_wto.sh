#!/bin/bash

Food=$1
gridsize=30
folder="kNN"
label="3NN"
frac=1
nn=3
GT="QL196"

    for group in 1 2 3 4 5
    do
      Rscript code3D_kNN.R $GT $Food $gridsize $folder $label $group $frac $nn
    done

