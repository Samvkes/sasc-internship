#!/bin/bash
#SBATCH -J svim
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 3:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

job="svim"
echo "conda activated, now starting ${job}"
svim alignment workfolder/svim data/bamData/chr1.bam data/refData/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta
mv workfolder/svim/variants.vcf output/SVIMOut/
echo "${job} finished"
