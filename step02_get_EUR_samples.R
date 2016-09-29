# R script to find the list of Eurpean individuals within the gEUVADIS.

library(gdata)
# Read in sample data from 1000genomes and ID numbers from gEUVADIS.
TG <- read.xls("20130606_sample_info.xlsx", header = TRUE, sheet = "Sample Info", stringsAsFactors = FALSE)
GEU_samples <- read.table("GEUVADIS_samples.txt", header = FALSE, stringsAsFactors = FALSE)
# Subset 1000genomes samples to European Populations of interest.
EUR_samples <- TG$Sample[TG$Population == 'CEU' | TG$Population == 'TSI' | TG$Population == 'GBR' | TG$Population == 'FIN']
# Find European samples in GEUVADIS.
samples <- intersect(GEU_samples$V1, EUR_samples)
# Write to file.
write(samples, file = 'EUR_samples.txt', ncol = 1)
