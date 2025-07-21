source("Rmimp.R")
# Get the path to example mutation data 
mut.file = "ms_mut.tab"

# Get the path to example FASTA sequence file 
seq.file = "../Zea_mays.AGPv4.pep.max.fa"

# Get the path to example FASTA sequence file 
#psite.file = "ptm_protein.tab"
psite.file = "ptm_protein.tab"

results = mimp(mut.file, seq.file, psite.file, display.results=TRUE,include.cent=TRUE)
test<-head(results,50)
results2html(test)
write.table(results,file="ms_psnv.mimp",sep="\t",quote=F,row.names = F)
