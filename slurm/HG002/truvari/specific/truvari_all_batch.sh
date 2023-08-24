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

job="truvari"
echo "conda activated, now starting ${job}"
rm -r -f output/truvariOut/clair3
truvari bench \
  -b output/HG005/clair3FullOut/merge_output.vcf.gz \
  -c data/vcfData/HG005/HG005_GRCh38_1_22_v4.2.1_benchmark.vcf.gz \
  -o output/HG005/truvariOut/clair3

rm -r -f output/truvariOut/sniffles
truvari bench \
  -b output/HG005/snifflesFullOut/ #FIXME \
  -c data/vcfData/HG005/HG005_GRCh38_1_22_v4.2.1_benchmark.vcf.gz \
  -o output/HG005/truvariOut/sniffles

rm -r -f output/truvariOut/SVIM
truvari bench \
  -b output/HG005/SVIMFullOut/ #FIXME \
  -c data/vcfData/HG005/HG005_GRCh38_1_22_v4.2.1_benchmark.vcf.gz \
  -o output/HG005/truvariOut/SVIM

rm -r -f output/truvariOut/cuteSV
truvari bench \
  -b output/HG005/cuteSVFullOut/ #FIXME \
  -c data/vcfData/HG005/HG005_GRCh38_1_22_v4.2.1_benchmark.vcf.gz \
  -o output/HG005/truvariOut/cuteSV

echo "${job} finished"
