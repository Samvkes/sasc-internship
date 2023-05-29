#!/bin/bash
#SBATCH -J clair3-3-fast
#SBATCH -n 5
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 20:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="bamstats"
echo "conda activated, now starting ${job}"
samtools stats data/bamData/HG002/HG002_GRCh37_ONT-UL_UCSC_20200508.phased.bam > HG002_grch37.stats
echo "${job} finished"
