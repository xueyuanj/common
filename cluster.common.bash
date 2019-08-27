#PBS -l walltime=96:00:00
#PBS -l nodes=1:ppn=8
#PBS -l pmem=2gb
#PBS -m abe
#PBS -M xjj5003@psu.edu
#PBS -j oe

cd /storage/home/xjj5003/scratch
date

module load python/2.7.9 #as in $module av python  
cd /storage/home/xjj5003/work/human_PBS

REF=GCF_000146795_2_Nleu_3_0_genomic.fa

file=hle.srx590196.srx590198.NC_019816.1.bqsr.bam

echo $file
core=${file%.bam}
vcffile="${core}.consensus.vcf"
fafile="${core}.consensus.fa"
:
./samtools faidx $REF

./bcftools mpileup -Ou -f $REF  $file | ./bcftools call -Ou -mv| ./bcftools filter  -s LowQual -e '%QUAL<20 || DP>100'  >$vcffile 
./bgzip $vcffile
./bcftools index "${vcffile}.gz"
./bcftools consensus -f $REF "${vcffile}.gz" > $fafile


date
