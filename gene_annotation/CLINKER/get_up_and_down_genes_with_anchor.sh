#!/usr/bin/env bash
#submit_script.sh
                           # The following are options passed to qsub
#$ -V                      # Inherit the submission environment
#$ -cwd                    # Start job in submission directory
#$ -e $JOB_NAME.e$JOB_ID   # Combine stderr and stdout
#$ -o $JOB_NAME.o$JOB_ID   # Name of the output file (eg. myMPI.oJobID)
#$ -m bes                  # Email at Begin and End of job or if suspended
#$ -l m_mem_free=4g
#$ -pe threads 1

FINAL_GFF=$1
ORTHO_DIR=$2 # Results_data dir from orthofinder
M_TAB=$3
GENE_OF_INTEREST=$4
FA=$5
PROT_FA=$6
GENE_WINDOW=$7
OUTDIR=$8
REF=$9

mkdir -p ${OUTDIR}

GENE=$( cat ${GENE_OF_INTEREST} )
GENE_SNAME=$( basename ${GENE_OF_INTEREST} ".txt" )
SPECIES=$( dirname ${FINAL_GFF}  | awk -F"/" '{ print $6}' )
REF_FUNC="/grid/lippman/data/pansol/ref_Heinz/v4.0/SL4.0_mRNA_func_tab.txt"
REF_NAME="SlycHeinz4.0"
QUERY_NAME=$( dirname ${FINAL_GFF}  | awk -F"/" '{ print $7}' | sed 's/S/Sol/1' )

echo "Generating clinker files for ${GENE_SNAME} in ${SPECIES} within ${GENE_WINDOW} genes up/downstream"
source /seq/schatz/sramakri/bashrc

BASE=$( basename ${FINAL_GFF} "_final.gff" | sed 's/_genes_/_V/g' | sed 's/Sol/S/g' )
echo "Get ${GENE_WINDOW} genes upstream and downstream of ${GENE} "

echo "Get ${GENE_WINDOW} genes upstream and downstream of ${GENE} in REF "
grep -A ${GENE_WINDOW} -B ${GENE_WINDOW} -f ${GENE_OF_INTEREST} ${REF_FUNC} | awk -F"\t" '{ split($1,a,".") ; print $1}' > ${OUTDIR}/ref_${GENE_WINDOW}_${GENE_SNAME}.genes.txt

echo "Getting functions of Ref genes"
grep -A ${GENE_WINDOW} -B ${GENE_WINDOW} -f ${GENE_OF_INTEREST} ${REF_FUNC} | awk -F"\t" '{ split($1,a,".") ; print $1"\t"$3 }' > ${OUTDIR}/ref_${GENE_WINDOW}_${GENE_SNAME}.genes_func.txt

if [ -z ${REF} ] ; then
	grep -A ${GENE_WINDOW} -B ${GENE_WINDOW} -f ${GENE_OF_INTEREST} ${M_TAB} | awk -F"\t" '{ print $4}' | sort | uniq | sed 's/mRNA:/gene:/g' | awk -F"." '{ print $1"."$2}' > ${OUTDIR}/${BASE}_${GENE_WINDOW}_${GENE_SNAME}.genes.txt

	#sed 's/gene://g' ${REF_GFF} | grep -f ${GENE_OF_INTEREST} -  |  awk -v x=${GENE_WINDOW} -F"\t" '$3 == "gene" { split($9,a,";"); split(a[2],b,"=") ; split(b[2],num,"g") ; for ( i=-x*10; i<=x*10 ; i=i+10 ) { n=num[2]+i ; printf("%sg%06d\n", num[1],n ) }}' > ${OUTDIR}/ref_${GENE_WINDOW}_${GENE_SNAME}.genes.txt
	#grep -f ${GENE_OF_INTEREST} ${REF_GFF} | awk -v x=${GENE_WINDOW} -F"\t" '{ split($9,a,";"); split(a[1],b,"="); split(b[2],num,"g") ; for ( i=-x*10; i<=x*10 ; i=i+10 ) { n=num[3]+i ; printf("g%sg%06d\n", num[2],n ) }}' > ${OUTDIR}/ref_${GENE_WINDOW}_${GENE_SNAME}.genes.txt
 		

