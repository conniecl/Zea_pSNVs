### 1. Repeat mask
```
input=$1
thread=$2
~/software/RepeatModeler-2.0.4/BuildDatabase -name $input $input.fa
~/RepeatModeler-2.0.4/RepeatModeler -database $input -threads $thread
~/RepeatMasker/RepeatMasker -gff -lib ${input}-families.fa -dir $input $input.fa -xsmall -pa $thread -e rmblast
```
### 2. build index (use maize as reference)
```
#convert softmask to unmask
sed -i 's/[a-z]/\U&/g' Zea_mays.fa
faSize Zea_mays.fa -detailed > Zea_mays.size
faToTwoBit Zea_mays.fa Zea_mays.2bit
lastdb -P 100 -uMAM4 -R01 ./lastdb/maize-MAM4 ./Zea_mays.fa
```
### 3. alignment (last)
```
i=$1
last-train -P 10 --revsym --matsym --gapsym -E0.05 -C2 ./lastdb/maize-MAM4 $i.sm.fa > ../02.mat/Zea_mays_$i.mat
lastal -P 10 -m50 -E0.05 -C2 -p ../02.mat/Zea_mays_$i.mat ./lastdb/maize-MAM4 $i.sm.fa > ../03.maf/Zea_mays_$i.maf
maf-convert axt ../03.maf/Zea_mays_$i.maf > ../04.axt/Zea_mays_$i.axt
axtChain ../04.axt/Zea_mays_$i.axt ./Zea_mays.fa $i.sm.fa ../05.chain/Zea_mays_$i.chain -linearGap=loose -faQ -faT
chainMergeSort ../05.chain/Zea_mays_$i.chain > ../05.chain/Zea_mays_$i.all.chain
faSize $i.sm.fa -detailed > $i.size
chainPreNet ../05.chain/Zea_mays_$i.all.chain Zea_mays.size $i.size ../06.chainp/Zea_mays_$i.all.pre.chain
chainNet ../06.chainp/Zea_mays_$i.all.pre.chain Zea_mays.size $i.size ../07.net/Zea_mays_$i.net ../07.net/${i}_Zea_mays.net
faToTwoBit $i.sm.fa $i.2bit
netToAxt ../07.net/Zea_mays_$i.net ../06.chainp/Zea_mays_$i.all.pre.chain Zea_mays.2bit $i.2bit ../08.netaxt/Zea_mays_$i.net.axt
axtToMaf ../08.netaxt/Zea_mays_$i.net.axt Zea_mays.size $i.size ../09.netmaf/Zea_mays_$i.net.maf
head -n 29 ../03.maf/Zea_mays_$i.maf >../09.netmaf/Zea_mays_$i.net.h.maf
cat ../09.netmaf/Zea_mays_$i.net.maf >>../09.netmaf/Zea_mays_$i.net.h.maf
last-split -m1 ../09.netmaf/Zea_mays_$i.net.h.maf|maf-swap |awk -v q="$i" -v r="Zea_mays" '/^s/ {$2 = (++s % 2 ? q "." : r ".") $2} 1' | last-split -m1 | maf-swap | last-postmask > ../10.onemaf/Zea_mays_$i.1to1.maf
```
### 4. combine alignment file into a multiple alignment file
```
ref_name="Zea_mays"
maf_array=($( ls -d /mnt/sda/lchen/dele_mu/06.gerp/last/10.onemaf/*1to1.maf ))
combined_maf=/mnt/sda/lchen/dele_mu/06.gerp/last/11.cmbmaf/combined.maf

cat ${maf_array[@]:0:1} | sed -n '/##maf version=1 scoring=blastz/,$p' > ${maf_array[@]:0:1}_tmp
cat ${maf_array[@]:1:1} | sed -n '/##maf version=1 scoring=blastz/,$p' > ${maf_array[@]:1:1}_tmp

multiz ${maf_array[@]:0:1}_tmp ${maf_array[@]:1:1}_tmp 1 > $combined_maf

for maf in ${maf_array[@]:2};
do
  echo "processing " $maf
  cat $maf | sed -n '/##maf version=1 scoring=blastz/,$p' >  "$maf"_tmp
  multiz $combined_maf "$maf"_tmp 1 > "$combined_maf"_tmp
  mv "$combined_maf"_tmp $combined_maf
done

# and filter mafs so all blocks have Zea mays and are at least 20 bp long
mafFilter -minCol=20 -needComp="$ref_name" $combined_maf > "$combined_maf".filtered
```
### 5. convert maf to msa format
```
cd ~/dele_mu/06.gerp/last/11.cmbmaf
mafSplit -byTarget dummy.bed ./maf_split combined.maf.filtered -useFullSequenceName #dummy.bed a fake file
faSplit byname ../01.data/Zea_mays.fa ref_split/
faSplit byname ~/ref/Zea_mays.AGPv4.dna_rm.toplevel.fa.gz rm_split/
for i in {1..10};
do
msa_view maf_split/$i.maf -f -G 1 --refseq ref_split/$i.fa >maize.$i.fa
sed -i 's/> />/g' maize.$i.fa
sed -i 's/\*/-/g' maize.$i.fa
perl matchMasking.pl --ref rm_split/$i.fa --fasta maize.$i.fa --out maize.$i.rm.fa
done
```
### 6. construct the tree
```
#change anaconda to miniconda
cd ../01.data
nohup mashtree --numcpus 100 *.sm.fa >mashtree.dnd &
cd ../11.cmbmaf
Rscript estimate_neutral_tree.r ~/dele_mu/06.gerp/last/11.cmbmaf/ref_split/ ~/dele_mu/06.gerp/last/11.cmbmaf/ ~/ref/ maize maize_neutral.tree
```
### 7. calculate GERP score
```
for i in {1..10};
do
~/software/GERPplusplus-master/gerpcol -f maize.$i.rm.fa -t maize_neutral.tree -v -e Zea_mays -j -a
perl rate_pos.pl $i  >maize.$i.pos
paste maize.$i.rm.fa.rates maize.$i.pos >maize.$i.gerp
done
```
