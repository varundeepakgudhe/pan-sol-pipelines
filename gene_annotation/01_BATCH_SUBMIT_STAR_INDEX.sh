#!/usr/bin/env bash 
###################
# Script to run star index 
##################

GENOME_LIST=$1
SCRIPTS_PATH="/seq/schatz/sramakri/genome_annotations/scripts/"
for i in `cat ${GENOME_LIST}` ;
	do
	d=$( dirname ${i} ); 
	if [ -w "${d}" ] ; then 
		echo "${d} is WRITABLE"; 
		qsub ${SCRIPTS_PATH}/submit_star_index.sh ${i} ${d} ; 
	else 
		echo "${d} is NOT WRITABLE ; Cannot write indexes for ${i} "
	fi
done
