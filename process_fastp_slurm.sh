#!/bin/bash
#SBATCH -o output/fastp.out
#SBATCH -e output/fastp.err
#SBATCH --partition=compute
#SBATCH -J fastp
#SBATCH --nodes=1                 # 申请一个节点
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=7
# This is for fastp protocol
# 指定你的数据目录
data_dir="./data"
cleandata_dir="./cleandata"
# 遍历数据目录中的子文件夹
for sample_dir in "$data_dir"/*; do
    if [ -d "$sample_dir" ]; then
        sample_name=$(basename "$sample_dir")
	sample_output_dir="$cleandata_dir/$sample_name"
        
	if [ ! -d "$sample_output_dir" ]; then
            mkdir "$sample_output_dir"
        fi
	# 设置输入和输出文件的路径
        input1="$sample_dir/${sample_name}.R1.fastq.gz"
        input2="$sample_dir/${sample_name}.R2.fastq.gz"
        output1="$sample_output_dir/${sample_name}_clean_1.fq.gz"
        output2="$sample_output_dir/${sample_name}_clean_2.fq.gz"
        
        # 运行fastp进行质量控制和数据清洗
        echo "Processing $sample_name"
        fastp -i "$input1" -I "$input2" -o "$output1" -O "$output2" \
        -g -q 5 -u 50 --compression 9 -n 15 \
        -c --overlap_len_require 10 --overlap_diff_limit 1 --overlap_diff_percent_limit 10 \
        --length_required 150 \
        --json "$sample_output_dir/fastp_${sample_name}.json"\
        --html "$sample_output_dir/fastp_${sample_name}.html"\
        --report_title "fastp report ${sample_name}"

        echo "Processed $sample_name"
    fi
done

echo "All samples processed."

