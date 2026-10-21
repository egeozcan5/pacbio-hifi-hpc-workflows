#!/bin/bash
#SBATCH --job-name=flagstat_bams
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=logs/flagstat_bams_%j.out
#SBATCH --error=logs/flagstat_bams_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

mkdir -p qc_alignment/flagstat

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

samtools flagstat -@ 4 \
    alignment/SAMPLE_04.GRCh38.hifi.sorted.bam \
    > qc_alignment/flagstat/SAMPLE_04.flagstat.txt
status1=$?

samtools flagstat -@ 4 \
    alignment/SAMPLE_03.GRCh38.hifi.sorted.bam \
    > qc_alignment/flagstat/SAMPLE_03.flagstat.txt
status2=$?

samtools flagstat -@ 4 \
    alignment/SAMPLE_02.GRCh38.hifi.sorted.bam \
    > qc_alignment/flagstat/SAMPLE_02.flagstat.txt
status3=$?

samtools flagstat -@ 4 \
    alignment/SAMPLE_01.GRCh38.hifi.sorted.bam \
    > qc_alignment/flagstat/SAMPLE_01.flagstat.txt
status4=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status1" -ne 0 || "$status2" -ne 0 || \
      "$status3" -ne 0 || "$status4" -ne 0 ]]; then
    echo "One or more flagstat analyses failed."
    exit 1
fi

echo "All flagstat analyses completed successfully."
exit 0
