### 1. gain input file
```
for i in {1..10};do perl est_input.pl $i;done
```
### 2. calculating the probability of ancestral state
```
for i in {1..10};do ~/software/est-sfs-release-2.04/est-sfs config-kimura.txt maize_$i.est seed.$i maize_$i.sfs maize_$i.sfs.pvalue;done
```
### 3. determine the ancestral state
```
for i in {1..10};do perl anc_est.pl $i;done
```
### 4. the ancestral state of pSNVs
```
psv_rate.pl
```