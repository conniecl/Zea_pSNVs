### 1. seperate the SNPs of maize and teosinte
```
for i in {1..10};do echo "nohup tabix -p vcf merge_$i.filter.vcf.gz &";done
for i in {1..10};do echo "nohup vcftools --gzvcf merge_$i.filter.vcf.gz --recode --keep teo --out teo_$i &";done
for i in {1..10};do echo "nohup vcftools --gzvcf merge_$i.filter.vcf.gz --recode --keep maize --out maize_$i &";done
```
### 2. imputation
```
java -Xmx500g -jar ~/software/beagle.22Jul22.46e.jar gt=teo_1.recode.vcf out=teo_1.imp nthreads=200 #use chr1 as example
java -Xmx500g -jar ~/software/beagle.22Jul22.46e.jar gt=maize_1.recode.vcf out=maize_1.imp nthreads=200
```
### 3. combine the SNPs of maize and teosinte
```
bcftools merge teo_10.imp.vcf.gz maize_10.imp.vcf.gz -Oz -o merge_10.imp.vcf.gz #use chr10 as example
```
### 4. randomly select 100 maize individuals, gain the input of XPCLR (geno)
```
xpclr_input.pl
```
### 5. gain the genetic position
```
for i in {1..10};do Rscript snp_input.r teo_maize.chr$i teo_maize.$i >teo_maize.$i.snp;done 
```
### 6. XPCLR calculation
```
XPCLR -xpclr maize.$chr.geno teo.$chr.geno teo_maize.$chr.snp teo_maize.$chr -w1 0.005 50 100 $chr -p0 0.7
```
### 7. combine the XPCLR score with GenWin
```
#genwin.r
library("GenWin")
argv <- commandArgs(TRUE)
data<-read.table(paste(argv[1],".wtclr.txt",sep=""),sep=" ")
sub<-data[which(data$V6!="Inf"),]
spline<-splineAnalyze(Y=sub$V6,map=sub$V4,smoothness=2000,plotRaw=TRUE,plotWindows=TRUE,method=4)
out<-write.table(spline$windowData,sep="\t",row.names=F,col.names=T,file=paste(argv[1],".spline",sep=""),quote=F)
```
### 8. remove centromere region, gain the candidate selection region
```
for i in {1..10};do cut -f 1,2,5 teo_maize.$i.spline >teo_maize.$i.spline.bed;done
for i in {1..10};do sed -i "s/^/$i\t/g" teo_maize.$i.spline.bed;done
for i in {1..10};do sed -i '1d' teo_maize.$i.spline.bed;done
for i in {1..10};do bedtools subtract -a teo_maize.$i.spline.bed -b cent.bed >teo_maize.$i.spline.nocent;done
perl sel_region.pl
grep -w "sel" teo_maize.sel.class |sort -k1,1n -k2,2n|cut -f 1,2,3 >t
bedtools merge -i t -d 1 >teo_maize.sel.bed
```
### 9. count the number of pSNVs in selection region
/mnt/sda/lchen/dele_mu/04.sift/maize/dbSNP
selpsv_ancsample.pl
### 10. compare the pSNVs and missense mutations in selection regions
rand_sel.pl
### 11. count the number of pSNVs in hitchhiking region hitchhiking, and compare the pSNVs and missense mutations in hitchhiking regions
```
hitpsv_ancsample.pl
rand_hit.pl
```