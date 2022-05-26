#!/usr/bin/env bash

GENOME_LIST=$1

PROJ_PATH="/grid/lippman/data/pansol/"
SCRIPTS_PATH="/seq/schatz/sramakri/genome_annotations/scripts/"
for i in `cat ${GENOME_LIST} | grep -v "Sweet-100" ` ; 
do  
	d=$( dirname ${i}) ; 
	species=$(  echo ${i} | cut -f6 -d"/" ) ; 
	sample=$(  echo ${i} | cut -f7 -d"/" ) ; 
	fa=${i} ; 
	rnaseq_list=${PROJ_PATH}/${species}/${sample}/data/rna/apices/rnaseq_samples.txt
	if [[ -f ${rnaseq_list} && -s ${rnaseq_list} ]]; then
		outdir=${d}/02_genes/02_mikado/01_mikado_run/01_STAR
		mkdir -p ${outdir}; 
		echo -e "Running STAR for all samples in : ${fa} in ${outdir}" ;  
		fadir=$( dirname ${fa} ); 
		${SCRIPTS_PATH}/submit_star.sh ${rnaseq_list} ${fadir} ${outdir} ;  
	else
		echo -e "WARNING: File ${rnaseq_list} does not exist ; Skipping running STAR for ${i}"
	fi
done
