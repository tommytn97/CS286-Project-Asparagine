Shell scripts were adapted from https://ucdavis-bioinformatics-training.github.io/2020-mRNA_Seq_Workshop/

star_index.sh builds the reference genome for STAR to use

run_star_align_parallel.sh submits star_align_parallel.sh jobs to SLURM depending on number of fastq files

merge_star.sh merges all BAM files to create a count file for all associated fastq files



