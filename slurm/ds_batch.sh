#!/bin/bash
#SBATCH -J downsampling
#SBATCH -N 2
#SBATCH -t 3:00:00
#SBATCH -D /exports/sascstudent/samvank/

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2
echo "conda activated, now starting splitting"
samtools index bamData/*.bam
samtools view bamData/*.bam chr1 > bamData/perChr/chr1.bam 
echo "samtools finished"
