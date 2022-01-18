# Asparagine production of *Phaeodactylum tricornutum* project

Dr. Andreoupoulos
CS-286
Spring 2021

Tommy Nguyen
Yvonna Leung

## Project Procedure

#### Connecting to CoS HPC

SJSU VPN client (Cisco AnyConnect) is required to access CoS HPC. See https://www.sjsu.edu/it/services/network/vpn/index.php

PuTTY, a free SSH client, was used to connect to CoS HPC. See https://www.putty.org/

```
tnguyen@spartan01.sjsu.edu
```

#### Transferring data - some examples

From local desktop to HPC

```
pscp -r -P 22 tnguyen@spartan01.sjsu.edu:/home/tnguyen/asn_project/alignment_sorted/
```

 From HPC to local desktop

```
pscp -P 22 -r tnguyen@spartan01.sjsu.edu:/home/tnguyen/asn_project/alignment_sorted/Ni3_ReadsPerGene.out.tab Ni3_ReadsPerGene.out.tab 
```

#### Submitting Jobs to CoS HPC using SLURM - example

```
sbatch job.sh # this submits a job to the HPC
squeue # checks the status of a job
```

Documentation of SJSU CoS HPC can be found here: http://spartan01.sjsu.edu/dokuwiki/doku.php?id=hpc:intro:job-submission

#### *Phaeodactylum tricornutum* details

| Sample Name Example | Short Sample Description      | Sample Description                                           |
| ------------------- | ----------------------------- | ------------------------------------------------------------ |
| N_1_1               | Asparagine                    | *P. tricorntum* cultures grown in presence of Asparagine     |
| Ni_1_1              | Nitrate                       | *P. tricorntum* cultures grown in presence of Nitrate        |
| Ni_N1_1             | Nitrate and Asparagine        | *P. tricorntum* cultures grown in presence of Nitrate and Asparagine |
| Ni_SM1_1            | Nitrate and medium Asparagine | *P. tricorntum* cultures grown in presence of Nitrate and medium amount of Asparagine |

#### Fastp/Fastqc 

Fastp was ran locally on every sample and every trimmed pair end sample was transferred to the HPC for STAR. 

Example Fastp code

```
fastp -i Ni1_1.fq -I Ni1_2.fq -o Ni1_1.fastq.gz -O Ni1_2.fastq.gz -l 100 --detect_adapter_for_pe
```

| Sample Name | % Duplication | GC content | % PF  | % Adapter | % Dups | % GC | M Seqs |
| :---------- | :------------ | :--------- | :---- | :-------- | :----- | :--- | :----- |
| N_1_1       | 24.1%         | 52.0%      | 99.1% | 2.1%      | 59.7%  | 52%  | 21.0   |
| N_1_2       |               |            |       |           | 58.5%  | 51%  | 21.0   |
| N_2_1       | 20.4%         | 52.1%      | 99.3% | 3.9%      | 59.1%  | 52%  | 19.0   |
| N_2_2       |               |            |       |           | 58.8%  | 52%  | 19.0   |
| N_3_1       | 29.4%         | 51.7%      | 99.1% | 6.1%      | 65.8%  | 51%  | 26.5   |
| N_3_2       |               |            |       |           | 62.8%  | 51%  | 26.5   |
| Ni1_1       | 42.5%         | 51.9%      | 98.9% | 2.8%      | 66.7%  | 51%  | 16.7   |
| Ni1_2       |               |            |       |           | 65.7%  | 51%  | 16.7   |
| Ni2_1       | 30.7%         | 52.4%      | 99.2% | 8.0%      | 64.3%  | 52%  | 20.3   |
| Ni2_2       |               |            |       |           | 63.4%  | 52%  | 20.3   |
| Ni3_1       | 26.9%         | 52.1%      | 99.2% | 4.3%      | 58.0%  | 52%  | 13.6   |
| Ni3_2       |               |            |       |           | 57.3%  | 52%  | 13.6   |
| Ni_N1_1     | 23.4%         | 52.3%      | 99.1% | 4.2%      | 62.3%  | 52%  | 22.4   |
| Ni_N1_2     |               |            |       |           | 60.7%  | 52%  | 22.4   |
| Ni_N2_1     | 24.1%         | 52.2%      | 99.2% | 2.3%      | 59.8%  | 52%  | 18.0   |
| Ni_N2_2     |               |            |       |           | 58.8%  | 52%  | 18.0   |
| Ni_N3_1     | 21.4%         | 52.4%      | 99.3% | 2.2%      | 64.5%  | 52%  | 27.7   |
| Ni_N3_2     |               |            |       |           | 62.6%  | 52%  | 27.7   |
| Ni_SM1_1    | 37.3%         | 51.4%      | 99.2% | 2.3%      | 59.3%  | 51%  | 17.1   |
| Ni_SM1_2    |               |            |       |           | 58.5%  | 51%  | 17.1   |
| Ni_SM2_1    | 35.0%         | 51.4%      | 99.3% | 4.6%      | 60.4%  | 51%  | 19.6   |
| Ni_SM2_2    |               |            |       |           | 59.1%  | 51%  | 19.6   |
| Ni_SM3_1    | 74.8%         | 51.0%      | 99.1% | 2.4%      | 83.0%  | 51%  | 41.8   |
| Ni_SM3_2    |               |            |       |           | 82.0%  | 50%  | 41.8   |

