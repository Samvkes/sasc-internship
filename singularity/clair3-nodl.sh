#!/bin/bash
#SBATCH -J claire3
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank
#SBATCH --mem-per-cpu 20G
#SBATCH -n 4

PLATFORM='ont'
INPUT_DIR="/exports/sascstudent/samvank/singularityTest/clair3_ont_quickDemo"
OUTPUT_DIR="${INPUT_DIR}/output"


REF="GRCh38_no_alt_chr20.fa"
BAM="HG003_chr20_demo.bam"

CONTIGS="chr20"
START_POS=100000
END_POS=300000
echo -e "${CONTIGS}\t${START_POS}\t${END_POS}" > ${INPUT_DIR}/quick_demo.bed

THREADS=4


module load container/singularity/3.11.1
# Run Clair3 using one command
singularity pull docker://hkubal/clair3:latest

# run clair3 like this afterward
singularity exec clair3_latest.sif \
  /opt/bin/run_clair3.sh \
  --bam_fn=${INPUT_DIR}/${BAM} \
  --ref_fn=${INPUT_DIR}/${REF} \
  --threads=${THREADS} \
  --platform=${PLATFORM} \
  --model_path="/opt/models/${PLATFORM}" \
  --output=${OUTPUT_DIR} \
  --bed_fn=${INPUT_DIR}/quick_demo.bed
