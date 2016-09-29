# R script to generate:
#   1. List of snp_ids as listed in the .vcf files which are also in the
#       snpset for HapMapCEU.
#   2. A text file with the same snp_ids as above, but with a second
#       column having the rsid of the snp.
library(dplyr)
# Load data
hapmap <- read.table('hapmapSnpsCEU.txt.gz', header = FALSE, stringsAsFactors = FALSE)
geuvadis_snps <- read.table("Phase1.Geuvadis_dbSnp137_idconvert.txt.gz", header = FALSE, stringsAsFactors = FALSE)

# rsids from hapmap are from dbSNP126, those from geuvadis are dbSNP137.
# Sources: ftp://ftp.ncbi.nlm.nih.gov/hapmap/00README.releasenotes_rel27
# http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GeuvadisRNASeqAnalysisFiles_README.txt
colnames(hapmap) <- c("bin", "chrom", "chromStart", "chromEnd", "RSID", "score", "strand", "observed", "allele1", "homoCount1", "allele2", "homoCount2", "heteroCount2")
colnames(geuvadis_snps) <- c('RSID', 'ID_from_VCF')
# Inner join for intersection of info. For these purposes, only keep
# the rsids which have remained the same. Don't worry about converting
# dbSNP126 rsids to dbSNP137.
annotation <- geuvadis_snps %>% inner_join(hapmap, by = "RSID")
write(annotation$ID_from_VCF, file = 'target_snp_ids.txt', ncol = 1)

annotation %>% select(ID_from_VCF, RSID) %>% rename(snp_id_originalVCF=ID_from_VCF, RSID_dbSNP137=RSID) %>% write.table(file = "target_snp_ids_rsids.txt", quote = FALSE)
