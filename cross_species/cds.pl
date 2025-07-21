#!usr/bin/perl -w
#open LI,"gzip -dc cds.all_transcripts.$ARGV[0].fasta.gz|" or die "$!";
open LI,"gzip -dc Taestivumcv_ChineseSpring_725_v2.1.cds.fa.gz|" or die "$!";
while(<LI>)
{
    chomp;
    if($_=~/^>/)
    {
        $name=(split/\s+/,$_)[0];
    }
    else
    {
        $hash{$name}.=$_;
    }
}
open IN,"<$ARGV[0].max.pep" or die "$!";
open OUT,">$ARGV[0].max.cds" or die "$!";
while(<IN>)
{
    if($_=~/^>/)
    {
        chomp;
        print OUT "$_\n$hash{$_}\n";
    }
}
close IN;
close OUT;
