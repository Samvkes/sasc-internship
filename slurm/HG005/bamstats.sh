#!/bin/bash
#SBATCH -J bamstats
#SBATCH -n 8
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 20:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="bamstats-HG005"
echo "conda activated, now starting ${job}"
samtools stats data/bamData/HG005/HG005_GRCh38_ONT-UL_UCSC_20200109.phased.bam > HG005_grch38.stats
echo "${job} finished"
