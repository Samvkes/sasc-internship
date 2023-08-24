#!/bin/bash
#SBATCH -J cutesv
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 3:00:00
#SBATCH -D /exports/sascstudent/samvank/

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2
echo "conda activated, now starting calling"
time cuteSV --max_cluster_bias_INS 100 --diff_ratio_merging_INS 0.3 --max_cluster_bias_DEL 100 --diff_ratio_merging_DEL 0.3 bamData/chr1.bam refData/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta cuteOut.vcf cuteWork/ 
echo "cutesv finished"
