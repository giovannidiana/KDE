#!/bin/bash

gridsize=30
folder=JKpdf
label=JKpdf
group=0

for frac in `seq 60 5 100`; do
	./gen_pdf3D.sh  $gridsize $folder $frac"_"$label $(echo $frac/100 | bc -l) & 
done
