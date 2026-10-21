#!/bin/bash
#SBATCH --job-name=align_sample01
#SBATCH --partition=barbun
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --ntasks-per-node=20
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=logs/align_SAMPLE_01_%j.out
#SBATCH --error=logs/align_SAMPLE_01_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

mkdir -p alignment/tmp/SAMPLE_01
export TMPDIR="$SLURM_SUBMIT_DIR/alignment/tmp/SAMPLE_01"

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

pbmm2 align \
    reference/human_GRCh38_no_alt_analysis_set/human_GRCh38_no_alt_analysis_set.hifi.mmi \
    fastq/SAMPLE_01.fastq.gz \
    alignment/SAMPLE_01.GRCh38.hifi.sorted.bam \
    --preset HIFI \
    --sort \
    --bam-index BAI \
    --rg '@RG\tID:SAMPLE_01\tSM:SAMPLE_01\tPL:PACBIO' \
    -j 16 \
    -J 4

status=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status" -ne 0 ]]; then
    exit 1
fi

exit 0
