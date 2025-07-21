#!usr/bin/perl -w
open IN,"<phopeptide.all" or die "$!";
open OUT,">phopeptide.fa" or die "$!";
while(<IN>)
{
    if($_!~/^ref\t/)
    {
        chomp;
        @tmp=split("\t",$_);
        print OUT ">$tmp[0]_$tmp[2]\n$tmp[1]\n";
    }
}
close IN;
close OUT;
