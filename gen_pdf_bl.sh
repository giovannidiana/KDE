#!/bin/bash

gridsize=$1

for list in list1 list2 list3 list4  
do
   Rscript code_byList.R $Batch $list $gridsize pdf_WT-List
done
