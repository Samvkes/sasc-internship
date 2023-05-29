#!/bin/bash
#SBATCH -J sniffles
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 12:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="sniffles"
echo "conda activated, now starting ${job}"
sniffles \
  -i data/bamData/HG002/HG002_GRCh37_ONT-UL_UCSC_20200508.phased.bam \
  --reference data/refData/hs37.fa \
  -v output/HG002/snifflesFullOut/snifflesFullOut2.vcf \
  --allow-overwrite
echo "${job} finished"
