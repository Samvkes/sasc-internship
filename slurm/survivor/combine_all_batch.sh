#!/bin/bash
#SBATCH -J SURVIVOR
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="SUVIVOR"
echo "conda activated, now starting ${job}"

rm -r -f output/SURIVOROut/

# (params for SURVIVOR merge)
# File with VCF names and paths
# max distance between breakpoints (0-1 percent of length, 1- number of bp)
# Minimum number of supporting caller
# Take the type into account (1==yes, else no)
# Take the strands of SVs into account (1==yes, else no)
# Estimate distance based on the size of SV (1==yes, else no).
# Minimum size of SVs to be taken into account.
# Output VCF filename

SURVIVOR merge \
  scripts/slurm/SURVIVOR/vcfFiles \
  0.1 \
  2 \
  1 \
  1 \
  0 \
  30 \
  output/SURVIVOROut/all_merged.vcf
echo "${job} finished"
