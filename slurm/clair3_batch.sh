#!/bin/bash
#SBATCH -J clair3-3-fast
#SBATCH -n 20
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 20:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="clair3"
echo "conda activated, now starting ${job}"
run_clair3.sh \
  --bam_fn=data/bamData/HG002/HG002_GRCh37_ONT-UL_UCSC_20200508.phased.bam \
  --ref_fn=data/refData/hs37.fa \
  --platform='ont' \
  --enable_long_indel \
  --fast_mode \
  --model_path=conda2/bin/models/ont \
  --threads=20 \
  --output=output/HG002/clair3FullOut_fast \
echo "${job} finished"
