### 1. uniref90 databse
```wget https://ftp.uniprot.org/pub/databases/uniprot/current_release/uniref/uniref90/uniref90.fasta.gz```
### 2. format the genome, transcripts
```cd sift```
```mkdir maize```
```cd maize```
```mkdir gene-annotation-src ```
```perl max_trans.pl```
```mkdir chr-src```
### 3. construct SIFT DB数据库
```cd ~/software/sift4g/scripts_to_build_SIFT_db```
```nohup perl make-SIFT-db-all.pl -config maize_config.txt ```
### 4. VCF annotation
```java -jar ~/software/sift4g/SIFT4G_Annotator/SIFT4G_Annotator.jar -c -i test.vcf -d ../maize_v4/ -r ./```
