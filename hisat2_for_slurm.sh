#!/bin/bash
#SBATCH -o output/hisat2_for.out
#SBATCH -e output/hisat2_for.err
#SBATCH --partition=compute
#SBATCH -J hisat2
#SBATCH --nodes=1                 # 申请一个节点
#SBATCH --cpus-per-task=3
#SBATCH --ntasks-per-node=16
# This is for fastp protocol
for i in `ls cleandata/`;
do
    printf "prepare $i\n\n"
    hisat2 --dta -t -p 16 -x /share/home/zhangd/tools/database_rna/index/GENCODE/GENCODE_genome \
    -1 ./cleandata/"$i"/"$i"_clean_1.fq.gz \
    -2 ./cleandata/"$i"/"$i"_clean_2.fq.gz | samtools sort > ./cleandata/"$i"/"$i"_output_sorted.bam;
    #stringtie processing
    stringtie -e -B -p 16 -G /share/home/zhangd/tools/database_rna/index/GENCODE/gencode.v43.primary_assembly.annotation.gff3 \
    -o ./cleandata/stringtie_out/"$i"/stringtie_out.gtf \
    ./cleandata/"$i"/"$i"_output_sorted.bam
    printf "finish $i\n\n";
done
python /share/home/zhangd/tools/prepDE.py \
-i ./cleandata/stringtie_out \
-g ./gene_count_matrix.csv -t ./gene_transcript_matrix.csv
