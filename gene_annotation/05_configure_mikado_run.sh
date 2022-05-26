#/usr/bin/env bash

list=$1


MIKADO_SCRIPTS_PATH=/grid/lippman/data/pansol/sources/scripts/mikado/
for i in `cat ${list}` ; 
do
	fa=$( ls ${i}/00_asm/Sol*.fasta );
	d=$( echo ${i} );
	outd=${d}/02_genes/02_mikado/;
	junc_file=${d}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/03_portcullis/3-filt/portcullis.pass.junctions.bed
	run_dir=${d}/02_genes/02_mikado/01_mikado_run
	mkdir -p ${run_dir};
	cp ${MIKADO_SCRIPTS_PATH}/* ${run_dir};
	YAML=${run_dir}/snakemake.yaml
       	sed -i "s#@GENOME_FASTA#$fa#" ${YAML};
       	sed -i "s#@OUTPUTDIR#$run_dir#" ${YAML};
       	sed -i "s#@JUNCS_FILE#$junc_file#" ${YAML};
	ls ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/02_stringtie/*/transcripts.gtf ${i}/02_genes/01_liftoff/liftoff_pansol_50x_flank0.25_d4/v*/Sol*[0-9].gff ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/04geneLift/gmap/gmap_gene_models.gff ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/04geneLift/minimap2/minimap2_gene_models.gff | tr "" "\n"  | sed 's/^/    - /' > ${run_dir}/evidence_list.txt
	ls ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/02_stringtie/*/transcripts.gtf ${i}/02_genes/01_liftoff/liftoff_pansol_50x_flank0.25_d4/v*/Sol*[0-9].gff ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/04geneLift/gmap/gmap_gene_models.gff ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/04geneLift/minimap2/minimap2_gene_models.gff | tr "" "\n" | awk -F"/" '{ print $(NF-2)"_"$(NF-1) }' | sed 's/^[0-9]*_//g' | sed 's/^04geneLift/geneLift/g' | sed 's/^/    - /' > ${run_dir}/evidence_labels.txt
 	 ls ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/02_stringtie/*/transcripts.gtf ${i}/02_genes/01_liftoff/liftoff_pansol_50x_flank0.25_d4/v*/Sol*[0-9].gff ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/04geneLift/gmap/gmap_gene_models.gff ${i}/02_genes/01_liftoff/liftoff_pansol_flank0.25_d4/04geneLift/minimap2/minimap2_gene_models.gff | tr "" "\n" | awk -F"/" '{ print $(NF-2)"_"$(NF-1) }' | sed 's/^[0-9]*_//g' | sed 's/^04geneLift/geneLift/g' | sed 's/^/      /' | sed 's/$/ : 1.0/' > ${run_dir}/evidence_scores.txt
done
