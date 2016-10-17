This repository contains scripts for downloading and formatting gEUVADIS
genotype data so it can be used for PredictDB's pipeline
(https://github.com/hakyimlab/PredictDBPipeline).  The files themselves
are very large (size of all files after downloading and processing
is about 60GB), and the software requires a large amount of RAM, so
beware.  Mainly including this on github for reproducibility purposes
and if scripts need to be adapted for other data sets.

### Dependencies

- R with packages dplyr and gdata
- python 2.7

### Directions

All parameters are set, so just cd into the directory and run:
```
./step01_download_files.sh
Rscript step02_get_EUR_samples.R
Rscript step03_get_target_snps.R
./step04_format_genotypes1.sh
python step05_gt_012.py
Rscript step06_format_genotypes2.R
```

Many of these scripts will take a long time to run so use nohup.
