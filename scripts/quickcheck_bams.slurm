#!/bin/bash
#SBATCH --job-name=quickcheck_bams
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --output=logs/quickcheck_bams_%j.out
#SBATCH --error=logs/quickcheck_bams_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

samtools quickcheck -v \
    alignment/SAMPLE_04.GRCh38.hifi.sorted.bam \
    alignment/SAMPLE_03.GRCh38.hifi.sorted.bam \
    alignment/SAMPLE_02.GRCh38.hifi.sorted.bam \
    alignment/SAMPLE_01.GRCh38.hifi.sorted.bam

status=$?

if [[ "$status" -eq 0 ]]; then
    echo "All BAM files passed samtools quickcheck."
else
    echo "One or more BAM files failed samtools quickcheck."
fi

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

exit "$status"
