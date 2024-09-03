library(ggplot2)
library(dplyr)
library(tidyr)
library(data.table)
library(forcats)
library(multcomp)
library(PMCMRplus)

setwd("/Users/ahendelm/Team-Dropbox/CSHL Dropbox Team Dropbox/Anat Hendelman/CSHL-dropbox/pansol/Conservatory/Jul2024/stat")


getstat<-function(dataset){
  
  dat.test.aov <-aov(Locule_number ~ Genotype, data = dataset)
  summary(glht(model = dat.test.aov, linfct=mcp(Genotype="Dunnett")))
  anova(dat.test.aov)
  res <- dunnettT3Test(dat.test.aov)
  summary(res)
  summaryGroup(res)
  
}

#Fig. S6 - clv3 locule numbers 
locule_mapping_wide <- read.table("Locule_count_CLV3_marker_analysis.txt", header = T,row.names = 1)

#Convert data from wide to long format and remove NAs                           
locule_mapping_long <- gather(locule_mapping_wide, Fruit, Locule_number, Locule_count_fruit_1:Locule_count_fruit_10)

locule_mapping_long <- locule_mapping_long[complete.cases(locule_mapping_long),]
genotype.order = c("Ref_parental_Ref_parental", "Del_parental_Del_parental", "Ref_A", "Ref_AB", "Ref_B", "Het_A", "Het_AB", "Het_B", "Del_A", "Del_AB", "Del_B")

locule_mapping_long$Overall_genotype<-factor(locule_mapping_long$Overall_genotype,levels = genotype.order)
colnames(locule_mapping_long)<-c("Average_Locules","Collection","PCR_reaction","PCR_result_CLV3","PCR_result_chr5","Genotype","Fruit","Locule_number")
getstat(locule_mapping_long)
str(locule_mapping_long)

#Fig. 6C - African eggplant accessions
loc.dat <- read.table(file = "Locules_Saet_minipangenome.txt", header = T)
loc.dat.long <- gather(loc.dat, Fruit, Locule_number, Locule_count_fruit_1:Locule_count_fruit_20)
loc.dat.long <- loc.dat.long[complete.cases(loc.dat.long),]
#phylo.order <- c("ANG_1","Solanum_aethiopicum_SC103","Solanum_aethiopicum_SC102","Solanum_aethiopicum_PI_666076","Solanum_aethiopicum_PI_374695","Solanum_aethiopicum_PI_666075","Solanum_aethiopicum_PI_247828","Solanum_aethiopicum_PI_441899","Solanum_aethiopicum_PI_441895","Solanum_aethiopicum_PI_441895")
phylo.order <- c("ANG_1","Solanum_aethiopicum_PI_424860","Solanum_aethiopicum_PI_441899","Solanum_aethiopicum_PI_247828","Solanum_aethiopicum_SC103","Solanum_aethiopicum_PI_666075","Solanum_aethiopicum_PI_666076","Solanum_aethiopicum_PI_666078","Solanum_aethiopicum_SC102")

loc.dat.long<-subset(loc.dat.long,Genotype %in% phylo.order)
loc.dat.long$Genotype<-factor(loc.dat.long$Genotype, levels = phylo.order)

getstat(loc.dat.long)


#Fig. 6d - carboxilaze mutants

loc.carb.dat <- read.table(file = "Uplands_2024_carboxypeptidase_phenotyping.txt", header = T)
loc.dat.long <- gather(loc.carb.dat, Fruit, Locule_number, Locules_fruit_1:Locules_fruit_10)
loc.dat.long <- loc.dat.long[complete.cases(loc.dat.long),]
str(loc.dat.long)
slyc.order<-c("Slyc_M82_WT","Slyc_M82_scpl25l")
spri.order<-c("Spri_WT","Spr_scpl25l")

loc.dat.long.carb.slyc<-subset(loc.dat.long,Genotype%in%slyc.order)
loc.dat.long.carb.spri<-subset(loc.dat.long,Genotype%in%spri.order)
loc.dat.long.carb.spri$Genotype<-factor(loc.dat.long.carb.spri$Genotype,levels = spri.order)
loc.dat.long.carb.slyc$Genotype<-factor(loc.dat.long.carb.slyc$Genotype,levels = slyc.order)

getstat(loc.dat.long.carb.spri)
getstat(loc.dat.long.carb.slyc)


#Fig.4
loc.dat <- fread(file = "Locule_data_Sprino_up.csv", header = T)
colnames(loc.dat)<-c("PlantNumber" ,"FruitNumber","Locule_number","Genotype","Year")

table(loc.dat$Genotype)
table(loc.dat$Year)

genotype.order <- c("WT","clv3a","clv3b","clv3a/clv3b")
loc.dat$Genotype<-factor(loc.dat$Genotype,levels = genotype.order)

getstat(loc.dat[(Genotype %in% c("WT","clv3a","clv3b") & Year==2024) | Genotype =="clv3a/clv3b",])



