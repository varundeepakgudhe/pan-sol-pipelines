#/usr/bin/env bash

list=$1
outp=04_LIFTOFF

for i in `cat ${list}`;  
do 
	fa=${i}
	#ref="/seq/schatz/sramakri/genome_annotations/pansol/reference/solanaceae/sol_egg_heinz_pan.fa" ; 
	#db="/seq/schatz/sramakri/genome_annotations/pansol/reference/solanaceae/sol_egg_heinz_pan.gff_db" ; 
	#ref="/seq/schatz/sramakri/genome_annotations/pansol/reference/solanaceae/sol_egg_heinz.fa" ; 
	#db="/seq/schatz/sramakri/genome_annotations/pansol/reference/solanaceae/sol_egg_heinz.gff_db";
	ref="/seq/schatz/sramakri/genome_annotations/pansol/reference/solanaceae/sol_egg_heinz.fa" ; 
	db="/seq/schatz/sramakri/genome_annotations/pansol/reference/solanaceae/sol_egg_heinz.gff_db";
	#ref1="/grid/lippman/data/pansol/ref_Heinz/v4.0/SL4.0.genome.fasta" ; 
	#db="/grid/lippman/data/pansol/ref_Heinz/v4.0/CLE_genes/cles_manual_final_UTRs.gff_db"
	#db1="/grid/lippman/data/pansol/ref_Heinz/v4.0/CLE_genes/cles_manual_final_UTRs.gff_db"
	d=$( dirname ${i} ); 
	#outd=${d}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4;	
	#outd=${d}/02_genes/01_liftoff/liftoff_pansol_final;	
	outd=${d}/${outp}
	prefix=$( echo ${i} | awk '{ split($1,a,"/") ; if(( a[7] == "M82") || ( a[7] == "Sweet_100")) { gsub("_","-",a[7]); print "Sol"substr(a[6],1,3)""a[7] } else if( a[7] ~ /Smur2hap/ ) { print "Sol"substr(a[6],1,3)""substr(a[7],5,length(a[7])) } else { print "Sol"substr(a[6],1,3)""substr(a[7],5,1) }}' );  
	#version=$( basename ${fa} ".fasta" | cut -f2 -d"_" | cut -f2 -d"v" );
	version=t1; 
	echo -e "${fa}\t${ref}\t${db}\t${d}\t${outd}\t${prefix}\t${version}"
	qsub /seq/schatz/sramakri/genome_annotations/scripts/run_liftoff_annotations_with_flank.sh ${fa} ${ref} ${db} ${outd} ${prefix} ${version} 1 ;  
done
