library("Biostrings")
library(data.table)
library("mclust")
library(ROCR)
source("pwm-functions.r")

ki<-read.table("cmb_family_st.psp",header=T)
ki_name<-unique(ki$family)
bg_file<-"nonptm_pep.fa"
bg.seq<-.readSequenceData(bg_file)
all_pwm<-list()
rname<-vector()
all_roc<-NULL
fseq<-NULL
co<-1
for (i in 1:length(ki_name))
{
	print(ki_name[i])
	seq<-NULL
	cmb<-NULL
	seq<-ki[which(ki$family==ki_name[i]),]
	if(length(seq$substrate)>4)
	{
	pwm<-PWM(as.list(seq$substrate))
	thred<-sort(mss(sample(bg.seq,10000),pwm))[9000]
	score<-mss(seq$substrate,pwm)
	cmb<-cbind(seq,score)
	#refine the sequence, remove the outer peptide
	while(TRUE)
	{
		if(dim(cmb[which(cmb$score>thred),])[1]==dim(seq)[1])
		{
			break;
		}
		else
		{
			seq<-cmb[which(cmb$score>thred),1:2]
			#print(dim(seq))
			pwm<-PWM(as.list(seq$substrate))
			thred<-sort(mss(sample(bg.seq,10000),pwm))[9000]
			score<-mss(seq$substrate,pwm)
			cmb<-cbind(seq,score)
			#print(sort(cmb$score))
		}
	}
	if(length(seq$substrate)>4)
	{
	fseq<-rbind(fseq,seq)
	mod<-Mclust(mss(seq$substrate,PWM(as.list(seq$substrate))))
	fg<-data.frame(nr=seq(1,length(mod$parameters$pro),1),wts=mod$parameters$pro,means=mod$parameters$mean,sds=mod$parameters$variance$sigmasq)
	#name<-strsplit(ki_name[i],split="/")
	#rname<-append(rname,ki_name[i])
	rseq<-sample(bg.seq,10000)
	rmod<-Mclust(mss(rseq,PWM(rseq)))
	bg<-data.frame(nr=seq(1,length(rmod$parameters$pro),1),wts=rmod$parameters$pro,means=rmod$parameters$mean,sds=rmod$parameters$variance$sigmasq)
	auc<-vector()
	gseq<-matrix(sample(seq$substrate,length(seq$substrate),FALSE),ncol = 10)
	write.table(gseq,file=paste(ki_name[i],"randseq",sep="."))
	oseq<-ki[which(ki$family!=ki_name[i]),]
	for (j in 1:5)
	{
	test<-gseq[,j]
	back<-gseq[,-j]
	tmss<-mss(test,PWM(back))
	rmss<-mss(oseq$substrate,PWM(back))
	testki<-data.frame(mss=tmss,type=rep("control",length(tmss)))
	randki<-data.frame(mss=rmss,type=rep("random",length(rmss)))
	all<-rbind(testki,randki)
	pred <- prediction(predictions = all$mss, labels = all$type ,label.ordering = c("random","control"))
	gauc<-performance(pred, "auc")@y.values[[1]]
	auc<-append(auc,gauc)
	clu_name<-paste(ki_name[i],j,sep="_")
	perf <- performance(pred, "tpr", "fpr")
	all_roc<-rbind(all_roc,cbind(fpr=perf@x.values[[1]],tpr=perf@y.values[[1]],ki=rep(clu_name,length(perf@x.values[[1]]))))
	}
	auc=mean(auc)
	if(auc>0.6)
	{
        rname<-append(rname,ki_name[i])
	all_pwm[[co]]<-list(name=ki_name[i],family=ki_name[i],pwm=PWM(as.list(seq$substrate)),fg.params=fg,bg.params=bg,auc=mean(auc))
	co<-co+1
	}
	}
	}
}
all_pwm<-setNames(all_pwm,rname)
saveRDS(object = all_pwm, file = "maize_kinase_family.rds")
write.table(all_roc,file="maize_kinase_family.roc",sep="\t",quote=F,row.names = F)
write.table(fseq,file="maize_psp_family.filter",sep="\t",quote=F,row.names = F)

