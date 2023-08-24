#!/bin/bash
#SBATCH -J prepare_truvari
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

prepare () {
    input=$1
    if [[ ${input: -7} = ".vcf.gz" ]] 
    then
        shortenedInput=${input:0:-7}
        vt normalize -n -r ${ref} ${input} -o ${shortenedInput}.n.vcf.gz
        vt decompose ${shortenedInput}.n.vcf.gz -o ${shortenedInput}.n.d.vcf.gz
        bcftools index -t ${shortenedInput}.n.d.vcf.gz
    elif [[ ${input: -4} = ".vcf" ]]
    then
        shortenedInput=${input:0:-4}
        vt normalize -n -r ${ref} ${input} -o ${shortenedInput}.n.vcf
        vt decompose ${shortenedInput}.n.vcf -o ${shortenedInput}.n.d.vcf
        bgzip ${shortenedInput}.n.d.vcf
        bcftools index -t ${shortenedInput}.n.d.vcf.gz
    else
        vt normalize -n -r ${ref} ${input} -o ${input}.n.vcf
        vt decompose ${input}.n.vcf -o ${input}.n.d.vcf
        bgzip ${input}.n.d.vcf
        bcftools index -t ${input}.n.d.vcf.gz
    fi
    echo -e "\nsuccesfully prepared ${input}\n\n"
}

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2

ref=/exports/sascstudent/samvank/data/refData/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta
job="preparing for truvari"
echo "conda activated, now starting ${job}"
if [[ -d $1 ]]
then 
    cd $1
    for file in $(ls)
    do 
        prepare ${file}
    done
    # dirCode here
else
    prepare $1
fi

echo "${job} finished"