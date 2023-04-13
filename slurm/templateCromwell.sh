#!/bin/bash
#SBATCH -J cromwell-name
#SBATCH -N 1
#SBATCH -o /exports/sascstudent/samvank/logs/slurm-%j-%x.out
#SBATCH -t 24:00:00
#SBATCH -D /exports/sascstudent/samvank/
#SBATCH --mem-per-cpu 20G

echo "activating conda"
source /share/software/tools/miniconda/3.7/4.7.12/etc/profile.d/conda.sh
conda activate /exports/sascstudent/samvank/conda2
job="wdlName"
echo "conda activated, now starting cromwell"
cromwell run scripts/wdl/${job}.wdl -i scripts/wdl/json-inputs/${job}.json
echo "cromwell finished"
