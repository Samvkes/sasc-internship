#!/bin/bash
#SBATCH -J clair3
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 3:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="clair3"
echo "conda activated, now starting ${job}"
run_clair3.sh \
  --bam_fn=data/bamData/chr1.bam \
  --ref_fn=data/refData/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta \
  --platform='ont' \
  --model_path=conda2/bin/models/ont \
  --threads=1 \
  --output=output/clair3Out \
  --bed_fn=data/bedData/short.bed
echo "${job} finished"
