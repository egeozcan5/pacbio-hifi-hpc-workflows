#!/bin/bash
#SBATCH --job-name=nplot_sample01
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/nanoplot_SAMPLE_01_%j.out
#SBATCH --error=logs/nanoplot_SAMPLE_01_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

NanoPlot \
    --fastq fastq/SAMPLE_01.fastq.gz \
    --threads 4 \
    --outdir qc_raw/nanoplot/SAMPLE_01 \
    --prefix SAMPLE_01_ \
    --plots dot \
    --N50 \
    --tsv_stats

status=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status" -ne 0 ]]; then
    exit 1
fi

exit 0
