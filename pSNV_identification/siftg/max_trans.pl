#!usr/bin/perl -w
open IN,"gzip -dc Zea_mays.AGPv4.pep.all.fa.gz|" or die "$!";
open OUT,">Zea_mays.AGPv4.pep.max.fa" or die "$!";
%gene=();%hash=();
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        $_=~/gene:(.*?) transcript:(.*?) gene_biotype/;
        $trans=$2;
        $gene{$1}{$trans}=1; #print "$1\t$2\n";
    }
    else
    {
        $hash{$trans}.=$_;
    }
}
close IN;
%maxtrans=();
foreach $key1(keys %gene)
{
    $max=0;$flag="";
    foreach $key2(keys %{$gene{$key1}})
    {
        $len=length($hash{$key2});
        if($len>$max)
        {
            $flag=$key2;
            $max=$len;
        }
    }
    $maxtrans{$flag}=1;
    print OUT ">$flag\n$hash{$flag}\n";
}
close OUT;
open LI,"gzip -dc Zea_mays.AGPv4.40.gtf.gz|" or die "$!";
open OUT1,">Zea_mays.AGPv4.40.max.gtf" or die "$!";
while(<LI>)
{
    @tmp=split("\t",$_);
    $tmp[-1]=~/transcript_id \"(.*?)\";/;
    if(exists $maxtrans{$1})
    {
        print OUT1 "$_";
    }
}
close LI;
close OUT1;
