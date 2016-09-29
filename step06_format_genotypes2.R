# Script to turn 012 encoded genotype file, and output a genotype matrix
# file with sampleIDs as header and snps as rows.  First column is 
# variantID for snp.  Also, this script creates a snp annotation file
# which includes things like rsid label for the snp.
#
# This script requires a lot of RAM and takes a lot of time, so beware.

library(dplyr)
# Read in Genotype.
GT <- read.table("GEUVADIS_EUR_hapmapCEU_MAF01_012.txt", stringsAsFactors = F, header = T)
# For future purposes, want the sample ids sorted.
GT <- GT[,c("Chr","Pos","Ref_b37","Alt","snp_id",sort(colnames(GT)[c(-1,-2,-3,-4,-5)]))]
# Create variant_id column.
rownames(GT) <- paste(GT$Chr, GT$Pos, GT$Ref_b37, GT$Alt, 'b37', sep = '_')
# Write header to file, because want 'Id' as column name for rownames.
hdr <- paste(c("Id", colnames(GT)[c(-1,-2,-3,-4,-5)]), collapse = '\t')
cat(hdr, '\n', sep='', file = 'geuvadis.snps.txt')
# Convert to matrix for fast writing to file.
GT_mat <- data.matrix(GT[,c(-1,-2,-3,-4,-5)], rownames.force = TRUE)
write.table(GT_mat, file = 'geuvadis.snps.txt', row.names = TRUE, quote = FALSE, sep = '\t', col.names = FALSE, append=TRUE)
# Free some memory.
rm(GT_mat)
gc()
# Make data frame for snp annotation
annot <- data.frame(Chr=GT$Chr,Pos=GT$Pos,VariantID=rownames(GT),Ref_b37=GT$Ref_b37,Alt=GT$Alt,snp_id_originalVCF=GT$snp_id, stringsAsFactors = F)
rm(GT)
gc()
target_snps <- read.table("target_snp_ids_rsids.txt", stringsAsFactors = F, header = T)
# Get rsids from dbsnp137 in annotation dataframe.
annot <- annot %>% inner_join(target_snps, by = 'snp_id_originalVCF')
# Original VCF files were biallelic
annot$Num_alt_per_site <- 1
write.table(annot, file = "geuvadis.annot.txt", quote = FALSE, row.names = FALSE, sep = '\t')
