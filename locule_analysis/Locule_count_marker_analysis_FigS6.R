library(ggplot2)
library(dplyr)
library(tidyr)
library(data.table)
library(forcats)

#Load data
locule_mapping_wide <- read.table("/Users/jacksatterlee/Documents/Locule_CLV3_marker_analysis/Locule_count_CLV3_marker_analysis.txt", 
                             header = T,
                             row.names = 1)

#Convert data from wide to long format and remove NAs                           
locule_mapping_long <- gather(locule_mapping_wide, Fruit, Locule_number, Locule_count_fruit_1:Locule_count_fruit_10)

locule_mapping_long <- locule_mapping_long[complete.cases(locule_mapping_long),]
locule_mapping_long$value <- as.factor(locule_mapping_long$Locule_number)


#Count locule number classes for genotypes and generations
locule_mapping.summary <- locule_mapping_long %>%
  group_by(value, Overall_genotype) %>%
  summarise(
  n()
  )
#Re-order genotypes
genotype.order = c("Ref_parental_Ref_parental", "Del_parental_Del_parental", "Ref_A", "Ref_AB", "Ref_B", "Het_A", "Het_AB", "Het_B", "Del_A", "Del_AB", "Del_B")

#Make stacked bar with re-ordered genotypes
ggplot(locule_mapping.summary, aes(fill = value, y = factor(Overall_genotype, genotype.order), x = `n()`)) + 
  geom_bar(position="fill", stat="identity") +
  scale_fill_manual(values = c("dodgerblue4","dodgerblue3","dodgerblue2","dodgerblue","skyblue1","mintcream","lightgoldenrod1","gold","orange","orangered","red4")) +
  theme_classic() +
  theme(axis.text.x = element_text(size = 12.5), axis.text.y = element_text(size = 12.5)) 

#Get summary data
locule_mapping.summary <- locule_mapping_long %>%
  group_by(Overall_genotype) %>%
  summarise(
    n(), mean(Locule_number)
  )




