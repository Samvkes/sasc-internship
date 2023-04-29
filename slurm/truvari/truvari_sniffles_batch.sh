#!/bin/bash
#SBATCH -J truvari_clair3
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

input=/exports/sascstudent/samvank/output/HG005/snifflesFullOut/normalized.decomposed.snifflesFullOut2.vcf.gz
benchmark=/exports/sascstudent/samvank/data/vcfData/HG005/varianten/all.decom.norm.vcf.gz

job="truvari"
echo "conda activated, now starting ${job}"
outputType="sniffles"
rm -r -f output/HG005/truvariOut/${outputType}

truvari bench \
  -c ${input} \
  -b ${benchmark} \
  -o output/HG005/truvariOut/${outputType}
echo "${job} finished"
