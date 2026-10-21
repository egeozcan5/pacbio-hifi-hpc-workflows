# PacBio HiFi workflows on SLURM

Anonymized infrastructure scripts for processing PacBio HiFi reads on a SLURM-managed HPC cluster. This repository illustrates data retrieval, FASTQ conversion, quality control, reference indexing and alignment using examples adapted from an existing TRUBA workflow.

The public scope is limited to infrastructure. Downstream analyses and results from the ongoing research project are not included.

## Scope and repository structure

| Stage | Script | Purpose |
| --- | --- | --- |
| Read download | `scripts/download_samples.slurm` | Download four public SRA runs in two batches |
| Reference download | `scripts/download_GRCh38.slurm` | Download the GRCh38 no-alt analysis set and verify its MD5 checksum |
| FASTQ conversion | `scripts/fastq_sample_01.slurm` | Convert one SRA run to FASTQ and compress with pigz |
| Read QC | `scripts/seqkit_stats.slurm` | Summarize four FASTQ files |
| Read QC | `scripts/nanoplot_sample_01.slurm` | Generate a NanoPlot report for one sample |
| Reference indexing | `scripts/index_GRCh38_pbmm2.slurm` | Build a pbmm2 index with the HiFi preset |
| Alignment | `scripts/align_sample_01.slurm` | Align one sample and produce a sorted, indexed BAM |
| Alignment QC | `scripts/quickcheck_bams.slurm` | Check basic BAM integrity |
| Alignment QC | `scripts/flagstat_bams.slurm` | Summarize alignment flags |
| Alignment QC | `scripts/samtools_stats.slurm` | Generate alignment statistics |
| Alignment QC | `scripts/samtools_coverage.slurm` | Summarize reference coverage |

These are adaptable script examples. They require local configuration and do not form an automated, ready-to-run pipeline.

## Requirements

- A Linux cluster with SLURM and an environment module system.
- The scripts currently load the `miniconda3` module and activate a pre-existing Conda environment named `pacbio_ref`.
- Required analysis tools: SRA Toolkit (`prefetch`, `fasterq-dump`), pigz, SeqKit, NanoPlot, pbmm2 and samtools.
- Required system utilities include Bash, wget, GNU `md5sum` and tar.

Tool versions and an environment definition are not included. Check tool availability, supported flags, storage capacity and cluster resource limits before submission.

## Configure before running

1. Replace `PUBLIC_RUN_01`–`PUBLIC_RUN_04` with the public SRA accessions to process.
2. Make the processing paths match the actual downloaded run directories and filenames. `PUBLIC_RUN_01` and `SAMPLE_01` are separate placeholders; the scripts do not map or rename them automatically.
3. Prepare conversion and alignment jobs for all four samples before using the multi-sample QC scripts. Conversion, alignment and NanoPlot are supplied only for `SAMPLE_01`.
4. Review the `barbun`/`debug` partitions, wall times, memory and CPU requests for your cluster. Conversion and alignment retain a multiple-task layout despite using multithreaded commands; verify CPU allocation and binding before use.
5. Configure the module and Conda environment for your installation. The current scripts do not consistently stop immediately if environment activation or directory changes fail.

From the repository root, create the required directories **before** submitting jobs:

```sh
mkdir -p logs sra fastq reference alignment qc_raw qc_alignment
```

Submit from this same directory: the scripts use `$SLURM_SUBMIT_DIR` and relative log paths.

## Execution order

After configuration, submit each script with `sbatch`, for example:

```sh
sbatch scripts/download_GRCh38.slurm
```

A successful submission only means the job was accepted. Check its completion and exit status before submitting dependent work.

```text
SRA download → FASTQ conversion → SeqKit / NanoPlot
                         │
                         └──────────────┐
Reference download → pbmm2 indexing → pbmm2 alignment → samtools QC
```

There is no automatic dependency handling. Alignment requires both the converted reads and reference index. The multi-sample QC jobs require all four corresponding files.

## Outputs and validation

Expected outputs include compressed FASTQ files, a reference index, sorted BAM files and indexes, read/alignment QC reports, and SLURM logs. Data, reports and logs are excluded from version control; no example outputs are bundled.

All 11 scripts passed Bash syntax checks (`bash -n`). Running the workflow requires configuring the cluster environment, sample identifiers and file paths as described above. End-to-end execution was not tested during this review.
