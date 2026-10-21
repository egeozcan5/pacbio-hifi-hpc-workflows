#!/bin/bash
#SBATCH --job-name=fastq_sample01
#SBATCH --partition=barbun
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --ntasks-per-node=20
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=logs/fastq_SAMPLE_01_%j.out
#SBATCH --error=logs/fastq_SAMPLE_01_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

fasterq-dump \
    sra/SAMPLE_01/SAMPLE_01.sra \
    --threads 20 \
    --outdir fastq

status1=$?

if [[ "$status1" -ne 0 ]]; then
    exit 1
fi

pigz -p 20 fastq/SAMPLE_01.fastq
status2=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status2" -ne 0 ]]; then
    exit 1
fi

exit 0

