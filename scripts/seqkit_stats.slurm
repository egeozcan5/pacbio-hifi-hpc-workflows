#!/bin/bash
#SBATCH --job-name=seqkit_stats
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/seqkit_stats_%j.out
#SBATCH --error=logs/seqkit_stats_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

seqkit stats \
    -a \
    -T \
    -j 4 \
    fastq/SAMPLE_04.fastq.gz \
    fastq/SAMPLE_03.fastq.gz \
    fastq/SAMPLE_02.fastq.gz \
    fastq/SAMPLE_01.fastq.gz \
    > qc_raw/seqkit_stats.tsv

status=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status" -ne 0 ]]; then
    exit 1
fi

exit 0
