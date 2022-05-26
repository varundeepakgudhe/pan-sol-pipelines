#!/bin/bash
#submit_script.sh
                           # The following are options passed to qsub
#$ -V                      # Inherit the submission environment
#$ -cwd                    # Start job in submission directory
#$ -e $JOB_NAME.e$JOB_ID   # Combine stderr and stdout
#$ -o $JOB_NAME.o$JOB_ID   # Name of the output file (eg. myMPI.oJobID)
#$ -m bes                  # Email at Begin and End of job or if suspended
#$ -l m_mem_free=2g
#$ -pe threads 10


PROT_LIST=$1
ORTHOFINDER_DIR=$2


for i in `cat ${PROT_LIST}` ;
do
	base_p=$( basename ${i} ".proteins.fasta" | sed 's/genes_//' );
	out=${ORTHOFINDER_DIR}/${base_p}.fa
	#sed 's/mRNA://g' ${i} > ${out}
	cp ${i} > ${out}
done

source /seq/schatz/sramakri/bashrc
source activate orthologs

for f in ${ORTHOFINDER_DIR}/*.fa ; 
do 
	python /seq/schatz/sramakri/anaconda3/envs/orthologs/bin/primary_transcript.py $f ; 
done
echo "Running orthofinder in ${ORTHOFINDER_DIR}
orthofinder -S diamond_ultra_sens -f ${ORTHOFINDER_DIR}
