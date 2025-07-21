### 1. SnpEff annotation
```
perl max_pep.pl
perl maxtae_pep.pl
perl maxosa_pep.pl
perl maxsly_pep.pl
perl maxgma_pep.pl
perl cds.pl
java -jar snpEff.jar build -gtf22 -v osa
java -jar -Xmx100g ~/snpEff/snpEff.jar eff -v osa -i vcf rice4k_geno_no_del.vcf.gz -o gatk -s rice_snpeff.html >rice4k_geno_snpeff.bed 2>rice.log
java -jar -Xmx100g ~/snpEff.jar eff -v tae -i vcf 070222_768_samples_wgs_no_filter_biosample.vcf.gz -o gatk -s wheat_snpeff.html >wheat_geno_snpeff.bed 2>wheat.log
```
### 2. peptides alignment
```
perl ptm_fa.pl
blastp -db sly.max -query sly_ptm.fa -num_threads 30 -out sly_ptm.blastp -outfmt 6 -task blastp-short 
perl ptm_pos.pl
```
### 3. pSNVs identification
```
perl athfk0_anno.pl
perl gmafk0_anno.pl
perl fk0_anno.pl
perl psnv.pl
```
### 4. pSNVs frequence
```
vcftools --gzvcf rice4k_geno_snpeff.bed.gz --freq --out rice.freq
perl orth_psnv.pl
```
### 5. convergently evolved pSNVs
```
perl orth_psnv.pl
```