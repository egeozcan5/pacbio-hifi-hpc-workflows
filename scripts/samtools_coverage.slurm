#!/bin/bash
#SBATCH --job-name=samtools_coverage
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/samtools_coverage_%j.out
#SBATCH --error=logs/samtools_coverage_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

mkdir -p qc_alignment/coverage

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "------------------------------"

samtools coverage \
    -o qc_alignment/coverage/SAMPLE_04.coverage.tsv \
    alignment/SAMPLE_04.GRCh38.hifi.sorted.bam
status1=$?

samtools coverage \
    -o qc_alignment/coverage/SAMPLE_03.coverage.tsv \
    alignment/SAMPLE_03.GRCh38.hifi.sorted.bam
status2=$?

samtools coverage \
    -o qc_alignment/coverage/SAMPLE_02.coverage.tsv \
    alignment/SAMPLE_02.GRCh38.hifi.sorted.bam
status3=$?

samtools coverage \
    -o qc_alignment/coverage/SAMPLE_01.coverage.tsv \
    alignment/SAMPLE_01.GRCh38.hifi.sorted.bam
status4=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "------------------------------"

if [[ "$status1" -ne 0 || "$status2" -ne 0 || \
      "$status3" -ne 0 || "$status4" -ne 0 ]]; then
    exit 1
fi

exit 0
