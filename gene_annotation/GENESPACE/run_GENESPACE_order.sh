#!/usr/bin/env bash
#submit_script.sh
                           # The following are options passed to qsub
#$ -V                      # Inherit the submission environment
#$ -cwd                    # Start job in submission directory
#$ -e $JOB_NAME.e$JOB_ID   # Combine stderr and stdout
#$ -o $JOB_NAME.o$JOB_ID   # Name of the output file (eg. myMPI.oJobID)
#$ -m bes                  # Email at Begin and End of job or if suspended
#$ -l m_mem_free=70g
#$ -pe threads 2

RUNDIR=$1

source /seq/schatz/sramakri/bashrc
source activate r_env

export PATH=$PATH:/grid/lippman/data/pansol/sources/MCScanX

#/grid/lippman/data/pansol/sources/scripts/run_genespace_order.R -d ${RUNDIR} -o ${RUNDIR}
/grid/lippman/data/pansol/sources/scripts/GENESPACE/run_genespace_order_heinz_on_top.R -d ${RUNDIR} -o ${RUNDIR}
#/grid/lippman/data/pansol/sources/scripts/run_genespace_order_all_eggplant.R -d ${RUNDIR} -o ${RUNDIR}
