library(ggplot2)
library(gridExtra)

sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1276_n29_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

plots <- list()

for (i in 1:length(chromosome)) {
sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
  geom_line(aes(y=-delta_index), size = 1, color = "red") +
  geom_line(aes(y=0)) +
  geom_line(aes(y=p99), size = 1, color = "black") +
  geom_line(aes(y=p99_lower), size = 1, color = "black") +
  geom_line(aes(y=p95), size = 1, color = "grey") +
  geom_line(aes(y=p95_lower), size = 1, color = "grey") +
  ylim(-1,1) +
  theme_classic() +
  xlab("Position (Mb)") +
  ylab("delta SNP index") + 
  ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plots.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)


sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1276_n15_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plots2.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)

sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1265_n27_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plot_1265_n27.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)

sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1265_n15_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plot_1265_n15.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)

sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1277_n28_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plot_1277_n28.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)

sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1277_n15_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plot_1277_n15.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)

sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1269_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plot_1269.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)

sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1277_n28_parentBref_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

plots <- list()

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plots.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)


sliding_window <- read.table(file = "~/Documents/Locule_count_mapping/QTLSEQ_1269_parentBref_outs/40_qtlseq/sliding_window.tsv")
colnames(sliding_window) <- c("chrom","posi","p99","p95","index1","index2","delta_index")
sliding_window$p99_lower <- -(sliding_window$p99)
sliding_window$p95_lower <- -(sliding_window$p95)
sliding_window$posi_mb <- sliding_window$posi/1E6

chromosome = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12")

plots <- list()

for (i in 1:length(chromosome)) {
  sliding_window_subset <- sliding_window[sliding_window$chrom == chromosome[i],]
  plots[[i]] <- ggplot(data = sliding_window_subset, aes(x=posi_mb)) +
    geom_line(aes(y=-delta_index), size = 1, color = "red") +
    geom_line(aes(y=0)) +
    geom_line(aes(y=p99), size = 1, color = "black") +
    geom_line(aes(y=p99_lower), size = 1, color = "black") +
    geom_line(aes(y=p95), size = 1, color = "grey") +
    geom_line(aes(y=p95_lower), size = 1, color = "grey") +
    ylim(-1,1) +
    theme_classic() +
    xlab("Position (Mb)") +
    ylab("delta SNP index") + 
    ggtitle(chromosome[i])
}

ggsave(
  filename = "~/Desktop/plots.pdf", 
  plot = marrangeGrob(plots, nrow=2, ncol=6), 
  width = 20, height = 7.5
)




















