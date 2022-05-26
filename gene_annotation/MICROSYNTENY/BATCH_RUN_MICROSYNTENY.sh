#!/usr/bin/env bash 

PROT_LIST=$1


for i in `cat ${PROT_LIST}` ;
do 
	d=$( dirname ${i} ) ; 
	mkdir -p ${d}/04_microsynteny ; 
	gff=$( ls ${d}/Sol*[0-9].gff ); 
	qsub /seq/schatz/sramakri/genome_annotations/scripts/run_microsynteny.sh ${i} /seq/schatz/sramakri/genome_annotations/tomato/SL4.0/ITAG4.0_proteins.fasta ${d}/04_microsynteny ${gff} /seq/schatz/sramakri/genome_annotations/tomato/SL4.0/ITAG4.0_gene_models.gff ; 
done
