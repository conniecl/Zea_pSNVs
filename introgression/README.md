### 1. introgressed proportion estimation
```
chr=$1
~/software/plink-1.9/plink --vcf ~/dele_mu/01.data/maize/merge_$chr.imp.vcf.gz --keep par_noadmix --recode-bimbam --out par_$chr --threads 10 --biallelic-only
~/software/plink-1.9/plink --vcf ~/dele_mu/01.data/maize/merge_$chr.imp.vcf.gz --keep mex_noadmix --recode-bimbam --out mex_$chr --threads 10 --biallelic-only
~/software/plink-1.9/plink --vcf ~/dele_mu/01.data/maize/merge_$chr.imp.vcf.gz --keep maize --recode-bimbam --out maize_$chr --threads 10 --biallelic-only
for i in {1..10};
do
~/software/ELAI/elai-mt -g ./mex_$chr.recode.geno.txt -p 10 -g ./par_$chr.recode.geno.txt -p 11 -g maize_$chr.recode.geno.txt -p 1 -pos ./maize_$chr.recode.pos.txt -s 20 -C 2 -c 2 -o chr$chr.$i -mixgen 6000 -exclude-maf 0.05 -nthreads 10 -R $i
done
```
### 2. fixed introgression region estimation
```
perl avg_admix.pl
```
### 3. count the number of pSNVs in introgression region
```
perl intropsv_ancsample.pl
```