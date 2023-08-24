#!/bin/bash
#SBATCH -J truvari_cuteSV
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="truvari"
echo "conda activated, now starting ${job}"
outputType="cuteSV"
rm -r -f output/HG005/truvariOut/${outputType}
truvari bench \
  -c output/HG005/cuteSVFullOut/decomposed.vcf.gz \
  -b data/vcfData/HG005/varianten/all.decom.norm.vcf.gz \
  -o output/HG005/truvariOut/${outputType} \
  --refdist=1000 \
  --typeignore
echo "${job} finished"