![fastp_filtered_reads_plot (1)](../../Downloads/fastp_filtered_reads_plot (1).png)

About 99% of reads for every sample had passed filter. Reads with Phred scores of less than or equal to 15 was discarded and reads with lengths of less than 100 was removed. Adapters were automatically detected and removed. 

![image-20220118105943614](../../AppData/Roaming/Typora/typora-user-images/image-20220118105943614.png)

After the filtering step (adapter trimming, quality control), FastQC showed consistent and excellent Phred quality scores. 

#### Indexing Reference Genome and Annotation

The genome was indexed using ENSEMBL genome and annotation files for *P. tricorntum.* star_index.sh script was used for this step.

```
STAR \
--runThreadN 56 \
--runMode genomeGenerate \
--genomeDir ~/asn_project/assembly \
--genomeFastaFiles ~/asn_project/assembly/Phaeodactylum_tricornutum.ASM15095v2.dna.toplevel.fa \
--sjdbGTFfile ~/asn_project/annotation/Phaeodactylum_tricornutum.ASM15095v2.50.gtf \
--sjdbOverhang 149 \
--genomeSAindexNbases 11
```

#### Alignment of reads to Reference genome using STAR

Trimmed pair-end read samples were mapped to the reference genome with STAR

~~~
for sample in $(cd ~/asn_project/trimmed && ls *.fastq | sed s/_[12].fastq// | sort -u)
do

sbatch ~/asn_project/scripts/star_align_parallel.sh ${sample}
~~~

star_align_parallel.sh submits a job for every pair-end read sample 

```
STAR \
--runThreadN 12 \
--runMode alignReads \
--genomeDir ~/asn_project/assembly \
--quantMode GeneCounts \
--outSAMtype BAM SortedByCoordinate \
--limitBAMsortRAM 32000000000 `#32GB - minimum 32GB of RAM for STAR, can be increased`\
--readFilesIn ~/asn_project/trimmed/${sample}_1.fastq ~/asn_project/trimmed/${sample}_2.fastq \
--outFileNamePrefix ~/asn_project/alignment_sorted/${sample}_
```

#### Create Count Table from STAR Alignment Results

merge_star.sh creates a matrix of the gene counts for each sample using the ReadsPerGene.out.tab files.

```
# Place each sample's STAR gene count file - ReadsPerGene.out.tab in the tmp/ directory 
# The 2nd column (-f2) of ReadsPerGene.out.tab contains the non-stranded counts
for sample in $(cd ~/asn_project/alignment_sorted && find ./*glob*_ReadsPerGene.out.tab | sed s/_ReadsPerGene.out.tab// | sort -u)
do 
    echo "${sample}"
    cat ~/asn_project/alignment_sorted/${sample}_ReadsPerGene.out.tab | tail -n +5 | cut -f2 > ~/asn_project/alignment_sorted/tmp/${sample}.count
done

# get a list of gene ids (-f1)
tail -n +5 ~/asn_project/alignment_sorted/N_1_ReadsPerGene.out.tab | cut -f1 > ~/asn_project/alignment_sorted/tmp/geneids.txt

# combine all the columns of the count files
paste ~/asn_project/alignment_sorted/tmp/geneids.txt ~/asn_project/alignment_sorted/tmp/*.count > ~/asn_project/alignment_sorted/tmp/tmp.out

# add the header
cat <(cat ~/asn_project/alignment_sorted/tmp/header.txt | sed 's/ /\t/g') ~/asn_project/alignment_sorted/tmp/tmp.out > ~/asn_project/alignment_sorted/STAR_counts.txt

# remove the tmp folder
rm -rf ~/asn_project/alignment_sorted/tmp
```

#### STAR Results

STAR showed excellent alignment as over 91% of the RNA-seq reads were uniquely mapped to the genome. 

| Sample Name | % Aligned | M Aligned |
| :---------- | :-------- | :-------- |
| N_1         | 93.3%     | 19.4      |
| N_2         | 93.7%     | 17.7      |
| N_3         | 93.7%     | 24.6      |
| Ni1         | 91.2%     | 15.0      |
| Ni2         | 93.1%     | 18.7      |
| Ni3         | 92.8%     | 12.6      |
| Ni_N1       | 93.2%     | 20.7      |
| Ni_N2       | 93.7%     | 16.7      |
| Ni_N3       | 93.7%     | 25.8      |
| Ni_SM1      | 93.2%     | 15.8      |
| Ni_SM2      | 93.1%     | 18.2      |
| Ni_SM3      | 91.7%     | 38.0      |

![image-20220118111957698](../../AppData/Roaming/Typora/typora-user-images/image-20220118111957698.png)

iDEP v0.93 was used for DEG analysis. The website can be found here: http://bioinformatics.sdstate.edu/idep/
