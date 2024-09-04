library(ggplot2)
library(dplyr)
library(tidyr)

loc.dat <- read.table(file = "/Users/jacksatterlee/CSHL Dropbox Team Dropbox/James Satterlee/Jack/Solanum_CLV3/Carboxypeptidase/Uplands_2024_carboxypeptidase_phenotyping.txt", header = T)
loc.dat.long <- gather(loc.dat, Fruit, Locule_number, Locules_fruit_1:Locules_fruit_10)

#Convert locule counts from numeric to factor for class assignment
loc.dat.long$value <- as.factor(loc.dat.long$Locule_number)
loc.dat.long <- loc.dat.long[complete.cases(loc.dat.long),]

# #Count number of locules in each class on a per genotype basis and get mean
# loc.dat.long.summary <- loc.dat.long %>%
#   group_by(Genotype) %>%
#   summarise(
#     mean = mean(Locule_number), n = n()
#   )
#Count number of locules in each class on a per genotype basis
loc.dat.long.summary <- loc.dat.long %>%
  group_by(Genotype, value) %>%
  summarise(
    n()
  )
#Make stacked bar plot (fewer colors)
ggplot(loc.dat.long.summary, aes(fill = value, x = `n()`, y = factor(Genotype))) + 
  geom_bar(position="fill", stat="identity") +
  scale_fill_manual(values = c("dodgerblue4","dodgerblue4","dodgerblue2","dodgerblue2","lightgoldenrod1","lightgoldenrod1","orange")) +
  theme_classic() +
  theme(axis.text.x = element_text(size = 12.5), axis.text.y = element_text(size = 12.5)) 








