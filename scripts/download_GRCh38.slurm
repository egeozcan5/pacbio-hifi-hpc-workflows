#!/bin/bash
#SBATCH --job-name=download_GRCh38
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=04:00:00
#SBATCH --output=logs/download_GRCh38_%j.out
#SBATCH --error=logs/download_GRCh38_%j.err

module purge

cd "$SLURM_SUBMIT_DIR/reference"

echo "Start time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

wget -c \
    https://downloads.pacbcloud.com/public/reference-genomes/human_GRCh38_no_alt_analysis_set.tar.2023-12-04.gz

status1=$?

if [[ "$status1" -ne 0 ]]; then
    exit 1
fi

wget -c \
    https://downloads.pacbcloud.com/public/reference-genomes/human_GRCh38_no_alt_analysis_set.tar.2023-12-04.gz.md5

status2=$?

if [[ "$status2" -ne 0 ]]; then
    exit 1
fi

md5sum -c human_GRCh38_no_alt_analysis_set.tar.2023-12-04.gz.md5

status3=$?

if [[ "$status3" -ne 0 ]]; then
    exit 1
fi

tar -xzf human_GRCh38_no_alt_analysis_set.tar.2023-12-04.gz

status4=$?

echo "End time:"
date "+%H:%M:%S   %d/%m/%Y"
echo "----------------------------"

if [[ "$status4" -ne 0 ]]; then
    exit 1
fi

exit 0
