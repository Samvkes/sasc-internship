#!/bin/bash
#SBATCH -J prepare_truvari
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

input=$1
path=$2
ref=/exports/sascstudent/samvank/data/refData/hs37.fa
job="preparing for truvari"
echo "conda activated, now starting ${job}"

vt normalize -n -r ${ref} ${path}/${input} -o ${path}/normalized.${input}
vt decompose ${path}/normalized.${input} -o ${path}/normalized.decomposed.${input}
bgzip ${path}/normalized.decomposed.${input}
bcftools index -t ${path}/normalized.decomposed.${input}.gz

echo "${job} finished"