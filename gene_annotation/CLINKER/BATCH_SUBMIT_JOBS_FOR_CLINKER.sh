#!/usr/bin/env bash 


CLINKER_BASE="/grid/lippman/data/pansol/tmp_clinker/missed_genes"
ANN_BASE_PREFIX="02_mikado/"
LIFTOFF_BASE_DIR="01_liftoff/liftoff_pansol_50x_flank0.25_d4"
ORTHOFINDER_BASE_DIR="/grid/lippman/data/pansol/tmp_orthofinder/mikado_v3/rerun/OrthoFinder/Results_Mar31/"

for k in `ls ${CLINKER_BASE}/*.txt` ; 
do
	k_base=$( basename ${k} ".txt" ) ; 
	for i in `ls /grid/lippman/data/pansol/*/*/*freeze/02_genes/${ANN_BASE_PREFIX}/v*_v3/Sol*[0-9].gff`; 
	do 
	d=$( dirname ${i}) ; 
	fa=$( ls ${d}/../../../00_asm/Sol*.fasta ); 
	prot_fa=$( ls ${d}/Sol*proteins.fasta ); 
	#k_base=$( basename ${k} ".txt" ) ; 
	mtab=$( ls ${d}/04_microsynteny/*_ITAG4.0_microsynteny.tab); 
	sp=$( echo ${i} | awk -F"/" '{ print $7 }' ) ;  
	qsub /grid/lippman/data/pansol/tmp_clinker/get_up_and_down_genes_microsynteny_chr_with_anchor_orthofinder.sh ${i} ${ORTHOFINDER_BASE_DIR} ${mtab} ${k} ${fa} ${prot_fa} 5 `pwd`/syn_${k_base}_w5_mikado_chr_with_anchor/${sp}; 
	done ; 

	for i in `ls /grid/lippman/data/pansol/lyc*/Sweet*/*freeze/02_genes/${LIFTOFF_BASE_DIR}/v*/Sol*[0-9].gff`; 
	 do 
		 d=$( dirname ${i}) ; 
		 fa=$( ls ${d}/../../../../00_asm/Sol*.fasta ); 
		 prot_fa=$( ls ${d}/Sol*proteins.fasta ); 
	#	 k_base=$( basename ${k} ".txt" ) ; 
		 mtab=$( ls ${d}/04_microsynteny/*_ITAG4.0_microsynteny.tab); 
		 sp=$( echo ${i} | awk -F"/" '{ print $7 }' ) ;  
		 qsub /grid/lippman/data/pansol/tmp_clinker/get_up_and_down_genes_microsynteny_chr_with_anchor_orthofinder.sh ${i} ${ORTHOFINDER_BASE_DIR} ${mtab} ${k} ${fa} ${prot_fa} 5 `pwd`/syn_${k_base}_w5_mikado_chr_with_anchor/${sp}; 
	 done ; 

	qsub /grid/lippman/data/pansol/tmp_clinker/get_up_and_down_genes_microsynteny_chr_with_anchor_orthofinder.sh /grid/lippman/data/pansol/ref_Eggplant/v4.0/Eggplant.gff ${ORTHOFINDER_BASE_DIR} /grid/lippman/data/pansol/ref_Eggplant/v4.0/04_microsynteny/Eggplant_ITAG4.0_microsynteny.tab ${k} /grid/lippman/data/pansol/ref_Eggplant/v4.0/Eggplant.fa /grid/lippman/data/pansol/ref_Eggplant/v4.0/Eggplant_V4_pep.fa 5 `pwd`/syn_${k_base}_w5_mikado_chr_with_anchor/Smel4;

	qsub /grid/lippman/data/pansol/tmp_clinker/get_up_and_down_genes_microsynteny_chr_with_anchor.sh /grid/lippman/data/pansol/ref_Heinz/v4.0/ITAG4.0_gene_models.gff "None" ${k} /grid/lippman/data/pansol/ref_Heinz/v4.0/SL4.0.genome.fasta /grid/lippman/data/pansol/ref_Heinz/v4.0/ITAG4.0_proteins.fasta 5 `pwd`/syn_${k_base}_w5_mikado_chr_with_anchor/Slyc4 "YES";
done
