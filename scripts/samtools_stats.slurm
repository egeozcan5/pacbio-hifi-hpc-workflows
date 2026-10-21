#!/bin/bash
#SBATCH --job-name=samtools_stats
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/samtools_stats_%j.out
#SBATCH --error=logs/samtools_stats_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

mkdir -p qc_alignment/stats

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

samtools stats -@ 4 \
    alignment/SAMPLE_04.GRCh38.hifi.sorted.bam \
    > qc_alignment/stats/SAMPLE_04.stats.txt
status1=$?

samtools stats -@ 4 \
    alignment/SAMPLE_03.GRCh38.hifi.sorted.bam \
    > qc_alignment/stats/SAMPLE_03.stats.txt
status2=$?

samtools stats -@ 4 \
    alignment/SAMPLE_02.GRCh38.hifi.sorted.bam \
    > qc_alignment/stats/SAMPLE_02.stats.txt
status3=$?

samtools stats -@ 4 \
    alignment/SAMPLE_01.GRCh38.hifi.sorted.bam \
    > qc_alignment/stats/SAMPLE_01.stats.txt
status4=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status1" -ne 0 || "$status2" -ne 0 || \
      "$status3" -ne 0 || "$status4" -ne 0 ]]; then
    echo "One or more samtools stats analyses failed."
    exit 1
fi

echo "All samtools stats analyses completed successfully."
exit 0
