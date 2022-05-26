# Pansol Denovo Annotation Tutorial

![Denovo Gene annotation pipeline v1.0 ](https://github.com/pan-sol/pan-sol-pipelines/blob/main/tutorials/images/Pansol_denovo_gene_annotation_pipeline.png)

**Index:**

. [Getting Started](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#getting-started)

. [Pre-processing](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#pre-processing)

. [Gene Annotation](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#gene-annotation)

. [Functional Annotation](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#functional-annotation)

. [Orthofinder](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#orthofinder)

. [Microsynteny](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#microsynteny)

. [Packaging](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#packaging)

. [Genespace](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#genespace)

. [Create Reports](https://github.com/pan-sol/pan-sol-pipelines/blob/master/tutorials/denovo_gene_annotation_tutorial.md#reporting)


<br/>

## Getting Started
1. Project folder setup
    
*   Project root folder (CSHL) : /grid/lippman/data/pansol/

*   Raw RNASeq data
    <br/>
    Each solanum species contains a species folder and a sample folder under the project root folder. All raw data are organized under the data folder and RNAseq data and relavant QC are organized as subfolders under the data folder. Each sample has a rnaseq_samples.txt file under data/rna/<tissue_type>/rnaseq_samples.txt which includes all RNASeq samples and replicates. This file is the input to mapping RNASeq reads using STAR aligner.
  
```
Example :
/grid/lippman/data/pansol/abutiloides/Sabu2/data
├── ccs
└── rna
    └── apices
        ├── fastqc_out
        └── kraken2
            ├── Sabu2-2_S11
            │   └── sample_krona.html.files
            └── Sabu2-3_S17
                └── sample_krona.html.files
```
### 2. Reference Annotation pre-processing [Optional]

*   Self blastp alignment of reference proteins 
*   Filter out partial / psuedogenes based on reference protein alignment coverage and identity.
*   Filter out TE genes from protein coding genes using [TEsorter](https://github.com/zhangrengang/TEsorter)

<br/>[TODO: Add image]

<br/>

## Pre processing

#### 1. STAR - Mapping RNASeq reads

*   Create a list of packaged genome files ( full paths )

*   Run script ***gene_annotation/01_BATCH_SUBMIT_STAR_INDEX.sh ../input_files/packaged_fasta_files_05_25_2022.txt***

#### 2. Stringtie - Assembly of RNASeq transcripts

*   Run script ***gene_annotation/02_BATCH_SUBMIT_STAR.sh ../input_files/packaged_fasta_files_05_25_2022.txt***

#### 3. Portcullis - Filter out invalid splice junctions

*   Run script ***gene_annotation/03_BATCH_SUBMIT_PORTCULLIS.sh ../input_files/packaged_fasta_STAR_dirs_05_25_2022.txt***

#### 4. Liftoff - Liftoff filtered reference annotations from Heinz4.0 and Eggplant4.1 

*   Run script ***gene_annotation/04_BATCH_SUBMIT_LIFTOFF.sh ../input_files/packaged_fasta_STAR_dirs_05_25_2022.txt***

#### 4. GMAP and Minimap2 - Splice align filtered reference transcripts from Heinz4.0 and Eggplant4.1 

*   Run script ***gene_annotation/04_BATCH_SUBMIT_GENELIFT.sh ../input_files/packaged_fasta_STAR_dirs_05_25_2022.txt***

<br/>
At the end of this stage the project folder structure will look like below:
<br/>

```
/grid/lippman/data/pansol/abutiloides/Sabu2/07_package/01_SMUR2HAP2/01_rename/00_chromosomes/00_asm
└── 02_genes
    └── 02_mikado
        ├── 01_mikado_run
        │   ├── 01_STAR
        │   ├── 02_STRINGTIE
        │   │   ├── Sabu2-2_S11
        │   │   └── Sabu2-3_S17
        │   └── 03_PORTCULLIS
        │       ├── 1-prep
        │       ├── 2-junc
        │       └── 3-filt 

```
<br/>

## Gene Annotation

Here, we will use all the transcript assemblies generated in the previous step, along with splice junctions and pool them together. The redundant transcripts are also removed. Using consolidated transcripts, we will find full length trasncritps by BLAST searching against SwissProt proteins, and detect ORFs using TransDecoder.

#### 1. Configure Mikado run to final transcripts

*   Copy mikado template files from path 
/grid/lippman/data/pansol/sources/scripts/mikado

```
/grid/lippman/data/pansol/sources/scripts/mikado
├── /grid/lippman/data/pansol/sources/scripts/mikado/BATCH_SUBMISSION.sh
├── /grid/lippman/data/pansol/sources/scripts/mikado/plant.yaml
├── /grid/lippman/data/pansol/sources/scripts/mikado/snakemake.yaml
└── /grid/lippman/data/pansol/sources/scripts/mikado/submit_mikado_snakemake.sh

```
* Update **snakemake.yaml** file to include the species specific paths
* Run Mikado using script BATCH_SUBMISSION.sh

```
/grid/lippman/data/pansol/abutiloides/Sabu2/08_freeze/02_genes/02_mikado
├── 01_mikado_run
│   └── 5-mikado
│       ├── blast
│       ├── pick
│       │   ├── **permissive/mikado-permissive.loci.gff3**
│       │   └── stringent
│       └── transdecoder

```

* Run Mikado using script BATCH_SUBMISSION.sh

<br/>

## Functional Annotation

*   Run ENTAP functional annotation using script 
    ***gene_annotation/functional_annotation/BATCH_RUN_ENTAP.sh ../input_files/packaged_prot_fasta_05_25_2022.txt***

*   Run functional annotation using Interpro
    ***gene_annotation/functional_annotation/BATCH_RUN_INTERPRO.sh ../input_files/packaged_prot_fasta_05_25_2022.txt***


<br/>

## Orthofinder

*   Run orthofinder using script 
    ***gene_annotation/ORTHOFINDER/submit_orthofinder.sh ../input_files/packaged_prot_fasta_05_25_2022.txt***

<br/>

## Microsynteny 

*   Run Microsynteny on annotated proteins against Heinz 4.0

    ***gene_annotation/microsynteny/BATCH_RUN_MICROSYNTENY.sh../input_files/packaged_prot_fasta_05_25_2022.txt***

<br/>

## Packaging

<br/>

## Genespace 
*   Prepare files for genespace, 
    ***gene_annotation/GENESPACE/copy_files_for_genespace.sh ../input_files/packaged_gff_05_25_2022.txt***

*   Run genespace, ***gene_annotation/GENESPACE/run_GENESPACE_order.sh GENESPACE_DIR***

<br/>

## Create Reports 

<br/>


