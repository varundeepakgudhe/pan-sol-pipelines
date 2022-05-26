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
#gids<-lapply(genome_dirs,basename)
gids<-c("SlycopersicumHeinz","SlycopersicumM82","SlycopersicumSweet100","Smuricatumhap1","Smuricatumhap2","Sabutiloides", "Squitoense","Sprinophyllum","Smacrocarpon","Saethiopicum","Smelongena41")

print(paste0("Set gene ids: ",gids))
#3.3 Initialize the GENESPACE run
#gids <- c("human","chimp","rhesus")
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
  #rawGenomeDir = file.path(runwd))

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

#parse_annotations(
#  gsParam = gpar,
#  gffEntryType = "gene",
#  gffIdColumn = "locus",
#  gffStripText = "locus=",
#  headerEntryIndex = 1,
#  headerSep = " ",
#  headerStripText = "locus=")

print("Running orthofinder")
gpar <- run_orthofinder(gsParam = gpar)

print("Running synteny")
gpar <- synteny(gsParam = gpar)
refGenome="SlycopersicumHeinz"
#invert_chr<- data.frame(genome="S.melongena", chr="chr2")
#invert_chr[2,] <- c("Smelongena", "chr3")
#invert_chr[3,] <- c("Smelongena", "chr8")
#invert_chr[4,] <- c("Smelongena", "chr9")
#invert_chr[4,] <- c("Smelongena", "chr10")

#invert_chr<- data.frame(genome="Smelongena", chr="chr3")
#invert_chr[2,] <- c("Smelongena","chr8")
#invert_chr[3,] <- c("Smelongena", "chr9")
#invert_chr[4,] <- c("Smelongena", "chr10")
#invert_chr[5,] <- c("Saethiopicum", "chr1")
#invert_chr[6,] <- c("Saethiopicum","chr2")
#invert_chr[7,] <- c("Smacrocarpon", "chr1")
#invert_chr[8,] <- c("Sprinophyllum", "chr1")
#invert_chr[9,] <- c("Squitoenese", "chr1")
#invert_chr[10,] <- c("Squitoenese", "chr2")
#invert_chr[11,] <- c("Squitoenese", "chr12")
#invert_chr[12,] <- c("Squitoenese", "chr10")
#invert_chr[13,] <- c("Smuricatumhap2", "chr9") 


print("Plotting Riparian hits")
pdf(file.path(paste0(runwd,"/results/pangenome_ripariani_order.pdf")))
ripdat <- plot_riparianHits(gpar,useBlks = TRUE, refGenome = refGenome , useOrder = TRUE, reorderChrs = TRUE, returnSourceData = T)
#ripdat <- plot_riparianHits(gpar)
dev.off()

#pdf(file.path(paste0(runwd,"/results/pangenome_riparian_invert.pdf")))
#ripdat <- plot_riparianHits(gpar,useBlks = TRUE, useOrder = TRUE , refGenome = refGenome , returnSourceData = T)
#ripdat <- plot_riparianHits(gpar,useBlks = TRUE, refGenome = refGenome , useOrder = TRUE, reorderChrs = TRUE, invertTheseChrs = invert_chr, returnSourceData = T)
#dev.off()


print("Generating pangenome")
pg <- pangenome(gpar)
print("DONE")
