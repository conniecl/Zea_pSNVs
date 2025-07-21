#!usr/bin/perl -w
open PO,"<pop" or die "$!";
readline PO;
%pop=();
while(<PO>)
{
    chomp;
    @tmp=split("\t",$_);
    $pop{$tmp[0]}=$tmp[1];
    #$ind{$tmp[1]}+=1;
}
close PO;
open SE,"<mex_maize.intro.bed" or die "$!";
#readline SE;
%sel=();
while(<SE>)
{
    chomp;
    s/^chr//g;
    @tmp=split("\t",$_);
    #if($tmp[-1] eq "sel")
    #{
        foreach $i($tmp[1]..$tmp[2])
        {
            $sel{$tmp[0]}{$i}=join("_",$tmp[0],$tmp[1]);
        }
    #}
}
close SE;
%anc=();
foreach $chr(1..10)
{
    open AN,"<maize_$chr.anc" or die "$!";
    readline AN;
    while(<AN>)
    {
        chomp;
        @tmp=split("\t",$_);
        $tmp[1]=~s/chr//g;
        @array=split("_",$tmp[1]);
        $anc{$array[0]}{$array[1]}=$tmp[7];
    }
    close AN;
}

open FI,"<merge_all.mutation.add.type" or die "$!";
readline FI;
%hash=();%rcount=();
while(<FI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[-2]=~/fk/ && exists $sel{$tmp[0]}{$tmp[1]} && exists $anc{$tmp[0]}{$tmp[1]} && $tmp[16]>0)
    {
        $hash{$tmp[0]}{$tmp[1]}=$tmp[-2];
        $rcount{$sel{$tmp[0]}{$tmp[1]}}+=1;
        #print "$tmp[0]\t$tmp[1]\n"; exit 0;
    }
}
close FI;
open OUT,">zea_intro.ancpsnv.add.sample" or die "$!";
open OUT1,">zea_intro.ancpsnv.rev.sample" or die "$!";
%add=();%rev=();
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
                            $rev{$name[$i]}{$hash{$tmp[0]}{$tmp[1]}}+=1;
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
}
foreach $key1(keys %add)
{
    foreach $key2(keys %{$add{$key1}})
    {
        print OUT "$key1\t$key2\t$add{$key1}{$key2}\t$pop{$key1}\n";
    }
}
close OUT;
foreach $key1(keys %rev)
{
    foreach $key2(keys %{$rev{$key1}})
    {
        print OUT1 "$key1\t$key2\t$rev{$key1}{$key2}\t$pop{$key1}\n";
    }
}
close OUT1;
open OUT2,">mex_maize.intro.psnv" or die "$!";
foreach $key(keys %rcount)
{
    print OUT2 "$key\t$rcount{$key}\n";
}
