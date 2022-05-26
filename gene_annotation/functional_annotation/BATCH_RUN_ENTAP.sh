#!/usr/bin/env bash


PROT_LIST=$1

for i in `cat ${PROT_LIST}`
do 
	d=$( dirname ${i} ) ; 
	qsub /seq/schatz/sramakri/genome_annotations/scripts/run_ENTAP_pipeline.sh ${i} ${d}/ENTAP /seq/schatz/sramakri/db/refseq_plant/refseq_plants.fasta /seq/schatz/sramakri/db/refseq_complete/refseq_all.fasta /seq/schatz/sramakri/db/uniprot-trembl/uniprot_trembl.fasta /seq/schatz/sramakri/db/uniprot/uniprot_sprot.fasta 
done
