#!usr/bin/perl -w
open IN,"<maize.$ARGV[0].rm.fa" or die "$!";
%pos=();
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        s/^>//g;
        $id=$_;
    }
    else
    {
        $pos{$id}.=$_;
    }
}
close IN;
open PO,"<pop" or die "$!";
%sample=();
while(<PO>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[1] ne "perennis" && $tmp[1]!~/mix/)
    {
        $sample{$tmp[0]}=1;
    }
}
close PO;
open RA,"<rand_zea" or die "$!";
%rand=();
while(<RA>)
{
    chomp;
    @tmp=split("\t",$_);
    $rand{$tmp[0]}=1;
}
close RA;
open LI,"gzip -dc merge_$ARGV[0].imp.vcf.gz|" or die "$!";
@base=qw/A C G T/;
@out=qw/Cserrulatus Sbicolor/;
@pos1=split("",$pos{$out[0]});
@pos2=split("",$pos{$out[1]});
open OUT,">maize_$ARGV[0].est" or die "$!";
open OUT1,">maize_$ARGV[0].est.pos" or die "$!";
while(<LI>)
{
    if($_=~/^#CHROM/)
    {
        chomp;
        @indv=split("\t",$_);
    }
    if($_=~/^\d/)
    {
        chomp;
        @tmp=split("\t",$_);
        %alt=();
        foreach $i(9..$#tmp)
        {
            if(exists $sample{$indv[$i]})
            {
                @check=split/\|/,$tmp[$i];
                $alt{$check[0]}=1;
                $alt{$check[1]}=1;
            }
        }
        $alt_num=scalar(keys %alt);
        if($alt_num==2)
        {
        %hash=();%count=();
        $k=$tmp[1]-1;
        if($pos1[$k]=~/A|T|C|G/ && $pos2[$k]=~/A|T|C|G/)
        {
            @array=split(",",$tmp[4]);
            $hash{0}=$tmp[3];
            foreach $j(0..$#array)
            {
                $m=$j+1;
                $hash{$m}=$array[$j];
            }
            foreach $i(9..$#tmp)
            {
                if(exists $rand{$indv[$i]})
                {
                    @brray=split/\|/,$tmp[$i];
                    $count{$hash{$brray[0]}}+=1;
                    $count{$hash{$brray[1]}}+=1;
                }
            }
            foreach $key(0..2)
            {
                if(exists $count{$base[$key]})
                {
                    print OUT "$count{$base[$key]},";
                }
                else
                {
                    print OUT "0,";
                }
            }
            if(exists $count{$base[-1]})
            {
                print OUT "$count{$base[-1]} ";
            }
            else
            {
                print OUT "0 ";
            }
            if($pos1[$k] eq "A")
            {
                print OUT "1,0,0,0 ";
            }
            if($pos1[$k] eq "C")
            {
                print OUT "0,1,0,0 ";
            }
            if($pos1[$k] eq "G")
            {
                print OUT "0,0,1,0 ";
            }
            if($pos1[$k] eq "T")
            {
                print OUT "0,0,0,1 ";
            }
            if($pos2[$k] eq "A")
            {
                print OUT "1,0,0,0\n";
            }
            if($pos2[$k] eq "C")
            {
                print OUT "0,1,0,0\n";
            }
            if($pos2[$k] eq "G")
            {
                print OUT "0,0,1,0\n";
            }
            if($pos2[$k] eq "T")
            {
                print OUT "0,0,0,1\n";
            }
            print OUT1 "$tmp[2]\t$tmp[3]\t$pos1[$k]\t$pos2[$k]\n";
        }
        }
    }
}
close LI;
close OUT;
close OUT1;
