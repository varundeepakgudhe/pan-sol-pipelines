#!/usr/bin/env bash

GFF_LIST=$1
GENESPACE_DIR=$2


TEMPLATE_DIR="/grid/lippman/data/pansol/tmp_genespace/run_orient_heinz/"


#cd ${TEMPLATE_DIR}/rawGenomes && tree -dfi --noreport | xargs -I{} mkdir -p ${GENESPACE_DIR}/rawGenomes/{}
# Change this below line to the list of gff file paths
mkdir -p ${GENESPACE_DIR}/rawGenomes
cp -Rf /grid/lippman/data/pansol/tmp_genespace/run_orient_heinz/rawGenomes/SlycopersicumHeinz ${GENESPACE_DIR}/rawGenomes/
cp -Rf /grid/lippman/data/pansol/tmp_genespace/run_orient_heinz/rawGenomes/SlycopersicumM82 ${GENESPACE_DIR}/rawGenomes/


SUB="muricatum"
for i in `cat ${GFF_LIST}`;
do 
	d=$( dirname ${i} ); 
	sp=$( echo ${i} | awk -F"/" '{ print $6}' ) ; 
	if [[ "$sp" == *"$SUB"* ]]; then
	   sp=$( echo ${i} | awk -F"/" '{ hap=substr($7,6,length($7)) ;  print $6""hap}' ) ;
	fi
	outd="${GENESPACE_DIR}/rawGenomes/"S${sp}"/"S${sp}"/annotation/" ; 
	mkdir -p ${outd} ; 
	prot=$( ls ${d}/*.proteins.fasta ); 
	cp -nf ${i} ${outd}; 
	cp -nf ${prot} ${outd} ; 
	sed -i 's/mRNA://g' ${outd}/*.gff ; 
	sed -i 's/mRNA://g' ${outd}/*.fasta ; 
	rename "_genes" "" ${outd}/* ; 
	rename ".gff" "_gene.gff" ${outd}/*.gff ; 
	pigz -p 4 ${outd}/*.gff ; 
	rename ".proteins.fasta" ".pep.fa" ${outd}/*.fasta ; 
	pigz -p 4 ${outd}/*.fa ; 
done
