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
ref=/exports/sascstudent/samvank/data/refData/hs37.fa
job="preparing for truvari"
echo "conda activated, now starting ${job}"

if [[ ${input: -7} = ".vcf.gz" ]] 
then
    shortenedInput=${input:0:-7}
    vt normalize -n -r ${ref} ${input} -o ${shortenedInput}.normalized.vcf.gz
    vt decompose ${shortenedInput}.normalized.vcf.gz -o ${shortenedInput}.normalized.decomposed.vcf.gz
    #bgzip ${path}/normalized.decomposed.${input}
    bcftools index -t ${shortenedInput}.normalized.decomposed.vcf.gz
elif [[ ${input: -4} = ".vcf" ]]
then
    shortenedInput=${input:0:-4}
    vt normalize -n -r ${ref} ${input} -o ${shortenedInput}.normalized.vcf
    vt decompose ${shortenedInput}.normalized.vcf -o ${shortenedInput}.normalized.decomposed.vcf
    bgzip ${shortenedInput}.normalized.decomposed.vcf
    bcftools index -t ${shortenedInput}.normalized.decomposed.vcf.gz
else
    vt normalize -n -r ${ref} ${input} -o ${input}.normalized.vcf
    vt decompose ${input}.normalized.vcf -o ${input}.normalized.decomposed.vcf
    bgzip ${input}.normalized.decomposed.vcf
    bcftools index -t ${input}.normalized.decomposed.vcf.gz
fi


echo "${job} finished"