else
	echo "Running as a reference "
	cp  ${OUTDIR}/ref_${GENE_WINDOW}_${GENE_SNAME}.genes.txt ${OUTDIR}/${BASE}_${GENE_WINDOW}_${GENE_SNAME}.genes.txt
fi

OFILE=$( ls ${ORTHO_DIR}/Orthologues/Orthologues_${REF_NAME}/${REF_NAME}__v__${QUERY_NAME}*.tsv )
# If genes not present , anchor neighbouring genes in ref
if  [ ! -s ${OUTDIR}/${BASE}_${GENE_WINDOW}_${GENE_SNAME}.genes.txt  ]; then
    echo "GENE is absent in ${M_TAB} file ; anchoring gene from orthofinder dir"
    grep -f ${GENE_OF_INTEREST} ${OFILE} | awk -F"\t" '{ print $3} ' | sed 's/mRNA_//g' > ${OUTDIR}/${BASE}_${GENE_SNAME}.gene_orthofinder.txt
    grep -A ${GENE_WINDOW} -B ${GENE_WINDOW} -f ${OUTDIR}/${BASE}_${GENE_SNAME}.gene_orthofinder.txt ${M_TAB} | awk -F"\t" '{ print $4}' | sort | uniq | sed 's/mRNA:/gene:/g' | awk -F"." '{ print $1"."$2}' > ${OUTDIR}/${BASE}_${GENE_WINDOW}_${GENE_SNAME}.genes.txt

    if  [ ! -s ${OUTDIR}/${BASE}_${GENE_WINDOW}_${GENE_SNAME}.genes.txt  ]; then
    echo "GENE is not found in orthodinder results ; still absent ; anchoring neighbouring genes"	
    grep -f ${OUTDIR}/ref_${GENE_WINDOW}_${GENE_SNAME}.genes.txt ${M_TAB} | awk -F"\t" '{ print $4 }' | grep -B 5 -A 5 -f - ${M_TAB} | awk -F"\t" '{ print $4 }' | sort | uniq > ${OUTDIR}/${BASE}_${GENE_WINDOW}_${GENE_SNAME}.genes.txt 
    fi
fi

source activate AGAT_latest
echo "Generating GFF file  for ${GENE_SNAME} in ${SPECIES} within ${GENE_WINDOW} genes up/downstream"
rm -f ${OUTDIR}/${BASE}_${GENE_SNAME}.gff
rm -f ${OUTDIR}/${BASE}_${GENE_SNAME}_report.txt
agat_sp_filter_feature_from_keep_list.pl --gff ${FINAL_GFF} --keep_list ${OUTDIR}/${BASE}_${GENE_WINDOW}_${GENE_SNAME}.genes.txt --output ${OUTDIR}/${BASE}_${GENE_SNAME}.gff

conda deactivate

echo "Sorting GFF for ${GENE_SNAME} in ${SPECIES} within ${GENE_WINDOW} genes up/downstream"
/seq/schatz/sramakri/sources/gt-1.5.10-Linux_x86_64-64bit-complete/bin/gt gff3 -sortlines -tidy -retainids ${OUTDIR}/${BASE}_${GENE_SNAME}.gff > ${OUTDIR}/${BASE}_${GENE_SNAME}_sorted.gff

awk -F"\t" '$3 == "mRNA" { split($9,a,";"); split(a[1],b,"="); print b[2] }' ${OUTDIR}/${BASE}_${GENE_SNAME}_sorted.gff > ${OUTDIR}/${BASE}_${GENE_SNAME}_sorted_mRNAs.txt

