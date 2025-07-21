#!usr/bin/perl -w
@file=glob("*.csv");
foreach $in(@file)
{
    open IN,"<$in" or die "$!";
    readline IN;
    while(<IN>)
    {
        s/\"//g;
        @tmp=split/,/,$_,4;
        @array=split/\_/,$tmp[1];
        $hash{$array[0]}=$tmp[2];
    }
    close IN;
}
open LI,"<kinase_substrate.ppi" or die "$!";
readline LI;
open OUT,">kinase_substrate.subcell" or die "$!";
print OUT "kinase\tseq\n";
open OUT1,">kinase_substrate.subcell.detail" or die "$!";
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($hash{$tmp[0]} eq $hash{$tmp[1]})
    {
        $tmp[2]=~s/\//_/g;
        print OUT "$tmp[2]\t$tmp[4]\n";
	print OUT1 "$_\t$hash{$tmp[0]}\n";
    }
}
close LI;
close OUT;
close OUT1;
