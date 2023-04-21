#!/bin/bash
#SBATCH -J claire3
#SBATCH -N 4
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 90:00:00
#SBATCH -D /exports/sascstudent/samvank
#SBATCH --mem-per-cpu 20G

PLATFORM='ont'
OUTPUT_DIR="output/HG005/clair3Next/"


BAM="data/bamData/HG005/HG005_GRCh38_ONT-UL_UCSC_20200109.phased.bam"
REF="data/refData/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta"


THREADS=4

run_clair3.sh \
  --bam_fn=${BAM} \
  --ref_fn=${REF} \
  --threads=${THREADS} \
  --platform=${PLATFORM} \
  --model_path="conda2/bin/models/ont" \
  --output=${OUTPUT_DIR} 
  
