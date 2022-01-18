#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=28
#SBATCH --time=72:00:00
#SBATCH --mem-per-cpu=4500
#SBATCH --output=STAR_index.log
#SBATCH --job-name=STAR_index

module load intel-python3
source activate RNAseq_cp

job_start=`date +%s`

STAR \
--runThreadN 56 \
--runMode genomeGenerate \
--genomeDir ~/asn_project/assembly \
--genomeFastaFiles ~/asn_project/assembly/Phaeodactylum_tricornutum.ASM15095v2.dna.toplevel.fa \
--sjdbGTFfile ~/asn_project/annotation/Phaeodactylum_tricornutum.ASM15095v2.50.gtf \
--sjdbOverhang 149 \
--genomeSAindexNbases 11

echo "Finished STAR index"
job_end=`date +%s`
runtime=$((job_end-job_start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "STAR index runtime: $hours:$minutes:$seconds (hh:mm:ss)"

# !!!!! WARNING: --genomeSAindexNbases 14 is too large for the genome size=27568093, 
# which may cause seg-fault at the mapping step. Re-run genome generation with recommended 
# --genomeSAindexNbases 11
