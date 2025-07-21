### 1. extract non-phosphorylated S, T, and Y sites from the missense mutations
```perl ref_all.pl```
### 2. randomly select same number of non-phosphorylated S, T, and Y sites from the missense mutations as the phosphorylation sites, repeat 1000 times
```
for i in {1..1000};
do
shuf -n 27279 b73_noptm.S >$i.s
shuf -n 5140 b73_noptm.T >$i.t
shuf -n 595 b73_noptm.Y >$i.y
done
```
### 3. count the number of randomly selected sites that loacted in different domains
```perl rand_type.pl```
### 4. combine all 1000 randomly selected sites with pSNVs that located in different domains
```
rand_static.pl
cd ../
cmb_domain_rand.pl
```
