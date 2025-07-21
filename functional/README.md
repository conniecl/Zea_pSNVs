1. Fst estimation
```
~/software/genomics_general/VCF_processing/parseVCF.py -i zea_nonsys.1.recode.vcf -o zea_nonsys.1.geno.gz
for i in nicaraguensis luxurians diploperennis huehuetenangensis mexicana parviglumis;
do
for j in TST TEM;
do
for m in {1..10};
do
	echo "nohup ~/software/genomics_general/popgenWindows.py -g zea_nonsys.$m.geno.gz -o ${i}_${j}.$m.Fst.Dxy.pi.csv.gz -f phased -w 1 -m 1 -s 1 -p $i -p $j --popsFile ./pop &";
done
done
done
```
2. averagely Fst of pSNVs and missense mutations
```
perl avg_fst.pl
```
3. highly divergent pSNVs
```
perl top10_psnv.pl
```
4. gwas
```
plink --threads 10 --vcf ../maize_1.imp.vcf.gz --maf 0.05 --biallelic-only --make-bed --out maize_1.maf_0.05 --noweb
plink --threads 12 --allow-extra-chr --bfile maize_1.maf_0.05 --indep-pairwise 50 10 0.1 --out maize_1
plink --threads 12 --allow-extra-chr --bfile maize_1.maf_0.05 --extract maize_1.prune.in --make-bed --out maize_1.strc
plink --threads 12 --bfile maize_1.strc --merge-list merge.list --make-bed --out maize.strc
admixture -j50 --cv maize.strc.bed 3 |tee log3.out
perl vcf2chrhmp.pl
perl ~/tassel3-standalone/run_pipeline.pl -Xmx20g -fork1 -h maize.gwas.hmp -filterAlign -filterAlignMinFreq 0.05 -ck -export maize_kinship.txt -runfork1
perl vcf2hmp.pl
chr=$1
perl ~/tassel3-standalone/run_pipeline.pl -Xmx5g -fork1 -h chr${chr}_nonsys_imp.hmp -filterAlign -filterAlignMinFreq 0.05 -fork2 -r maize_amp.trait -fork3 -q amp.strc -fork4 -k maize_kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel None -mlmOutputFile maize_amp.chr$chr -runfork1 -runfork2 -runfork3 -runfork4
```