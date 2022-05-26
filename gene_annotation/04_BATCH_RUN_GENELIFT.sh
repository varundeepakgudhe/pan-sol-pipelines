#/usr/bin/env bash

STAR_DIR_LIST=$1
outp=04_GENELIFT

SCRIPTS_PATH="/seq/schatz/sramakri/genome_annotations/scripts/"

REF=""
REF_CDNA=""
REF_DESC=""
COVERAGE_CUTOFF=50
IDENTITY_CUTOFF=75

for i in `cat ${STAR_DIR_LIST}`;  
do 
 	fa=$( ls ${i}/../../../../Sol*.fasta );
	d=$( dirname ${i} ); 
	outdir=${d}/${outp}
	prefix=$( echo ${i} | awk '{ split($1,a,"/") ; if(( a[7] == "M82") || ( a[7] == "Sweet_100")) { gsub("_","-",a[7]); print "Sol"substr(a[6],1,3)""a[7] } else if( a[7] ~ /Smur2hap/ ) { print "Sol"substr(a[6],1,3)""substr(a[7],5,length(a[7])) } else { print "Sol"substr(a[6],1,3)""substr(a[7],5,1) }}' );  
	#version=$( basename ${fa} ".fasta" | cut -f2 -d"_" | cut -f2 -d"v" );
	version=t1; 
	echo -e "${fa}\t${ref}\t${db}\t${d}\t${outd}\t${prefix}\t${version}"
	qsub ${SCRIPTS_PATH}/submit_geneLift.sh ${fa} ${REF_CDNA} ${outdir} ${COVERAGE_CUTOFF} ${IDENTITY_CUTOFF} ${REF_DESC};
done
