#!/bin/bash
#SBATCH -J svim
#SBATCH -N 4
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="svim"
echo "conda activated, now starting ${job}"
svim alignment \
  workfolder/HG005/SVIM \
  data/bamData/HG005/HG005_GRCh38_ONT-UL_UCSC_20200109.phased.bam \
  data/refData/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta
mv workfolder/svim/variants.vcf output/SVIMFullOut/
echo "${job} finished"
