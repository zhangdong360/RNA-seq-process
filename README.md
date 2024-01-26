# 脚本说明

此项目为RNA-seq下机数据的上游处理，为在集群上运行的slurm版本，请勿直接`bash`运行，请使用**slrum系统**进行提交，如：`sbatch process_fastp_slurm.sh`

## 输入数据要求：

+ 请在**process_fastp_slurm.sh**中指定数据输入和输出目录，此处默认rawdata存放目录为./data，输出目录默认为的./cleandata。不建议修改输出目录，如需修改，请同步修改**hisat2_for_slurm.sh**中的输入参数
+ rawdata存放方式默认为在./data目录下每个样本存放在一个文件夹下。如无子文件夹，请按要求处理rawdata。例：
  + ./data/sample01/sample01.R1.fastq.gz
  + ./data/sample01/sample01.R2.fastq.gz
  + ./data/sample02/sample02.R1.fastq.gz
  + ./data/sample02/sample02.R2.fastq.gz

## 各脚本作用：

+ process_fastp_slurm.sh
  + 使用fastp对rawdata进行处理，得到cleandata。
  + 参数设置与诺禾致源参数设置一致。
+ hisat2_for_slurm.sh
  + 使用hisat2，samtools和stringtie来对cleandata进行处理，得到count matrix
+ prepDE.py
  + 生成count matrix

## 数据库

集群服务器上的数据库为hisat2官网下载

该脚本使用**GENCODE**数据库，版本为GRCh38，对应位置为：

+ /share/home/zhangd/tools/database_rna/index/GENCODE/

如想使用**NCBI**数据库，版本为hg38，对应位置为：

+ /share/home/zhangd/tools/database_rna/index/NCBI
