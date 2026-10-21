#!/bin/bash
#SBATCH --job-name=download_new4
#SBATCH --partition=barbun
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --output=logs/download_new4_%j.out
#SBATCH --error=logs/download_new4_%j.err

module purge
module load miniconda3

conda activate pacbio_ref

cd "$SLURM_SUBMIT_DIR"

echo "Start time:"
date "+%H:%M:%S %d/%m/%Y"

# Sample 1
prefetch --max-size u \
    --output-directory sra \
    PUBLIC_RUN_01 &
pid1=$!

# Sample 2
prefetch --max-size u \
    --output-directory sra \
    PUBLIC_RUN_02 &
pid2=$!

wait "$pid1"
status1=$?

wait "$pid2"
status2=$?

if [[ "$status1" -ne 0 || "$status2" -ne 0 ]]; then
    echo "Samples 1 and 2 download failed"
    exit 1
fi

# Sample 3
prefetch --max-size u \
    --output-directory sra \
    PUBLIC_RUN_03 &
pid3=$!

# Sample 4
prefetch --max-size u \
    --output-directory sra \
    PUBLIC_RUN_04 &
pid4=$!

wait "$pid3"
status3=$?

wait "$pid4"
status4=$?

if [[ "$status3" -ne 0 || "$status4" -ne 0 ]]; then
    echo "Samples 3 and 4 download failed"
    exit 1
fi

echo "End time:"
date "+%H:%M:%S %d/%m/%Y"

exit 0
