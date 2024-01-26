#!/bin/bash
# This is for hisat2 batch aligne
for i in `ls 00.CleanData/`;
do
    printf "prepare $i\n\n"
    hisat2 --dta -t -p 15 -x /mnt/e/RNA_seq/index/GENCODE/GENCODE_genome \
    -1 /mnt/e/RNA_seq/00.CleanData/"$i"/"$i"_1.clean.fq.gz \
    -2 /mnt/e/RNA_seq/00.CleanData/"$i"/"$i"_2.clean.fq.gz | samtools sort > /mnt/e/RNA_seq/00.CleanData/"$i"/"$i"_output_sorted.bam;
    #stringtie processing
    stringtie -e -B -p 15 -G /mnt/e/RNA_seq/index/GENCODE/gencode.v43.primary_assembly.annotation.gff3 \
    -o /mnt/e/RNA_seq/00.CleanData/stringtie_out/"$i"/stringtie_out.gtf \
    /mnt/e/RNA_seq/00.CleanData/"$i"/"$i"_output_sorted.bam
    printf "finish $i\n\n";
done
python /home/zhangd/miniconda3/envs/RNA_seq/bin/prepDE.py \
-i /mnt/e/RNA_seq/00.CleanData/stringtie_out \
-g gene_count_matrix.csv -t gene_transcript_matrix.csv
