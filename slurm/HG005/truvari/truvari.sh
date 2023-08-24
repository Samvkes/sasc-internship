#!/bin/bash
#SBATCH -J truvari
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

input=$1
benchmark=/exports/sascstudent/samvank/data/vcfData/HG005/HG005_GRCh38_1_22_v4_all.n.d.vcf.gz
# benchmark=/exports/sascstudent/samvank/data/vcfData/HG005/HG005_GRCh38_1_22_v4.2.1_benchmark.n.d.vcf.gz

outputType=$2
echo "conda activated, now starting ${outputType}"
rm -r -f output/HG005/truvariOut/${outputType}


truvari bench \
  -c output/HG005/SURVIVOROut/${input} \
  -b ${benchmark} \
  -o output/HG005/truvariOut/${outputType}
  --passonly
  # --includebed /exports/sascstudent/samvank/data/vcfData/HG002/HG002_SVs_Tier1_v0.6.bed 
echo "${outputType} finished"
