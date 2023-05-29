#!/bin/bash
#SBATCH -J svim
#SBATCH -n 4
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 12:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="svim"
echo "conda activated, now starting ${job}"
svim alignment \
  workfolder/HG002/SVIM \
  data/bamData/HG002/HG002_GRCh37_ONT-UL_UCSC_20200508.phased.bam \
  data/refData/hs37.fa \
  --sequence_alleles 
mv workfolder/HG002/SVIM/variants.vcf output/HG002/SVIMFullOut/
echo "${job} finished"
