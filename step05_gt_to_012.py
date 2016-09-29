#!/usr/bin/env python

'''
This script will take the output files from step04_format_genotypes1.sh
and recode genotype data from 0|0 (vcf format) to 012 format, where the
number indicates the dosage of the Alt allele.

This will also drop any snps which have missing data.
'''
import re

gt_pattern = re.compile("[/|]")

def recode_gt(x):
    # Recodes a string x, which is in format "0\1", or something like
    # it, and returns a string of 0,1,2, which the sum of the numbers.
    #
    # Works by substituting the middle character with a +, and then
    # evaluating the string as a python expression.
    return str(eval(re.sub(gt_pattern, "+", x)))

def recode_line(line):
    # Reformats a single line from input genotype format to desired
    # output format.
    l = line.strip().split()
    l = l[:5] + map(recode_gt, l[5:])
    return '\t'.join(l) + '\n'

gt_files = [
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr1.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr2.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr3.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr4.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr5.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr6.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr7.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr8.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr9.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr10.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr11.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr12.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr13.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr14.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr15.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr16.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr17.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr18.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr19.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr20.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr21.txt",
    "GEUVADIS_EUR_hapmapCEU_MAF01_chr22.txt"
    ]

OUT = "GEUVADIS_EUR_hapmapCEU_MAF01_012.txt"
missing_pattern = re.compile(r'\t\.')
with open(OUT, 'w') as out:
    # Write header for file. Must get sample ids.
    with open("EUR_samples.txt", 'r') as samples_f:
        samples = map(lambda x: x[:-1], list(samples_f))
    header = ["Chr", "Pos", "Ref_b37", "Alt", "snp_id"] + samples
    out.write('\t'.join(header) + '\n')
    for gt_file in gt_files:
        print gt_file
        with open(gt_file, 'r') as gt:
            for line in gt:
                # Skip row with missing data.
                if missing_pattern.search(line):
                    continue
                out.write(recode_line(line))