echo "Get protein function for  ${GENE_SNAME} in ${SPECIES} within ${GENE_WINDOW} genes up/downstream"
awk -F"\t" '$3 == "mRNA" { split($9,a,";"); split(a[1],b,"="); match($9,/Note=([^;]+)/); print b[2]"\t"substr($9,RSTART+5,RLENGTH) }' ${OUTDIR}/${BASE}_${GENE_SNAME}_sorted.gff > ${OUTDIR}/${BASE}_${GENE_SNAME}_proteins.tsv

sed 's/mRNA://g' ${OUTDIR}/${BASE}_${GENE_SNAME}_proteins.tsv | awk -F"\t" '{ split($1,a,".") ; print a[1]"."a[2]"\t"$2  } ' > ${OUTDIR}/${BASE}_${GENE_SNAME}_gene_proteins.tsv

echo "Subsetting proteins products for ${GENE_SNAME} in ${SPECIES} within ${GENE_WINDOW} genes up/downstream"
seqtk subseq ${PROT_FA} ${OUTDIR}/${BASE}_${GENE_SNAME}_sorted_mRNAs.txt > ${OUTDIR}/${BASE}_${GENE_SNAME}_proteins.fa
sed 's/>mRNA:[A-Za-z0-9.]* gene=/>/' ${OUTDIR}/${BASE}_${GENE_SNAME}_proteins.fa > ${OUTDIR}/${BASE}_${GENE_SNAME}_gene_proteins.fa

sed -i '1i gene\tproduct' ${OUTDIR}/${BASE}_${GENE_SNAME}_gene_proteins.tsv

source activate py2.7
echo "Generating tbl files for ${GENE_SNAME} in ${SPECIES} within ${GENE_WINDOW} genes up/downstream"
/grid/lippman/data/pansol/sources/scripts/gff3-to-tbl ${OUTDIR}/${BASE}_${GENE_SNAME}_sorted.gff ${OUTDIR}/${BASE}_${GENE_SNAME}_gene_proteins.tsv ${OUTDIR}/${BASE}_${GENE_SNAME}_proteins.fa > ${OUTDIR}/${BASE}_${GENE_SNAME}_w${GENE_WINDOW}.tbl

conda deactivate
cd ${OUTDIR}
awk -F"\t" '!/^#/ { print $1}' ${OUTDIR}/${BASE}_${GENE_SNAME}_sorted.gff | sort | uniq > ${OUTDIR}/${BASE}_${GENE_SNAME}_chr.txt
echo "Generate chr fa files"
SUBSET_FA=${OUTDIR}/${BASE}_${GENE_SNAME}_chr.fasta

#if [ ! -f ${SUBSET_FA} ] ; then
	echo "Generating SUBSET FA"
	seqtk subseq ${FA} ${OUTDIR}/${BASE}_${GENE_SNAME}_chr.txt > ${SUBSET_FA}
#fi 
echo "Generating gbk file for ${GENE_SNAME} in ${SPECIES} within ${GENE_WINDOW} genes up/downstream"
funannotate util tbl2gbk --tbl ${OUTDIR}/${BASE}_${GENE_SNAME}_w${GENE_WINDOW}.tbl -f ${SUBSET_FA} -s "Solanum ${SPECIES}" -o ${BASE}_${GENE_SNAME}_w${GENE_WINDOW}

UP_OUTDIR=$( dirname ${OUTDIR} )
BASE_OUTDIR=$( basename ${OUTDIR} | awk -F"/" '{ print $1}' )
cp ${OUTDIR}/${BASE}_${GENE_SNAME}_w${GENE_WINDOW}.gbk ${UP_OUTDIR}/${BASE_OUTDIR}.gbk

#/grid/lippman/data/pansol/sources/GFF-to-GenBank/gff_to_genbank_edit.py ${OUTDIR}/${BASE}_${GENE_SNAME}.gff ${FA}

#ln -fs ${OUTDIR}/${BASE}_${GENE_SNAME}.gb ${OUTDIR}/${BASE}.gbk
