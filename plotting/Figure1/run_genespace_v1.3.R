library("optparse")
library("GENESPACE")
library("RColorBrewer")
library("ggthemes")

ggthemes <- ggplot2::theme(
  panel.background = ggplot2::element_rect(fill = "white")) ##This line is to set the background of the panel to white color.




###############################################
# -- change paths to those valid on your system
genomeRepo <- "/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V14/rawGenomes" #path to the genome repo where the raw data is stored, but this is not used in this script.
wd <- "/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V15_JUNE/"               # Working directory, i.e directory to store the results in.
path2mcscanx <- "/grid/lippman/data/pansol/sources/MCScanX/"                         # Path to MCScanX software.
###############################################

# -- download raw data from NCBI for human and chicken genomes
#dir.create(genomeRepo)
#rawFiles <- download_exampleData(filepath = genomeRepo)

gids<-c("Solang8_1.1.3","Solaet3_1.5.3","Solvio1_1.1.3","Sollin1_1.2.3","Solins1_1.1.3",
	"Solmac3_1.5.3","Solgig1_1.2.3","Solpri1_1.3.3","Solcle2_1.2.3","Soltor1_1.1.3",
	"Solcit1_1.1.3","Solqui2_1.3.3","Solcan1_1.1.3","Solpse1_1.1.3","Solstr1_1.1.3",
	"Solmam1_1.1.3","Solrob1_1.2.3","Solhav1_1.2.3","Solabu2_1.1.3","Solame3_1.1.3",
	"Solmur2hap1_1.3.3","Soletu1_1.2.3","SollycM82_1.0.3")      ### A list of genome identifiers for different Solanum (tomato and relatives) species.
									### These IDs correspond to genome versions used in the analysis.

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
  rawOrthofinderDir = "/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V15_JUNE/orthofinder", ###Directory containing OrthoFinder results, which are used to detect gene orthologs across species.
  path2mcscanx = path2mcscanx) 
#gpar$paths$rawOrthofinder <- "orthofinder"
# -- accomplish the run
?run_genespace
out <- run_genespace(gpar) ###Executes the GENESPACE pipeline. Out stores the processed synteny data, which will be used for visualization.

customPal <- colorRampPalette(c("#F4F1BE","#F4F1BE","#FFDEC2","#FFBDC1","#F4B3E8","#BFA3EB",
				"#92BCF7","#81D7F3","#7FEBF5","#85F4DC","#98FBA3",
				"#A5F3A9","#58D095")) ###Creates a custom color gradient.

			      #c("#FBF8CB","#FDE4CE","#FFCFD2","#F1C0E8","#CFBAF0",
				#"#A3C4F3","#90DBF4","#8DECF5","#98F5E1","#B9FCC0",
				#"#B0F2B3","#73C69D")) 

#rev_gids <- rev(gids)
pdf(file.path("/grid/lippman/data/pansol/tmp_genespace_kj/GENESPACE_V15_JUNE/pangenome_ripariani_order.pastel.pdf")) ##This opens a PDF file where the plot will be saved.
ripDat <- plot_riparian(  #This function creates the macrosynteny plot.
	gsParam = out,   #Uses the GENESPACE output (out) to plot synteny.
	refGenome = "SollycM82_1.0.3",  #reference genome
	addThemes = ggthemes, #Applies the ggplot2 theme for styling.
	braidAlpha = .95, #Adjusts transparency of the braided synteny connections.
	chrFill = "lightgrey", #Chromosomes are filled with a light grey color.
	minChrLen2plot = 300, #Excludes very small chromosomes.
	palette = customPal, #Uses the custom color palette for chromosome coloring.
	gids <- gids, # Plots all species in the gids list.
	forceRecalcBlocks = FALSE) #Prevents unnecessary recalculations of synteny blocks.
print(ripDat) #Displays the synteny plot. 
dev.off() #Closes the PDF file and saves the final plot.
