#!/bin/bash

gridsize=$1

while read -r Batch  
do
   Rscript code_byBatch.R $Batch $gridsize pdf_wt_bb
done<table.txt
