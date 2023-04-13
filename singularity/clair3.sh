# Parameters
PLATFORM='ont'
INPUT_DIR="/exports/sascstudent/samvank/singularityTest/clair3_ont_quickDemo"
OUTPUT_DIR="${INPUT_DIR}/output"

mkdir -p ${INPUT_DIR}
mkdir -p ${OUTPUT_DIR}

# Download quick demo data
# GRCh38_no_alt reference
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/ont/GRCh38_no_alt_chr20.fa
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/ont/GRCh38_no_alt_chr20.fa.fai
# BAM chr20:100000-300000
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/ont/HG003_chr20_demo.bam
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/ont/HG003_chr20_demo.bam.bai
# GIAB Truth VCF and BED
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/ont/HG003_GRCh38_chr20_v4.2.1_benchmark.vcf.gz
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/ont/HG003_GRCh38_chr20_v4.2.1_benchmark.vcf.gz.tbi
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/ont/HG003_GRCh38_chr20_v4.2.1_benchmark_noinconsistent.bed

REF="GRCh38_no_alt_chr20.fa"
BAM="HG003_chr20_demo.bam"
BASELINE_VCF_FILE_PATH="HG003_GRCh38_chr20_v4.2.1_benchmark.vcf.gz"
BASELINE_BED_FILE_PATH="HG003_GRCh38_chr20_v4.2.1_benchmark_noinconsistent.bed"
OUTPUT_VCF_FILE_PATH="merge_output.vcf.gz"

CONTIGS="chr20"
START_POS=100000
END_POS=300000
echo -e "${CONTIGS}\t${START_POS}\t${END_POS}" > ${INPUT_DIR}/quick_demo.bed

THREADS=4

cd ${OUTPUT_DIR}

module load container/singularity/3.10.4
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
