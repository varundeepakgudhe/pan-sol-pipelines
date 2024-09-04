library(ggplot2)
library(dplyr)
library(tidyr)

loc.dat <- read.table(file = "/Users/jacksatterlee/Documents/Locule_count_mapping/Fig5_analysis/Locules_Saet_minipangenome.txt", header = T)
loc.dat.long <- gather(loc.dat, Fruit, Locule_number, Locule_count_fruit_1:Locule_count_fruit_20)

#Order bars by genotype average locule count number
loc.dat.summary <- loc.dat %>%
  group_by(Genotype) %>%
  summarise(mean = mean(Average_locule_count, na.rm = T))
loc.dat.summary <- loc.dat.summary %>% arrange(mean)
genotype.order <- as.vector(loc.dat.summary$Genotype)


ggplot(data=loc.dat.long, aes(x = Average_locule_count, y = factor(Genotype, genotype.order))) +
  geom_bar(stat="summary") +
  geom_point(aes(x = Locule_number), shape = 20, position = position_jitter(width = 0.3, height = 0.2))


#Convert locule counts from numeric to factor for class assignment
loc.dat.long$value <- as.factor(loc.dat.long$Locule_number)
loc.dat.long <- loc.dat.long[complete.cases(loc.dat.long),]

#Count number of locules in each class on a per genotype basis
loc.dat.long.summary <- loc.dat.long %>%
  group_by(Genotype, value) %>%
  summarise(
    n()
  )

#Make stacked bar plot
ggplot(loc.dat.long.summary, aes(fill = value, x = `n()`, y = factor(Genotype, genotype.order))) + 
  geom_bar(position="fill", stat="identity") +
  scale_fill_manual(values = c("midnightblue","dodgerblue4","dodgerblue3","dodgerblue2","skyblue1","mintcream","lightgoldenrod1","gold","orange","orangered","red3","darkred")) +
  theme_classic() +
  theme(axis.text.x = element_text(size = 12.5), axis.text.y = element_text(size = 12.5)) 


#Phylogenetic ordering
phylo.order <- c("ANG_1","Solanum_aethiopicum_SC103","Solanum_aethiopicum_SC102","Solanum_aethiopicum_PI_666076","Solanum_aethiopicum_PI_374695","Solanum_aethiopicum_PI_666075","Solanum_aethiopicum_PI_247828","Solanum_aethiopicum_PI_441899","Solanum_aethiopicum_PI_441895","Solanum_aethiopicum_PI_441895")

loc.dat.long.summary.phylo <- loc.dat.long.summary[loc.dat.long.summary$Genotype %in% phylo.order,]
availabe.phylo.order <- unique(phylo.order[phylo.order %in% loc.dat.long.summary.phylo$Genotype])

#Make stacked bar plot
ggplot(loc.dat.long.summary.phylo, aes(fill = value, x = `n()`, y = factor(Genotype, rev(availabe.phylo.order)))) + 
  geom_bar(position="fill", stat="identity") +
  scale_fill_manual(values = c("midnightblue","dodgerblue4","dodgerblue3","dodgerblue2","skyblue1","mintcream","lightgoldenrod1","gold","orange","orangered","red3","darkred")) +
  theme_classic() +
  theme(axis.text.x = element_text(size = 12.5), axis.text.y = element_text(size = 12.5)) 










