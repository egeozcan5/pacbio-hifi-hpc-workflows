#!/bin/bash
#SBATCH --job-name=index_GRCh38
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --output=logs/index_GRCh38_%j.out
#SBATCH --error=logs/index_GRCh38_%j.err

module purge
module load miniconda3

conda activate pacbio_ref
cd "$SLURM_SUBMIT_DIR"

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

pbmm2 index \
    reference/human_GRCh38_no_alt_analysis_set/human_GRCh38_no_alt_analysis_set.fasta \
    reference/human_GRCh38_no_alt_analysis_set/human_GRCh38_no_alt_analysis_set.hifi.mmi \
    --preset HIFI \
    --num-threads 8

status=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status" -ne 0 ]]; then
    exit 1
fi

exit 0
