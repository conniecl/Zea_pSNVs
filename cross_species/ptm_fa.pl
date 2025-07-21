#!usr/bin/perl -w
open IN,"<../ph_allSPECIES.txt" or die "$!";
readline IN;
open OUT,">$ARGV[0]_ptm.fa" or die "$!";
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[1] eq $ARGV[0])
    {
        print OUT ">pep$.";
        print OUT "_$tmp[-1]\n$tmp[-2]\n";
    }
}
close IN;
close OUT;
