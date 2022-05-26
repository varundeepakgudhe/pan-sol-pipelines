#!/usr/bin/env bash

PROT_LIST=$1

for i in `cat ${PROT_LIST}`
do 
	d=$( dirname ${i} ) ; 
	qsub /seq/schatz/sramakri/genome_annotations/scripts/submit_interproscan.sh ${i} ${d}/interpro.tsv
done
