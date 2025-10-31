### 1. gain the orthologous genes between maize and arabidopsis
```
blastp -db ath.all -query Zea_mays.AGPv4.pep.max.fa -num_threads 30 -out maize2tair.blastp -outfmt 6 -evalue 1e-10
```
### 2. get the kinases and substrates that with phospholayted sites from maize PPIs
```
perl maize_kinase.pl
```
### 3. remain the kinases and substrates that located in same sub-cellular
```
# predicted the sub-cellular location with Plant-mSubP
perl subloc.pl
```
### 4. split S|T to Y sites in maize
```
perl split_sty.pl
```
### 5. preprocessing the kinases and substrates in arabidopsis
```
perl cmb.pl
perl ptm_psp.pl
```
### 6. rename, split S|T to Y sites in arabidopsis
```
perl rename_psp.pl
```
### 7. combine the information of maize and arabidopsis
```
cat ../maize_family_st.psp at_family_st.psp >cmb_family_st.psp
```
### 8. model training
```
maize_model.r
```
### 9. rpSNVs prediction
```
perl muttab.pl
rewriting.r #change the model in Rmimp.R to that we trained

```

### Code for model training was written based on the descriptions in the MIMP (https://www.nature.com/articles/nmeth.3396), "pwm-functions.r" and "Rmimp.R" used in model training and rpSNVs prediction can be obtained through https://github.com/omarwagih/rmimp 
