library("optparse")
library("GENESPACE")
library("RColorBrewer")
library("ggthemes")

ggthemes <- ggplot2::theme(
  panel.background = ggplot2::element_rect(fill = "white"))

###############################################
# -- change paths to those valid on your system
genomeRepo <- "/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V14/rawGenomes"
wd <- "/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V15_JUNE/"
path2mcscanx <- "/grid/lippman/data/pansol/sources/MCScanX/"
###############################################

# -- download raw data from NCBI for human and chicken genomes
#dir.create(genomeRepo)
#rawFiles <- download_exampleData(filepath = genomeRepo)

gids<-c("Solang8_1.1.3","Solaet3_1.5.3","Solvio1_1.1.3","Sollin1_1.2.3","Solins1_1.1.3",
	"Solmac3_1.5.3","Solgig1_1.2.3","Solpri1_1.3.3","Solcle2_1.2.3","Soltor1_1.1.3",
	"Solcit1_1.1.3","Solqui2_1.3.3","Solcan1_1.1.3","Solpse1_1.1.3","Solstr1_1.1.3",
	"Solmam1_1.1.3","Solrob1_1.2.3","Solhav1_1.2.3","Solabu2_1.1.3","Solame3_1.1.3",
	"Solmur2hap1_1.3.3","Soletu1_1.2.3","SollycM82_1.0.3")

#0: SlycHeinz4.0.

	#"Solabu2","Solame3","Solcan1","Solcle2","Solgig1","Solins1","SollycM82","Solmam1","Solpri1","Solqui2","Solstr1",
        #"Solvio1","Solaet3","Solang8","Solcit1","Soletu1","Solhav1","Sollin1","Solmac3",  "Solmur2","Solpse1","Solrob1","Soltor1") 

# -- parse the annotations to fastas with headers that match a gene bed file
#parsedPaths <- parse_annotations(
#  rawGenomeRepo = genomeRepo,
#  genomeDirs = gids,
#  genomeIDs = gids,
#  presets = "ncbi",
#  genespaceWd = wd)
?init_genespace
# -- initalize the run and QC the inputs
gpar <- init_genespace(
  wd = wd, 
  rawOrthofinderDir = "/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V15_JUNE/orthofinder",
  path2mcscanx = path2mcscanx)
#gpar$paths$rawOrthofinder <- "orthofinder"
# -- accomplish the run
?run_genespace
out <- run_genespace(gpar)

customPal <- colorRampPalette(c("#F4F1BE","#F4F1BE","#FFDEC2","#FFBDC1","#F4B3E8","#BFA3EB",
				"#92BCF7","#81D7F3","#7FEBF5","#85F4DC","#98FBA3",
				"#A5F3A9","#58D095"))
			      #c("#FBF8CB","#FDE4CE","#FFCFD2","#F1C0E8","#CFBAF0",
				#"#A3C4F3","#90DBF4","#8DECF5","#98F5E1","#B9FCC0",
				#"#B0F2B3","#73C69D"))

#rev_gids <- rev(gids)
pdf(file.path("/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V15_JUNE/pangenome_ripariani_order.pastel.pdf"))
ripDat <- plot_riparian(
	gsParam = out,
	refGenome = "SollycM82_1.0.3",
	addThemes = ggthemes,
	braidAlpha = .95,
	chrFill = "lightgrey",
	minChrLen2plot = 300,
	palette = customPal,
	gids <- gids,
	forceRecalcBlocks = FALSE)
print(ripDat)
dev.off()
