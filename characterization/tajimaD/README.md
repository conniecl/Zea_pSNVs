1. calculate TajimaD
for i in nicaraguensis luxurians diploperennis perennis huehuetenangensis mexicana parviglumis TST TEM;
do
for j in {1..10};
do
	vcftools --gzvcf ../merge_$j.imp.vcf.gz --positions /mnt/sda/lchen/dele_mu/04.sift/maize/dbSNP/zea_nonsys.pos --keep ../$i --TajimaD 1 --out ${i}_$j.nonsys;
done
done
2. combine TajimaD
perl cmb_tajima.pl