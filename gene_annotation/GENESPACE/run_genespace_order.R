#!/usr/bin/env Rscript
library("optparse")
library("GENESPACE")

option_list = list(
  make_option(c("-d", "--run_dir"), type="character", default=NULL, 
              help="running dir", metavar="character"),
    make_option(c("-o", "--out_dir"), type="character", default="NULL", 
              help="output dir", metavar="character")
); 
 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if (is.null(opt$run_dir)){
  print_help(opt_parser)
  stop("run_genespace.R -d run_dir -o out_dir \n", call.=FALSE)
}

if (is.null(opt$run_dir)){
  print_help(opt_parser)
  stop("run_genespace.R -d run_dir -o out_dir \n", call.=FALSE)
}

PLOIDY<-1
runwd <- file.path(opt$run_dir)

print("Checking files in run_dir")
print(list.files(paste0(runwd,"/rawGenomes"), recursive = T, full.names = F))
annotation_dirs<-unique(lapply(list.files(paste0(runwd,"/rawGenomes"), recursive = T, full.names = F),dirname))
genome_dirs<-lapply(annotation_dirs,dirname)

gids<-c("SlycopersicumHeinz","SlycopersicumM82","SlycopersicumSweet100","Smuricatumhap1","Smuricatumhap2","Sabutiloides", "Squitoense","Sprinophyllum","Smacrocarpon","Saethiopicum","Smelongena41")

print(paste0("Set gene ids: ",gids))
#3.3 Initialize the GENESPACE run

print("Initializing GENESPACE")
ploidy=rep(PLOIDY,length(gids))
gpar <- init_genespace(
  genomeIDs = gids, 
  speciesIDs = gids, 
  versionIDs = gids, 
  ploidy = ploidy,
  wd = runwd, 
  gffString = "gff", 
  pepString = "pep",
  path2orthofinder = "orthofinder", 
  path2mcscanx = file.path("/grid/lippman/data/pansol/sources/MCScanX/"),
  rawGenomeDir = file.path(runwd,"rawGenomes"))

print("Initiolization Complete \n")
print("Parse annotations")
parse_annotations(
  gsParam = gpar, 
  gffEntryType = "mRNA", 
  gffIdColumn = "ID",
  gffStripText = "ID=", 
  headerEntryIndex = 1,
  headerSep = " ", 
  headerStripText = "ID=")

print("Running orthofinder")
gpar <- run_orthofinder(gsParam = gpar)

print("Running synteny")
gpar <- synteny(gsParam = gpar)
refGenome="SlycopersicumHeinz"

print("Plotting Riparian hits")
pdf(file.path(paste0(runwd,"/results/pangenome_ripariani_order.pdf")))
ripdat <- plot_riparianHits(gpar,useBlks = TRUE, refGenome = refGenome , useOrder = TRUE, reorderChrs = TRUE, returnSourceData = T)

dev.off()

print("Generating pangenome")
pg <- pangenome(gpar)
print("DONE")
