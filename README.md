# PacBio HiFi HPC scripts

Basic infrastructure scripts from an existing SLURM workflow. Commands, resource requests, partition settings, timing messages, status checks and separate script structure are preserved from the supplied originals. Only personal paths, sample identifiers and group labels were anonymized. The original files were not modified.

Included: public SRA download, public GRCh38 reference download/checksum verification, FASTQ conversion, SeqKit/NanoPlot QC, pbmm2 indexing/alignment, and samtools quickcheck/flagstat/stats/coverage. No downstream research analyses are included.

## Before running

- These are anonymized examples, not a ready-to-run pipeline. Replace `PUBLIC_RUN_01` through `PUBLIC_RUN_04` with permitted public accessions. Replace `SAMPLE_01` through `SAMPLE_04` consistently with your actual file/sample names. Download and processing placeholders are deliberately not a claimed study sample mapping.
- Submit from the project root. Personal working paths were replaced with `$SLURM_SUBMIT_DIR`; SLURM log paths are relative to the submission directory.
- Create required folders first: `mkdir -p logs sra fastq reference alignment qc_raw qc_alignment`.
- The scripts retain the original `miniconda3` module and `pacbio_ref` environment. That environment must already exist and contain the tools used. No new environment setup is claimed or included.
- Original `barbun`/`debug` partition names, CPU layout, memory and time requests are retained. Confirm they are appropriate for your allocation before submission. Multithreaded conversion/alignment retain the original multiple-task resource layout; this was not redesigned.
- Complete each prerequisite before submitting dependent jobs. The FASTQ/alignment/NanoPlot example scripts process only SAMPLE_01; the multi-sample QC scripts expect all four files. Prepare equivalent single-sample jobs for the remaining files before running those QC scripts.
- The GRCh38 download URL, reference paths and tool flags are unchanged; their current availability and compatibility have not been verified.

All 11 files passed `bash -n`; no cluster jobs or real-tool execution tests were performed. Retain required attribution. No reuse license has been selected.
