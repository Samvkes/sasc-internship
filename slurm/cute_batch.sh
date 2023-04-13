#!/bin/bash
#SBATCH -J cutesv
#SBATCH -N 4
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu=30G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2
echo "conda activated, now starting calling"
cuteSV \
 --max_cluster_bias_INS 100 \
 --diff_ratio_merging_INS 0.3 \
 --max_cluster_bias_DEL 100 \
 --diff_ratio_merging_DEL 0.3 \
 data/bamData/HG005/HG005_GRCh38_ONT-UL_UCSC_20200109.phased.bam \
 data/refData/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta \
 output/HG005/cuteSVFullOut/cuteFullOut.vcf \
 workfolder/HG005/cuteSV 
echo "cutesv finished"
