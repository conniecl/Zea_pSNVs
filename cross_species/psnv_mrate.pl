#!usr/bin/perl -w
open IN,"<vcf/$ARGV[0].freq.frq" or die "$!";
readline IN;
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    @array=split/:/,$tmp[4];
    @brray=split/:/,$tmp[5];
    if($array[1]>$brray[1])
    {
        $min=$brray[1];
    }
    else
    {
        $min=$array[1];
    }
    $hash{$tmp[0]}{$tmp[1]}=$min;
}
close IN;
open LI,"<$ARGV[1]_psnv.anno" or die "$!";
open OUT,">$ARGV[1]_psnv.frq" or die "$!";
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_,3);
    print OUT "$_\t$hash{$tmp[0]}{$tmp[1]}\n";
}
close LI;
close OUT;
