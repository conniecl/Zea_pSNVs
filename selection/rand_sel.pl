#!usr/bin/perl -w
use List::Util qw/shuffle/;
open SE,"<teo_maize.sel.bed" or die "$!";
#readline SE;
%sel=();
while(<SE>)
{
    chomp;
    @tmp=split("\t",$_);
    #if($tmp[-1] eq "sel")
    #{
        foreach $i($tmp[1]..$tmp[2])
        {
            $sel{$tmp[0]}{$i}=join("_",$tmp[0],$tmp[1]); #chr_pos
        }
    #}
}
close SE;
open LI,"<merge_all.mutation.add.rate" or die "$!";
readline LI;
%nsys=();
while(<LI>)
{
    @tmp=split("\t",$_);
    if($tmp[18]>0 && $tmp[10] eq "other")
    {
        if(exists $sel{$tmp[0]}{$tmp[1]})
        {
            push @{$nsys{$sel{$tmp[0]}{$tmp[1]}}},$tmp[1];
        }
    }
}
close LI;
open IN,"<par_maize.sel.psnv" or die "$!";
%hash=();$outregion=0;
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $nsys{$tmp[0]})
    {
    @array=@{$nsys{$tmp[0]}};
    #print "@array\n"; exit 0;
    @shuffled_array = shuffle(@array);
    @brray=split/\_/,$tmp[0];
    foreach $i(0..$tmp[1]-1)
    {
        if($i<$#shuffled_array)
        {
            $hash{$brray[0]}{$shuffled_array[$i]}=1;
            print "$tmp[0]\t$tmp[1]\t$brray[0]\t$shuffled_array[$i]\n";
        }
        else
        {
            $outregion++;
        }
    }
    }
    else
    {
        $outregion+=$tmp[1];
    }
}
close IN;
$add=0;
foreach $key1(keys %nsys)
{
    @s=split/\_/,$key1;
    foreach $key2(@{$nsys{$key1}})
    {
        if(!exists $hash{$s[0]}{$key2} && $add<$outregion)
        {
            $add++;
            $hash{$brray[0]}{$key2}=1;
            print "$s[0]\t$s[1]\t$key2\tadd\n";
            last;
        }
    }
}
open PO,"<pop" or die "$!";
readline PO;
%pop=();
while(<PO>)
{
    chomp;
    @tmp=split("\t",$_);
    $pop{$tmp[0]}=$tmp[1]; #sample population
    #$ind{$tmp[1]}+=1;
}
close PO;
open OUT,">zea_sel.ancpsnv.rand.sample" or die "$!";
%add=();
foreach $chr(1..10)
{
    open LI,"gzip -dc merge_$chr.imp.vcf.gz|" or die "$!";
    while(<LI>)
    {
        chomp;
        if($_=~/^#CHROM/)
        {
            @name=split("\t",$_);
        }
        if($_=~/^\d/)
        {
            @tmp=split("\t",$_);
            #%add=();%rev=();#print "$_\n"; exit 0;
            if(exists $hash{$tmp[0]}{$tmp[1]})
            {
                foreach $i(9..$#tmp)
                {
                    if($tmp[$i]!~/^0\|0/)
                    {
                        @brray=split/\|/,$tmp[$i];
                        if($brray[0] eq $brray[1])
                        {
                            $add{$name[$i]}{$hash{$tmp[0]}{$tmp[1]}}+=2;
                        }
                        else
                        {
                            $add{$name[$i]}{$hash{$tmp[0]}{$tmp[1]}}+=1;
                        }
                    }
                }
            }
        }
    }
    close LI;
}
foreach $key1(keys %add)
{
    foreach $key2(keys %{$add{$key1}})
    {
        print OUT "$key1\t$key2\t$add{$key1}{$key2}\t$pop{$key1}\n";
    }
}
close OUT;

