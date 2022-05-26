#!/usr/bin/env bash

STAR_DIR_LIST=$1

PROJ_PATH="/grid/lippman/data/pansol/"
SCRIPTS_PATH="/seq/schatz/sramakri/genome_annotations/scripts/"
for i in `cat ${STAR_DIR_LIST}` ; 
do  
	d=$( dirname ${i}) ; 
	species=$(  echo ${i} | cut -f6 -d"/" ) ; 
	sample=$(  echo ${i} | cut -f7 -d"/" ) ; 
	fa=$( ls ${i}/../../../../Sol*.fasta )  ;
        outdir=${i}/../02_STRINGTIE
	mkdir -p ${outdir}; 
	echo -e "${i}\t${fa}\t${outdir}";
	${SCRIPTS_PATH}/submit_stringtie.sh ${i} ${outdir} ;  
done
