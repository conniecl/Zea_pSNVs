### 1. convert peptides to fa format
```perl all2fa.pl```
### 2. align peptides to B73 protome
```makeblastdb -in Zea_mays.AGPv4.pep.max.fa -dbtype prot -out b73_v4```
```blastp -db ../b73_v4 -query phopeptide.fa -num_threads 100 -out ptm_v4.blastp -outfmt 6 -task blastp-short```
### 3. gain the physical position of phosphorylated sites
```perl pro_pos.pl```
```perl weight.pl```
### 4. calculate the SIFT score (see sift dictionary)
### 5. calculate the GERP score (see gerp dictionary)
### 6. IDR and pfam domain identification
```bash ~/software/interproscan-5.66-98.0/interproscan.sh -appl MobiDBLite,Pfam -i Zea_mays.AGPv4.pep.max.fa -cpu 50 -b b73_v4.mp```
### 7. missense mutation identification
```perl all_nonsys.pl```
### 8. pSNV identification
```perl psv.pl```
