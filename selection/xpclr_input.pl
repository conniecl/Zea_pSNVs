#!usr/bin/perl -w
@file=qw/parviglumis maize_rand/;
%hash=();
foreach $in(@file)
{
    open LI,"<$in" or die "$!";
    while(<LI>)
    {
        chomp;
        $hash{$_}=$in;
    }
    close LI;
}
open IN,"gzip -dc merge_$ARGV[0].imp.vcf.gz|" or die "$!";
open OUT,">teo.$ARGV[0].geno" or die "$!";
open OUT1,">maize.$ARGV[0].geno" or die "$!";
open OUT2,">teo_maize.$ARGV[0].pos" or die "$!";
while(<IN>)
{
    if($_=~/^#CHROM/)
    {
        chomp;
        @array=split("\t",$_);
    }
    if($_=~/^\d/)
    {
        chomp;
        @tmp=split("\t",$_);
        %cteo=();%cmaize=();$steo=0;$smaize=0;$flag=0;
        if(length($tmp[4])==1)
        {
        foreach $i(9..$#tmp)
        {
            @brray=split/\|/,$tmp[$i];
            if(exists $hash{$array[$i]})
            {
                if($hash{$array[$i]} eq "parviglumis")
                {
                    $cteo{$brray[0]}+=1;
                    $cteo{$brray[1]}+=1;
                    $steo+=2;
                    #$fh{$tmp[0]}->print("$brray[0] $brray[1] ");
                }
                else
                {
                    $cmaize{$brray[0]}+=1;
                    $cmaize{$brray[1]}+=1;
                    #$fh1{$tmp[0]}->print("$brray[0] $brray[1] ");
                    $smaize+=2;
                }
            }
        }
        foreach $key(keys %cteo)
        {
            $tmaf=$cteo{$key}/$steo;
            if($tmaf<0.01||$tmaf>0.99)
            {
                $flag=1;
            }
        }
        foreach $key(keys %cmaize)
        {
            $tmaf=$cmaize{$key}/$smaize;
            if($tmaf<0.01||$tmaf>0.99)
            {
                $flag=1;
            }
        }
        if($flag==0)
        {
            foreach $i(9..$#tmp)
            {
                if(exists $hash{$array[$i]})
                {
                    @brray=split/\|/,$tmp[$i];
                    if($hash{$array[$i]} eq "parviglumis")
                    {
                        print OUT "$brray[0] $brray[1] ";
                    }
                    else
                    {
                        print OUT1 "$brray[0] $brray[1] ";
                    }
                }
            }
            print OUT2 "$tmp[0]\t$tmp[1]\t$tmp[3]\t$tmp[4]\n";
            print OUT "\n";
            print OUT1 "\n";
        }
        }
    }
}
close IN;
