#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l m_mem_free=4G
#$ -pe threads 64

module load EBModules
module load BWA/0.7.17-GCC-10.2.0
module load SAMtools/1.14-GCC-10.3.0
module load BCFtools/1.12-GCC-10.3.0

PARENT_B_FASTQ_R1=/grid/lippman/data/Saet_locule_mapping/230106_VH00553_161_AAAY3N2HV/Data/Intensities/BaseCalls/NGS-JS-2600/S_1225_S7_R1_001.fastq.gz
PARENT_B_FASTQ_R2=/grid/lippman/data/Saet_locule_mapping/230106_VH00553_161_AAAY3N2HV/Data/Intensities/BaseCalls/NGS-JS-2600/S_1225_S7_R2_001.fastq.gz
BULK_1_FASTQ_R1=/grid/lippman/data/Saet_locule_mapping/230115_VH00553_167_AAAWVYKHV/Data/Intensities/BaseCalls/NGS-JS-2630/22-1276_IncreaseLocules_15_S10_R1_001.fastq.gz
BULK_1_FASTQ_R2=/grid/lippman/data/Saet_locule_mapping/230115_VH00553_167_AAAWVYKHV/Data/Intensities/BaseCalls/NGS-JS-2630/22-1276_IncreaseLocules_15_S10_R2_001.fastq.gz
BULK_2_FASTQ_R1=/grid/lippman/data/Saet_locule_mapping/230115_VH00553_167_AAAWVYKHV/Data/Intensities/BaseCalls/NGS-JS-2630/22-1276_ReducedLocules_15_S9_R1_001.fastq.gz
BULK_2_FASTQ_R2=/grid/lippman/data/Saet_locule_mapping/230115_VH00553_167_AAAWVYKHV/Data/Intensities/BaseCalls/NGS-JS-2630/22-1276_ReducedLocules_15_S9_R2_001.fastq.gz
BULK_1_SIZE=15
BULK_2_SIZE=15
OUTPUT_DIR=/grid/lippman/data/Saet_locule_mapping/QTLSEQ_1276_n15_outs

qtlseq -r /grid/lippman/data/pansol/aethiopicum/Saet3/13_freeze/V1.4/00_asm/Solaet3_v1.4.fasta \
       -p $PARENT_B_FASTQ_R1,$PARENT_B_FASTQ_R2 \
       -b1 $BULK_1_FASTQ_R1,$BULK_1_FASTQ_R2 \
       -b2 $BULK_2_FASTQ_R1,$BULK_2_FASTQ_R2 \
       -n1 $BULK_1_SIZE \
       -n2 $BULK_2_SIZE \
       -o $OUTPUT_DIR \
       -T
