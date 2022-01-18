
#!/bin/bash
# create header file

echo gene_name "$(cd ~/asn_project/alignment_sorted && find ./*glob*_ReadsPerGene.out.tab | sed s/_ReadsPerGene.out.tab// | sort -u)" > ~/asn_project/alignment_sorted/tmp/header.txt

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
