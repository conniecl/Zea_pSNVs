#!usr/bin/perl -w
%gerp=();
open GE,"<maize.$ARGV[0].gerp" or die "$!";
while(<GE>)
{
    chomp;
    @tmp=split("\t",$_);
    $gerp{$tmp[1]}=$tmp[-1];
}
close GE;
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
open IN,"<zea_$ARGV[0]_SIFTannotations.xls" or die "$!";
readline IN;
%hash=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[8] eq "NONSYNONYMOUS")
    {
        $hash{$tmp[1]}{$tmp[2]}=$tmp[9];
        $hash{$tmp[1]}{$tmp[3]}=$tmp[10];
        $protein{$tmp[1]}=join("\t",$tmp[4],$tmp[11],$tmp[12]);
    }
}
close IN;
%sample=();
open LI,"gzip -dc merge_$ARGV[0].imp.vcf.gz|" or die "$!";
open OUT,">merge_$ARGV[0].mutation.add.site" or die "$!";
open OUT1,">merge_$ARGV[0].mutation.rev.site" or die "$!";
@list=qw/teo_mix nicaraguensis luxurians diploperennis perennis huehuetenangensis mexicana parviglumis TST TEM maize_mix/;
print OUT "chr\tpos\tref\talt\trefaa\taltaa\tgene\tloc\tsift\tgerp\tteo_mix\tnicaraguensis\tluxurians\tdiploperennis\tperennis\thuehuetenangensis\tmexicana\tparviglumis\tTST\tTEM\tmaize_mix\n";
print OUT1 "chr\tpos\tref\talt\trefaa\taltaa\tgene\tloc\tsift\tgerp\tteo_mix\tnicaraguensis\tluxurians\tdiploperennis\tperennis\thuehuetenangensis\tmexicana\tparviglumis\tTST\tTEM\tmaize_mix\n";
while(<LI>)
{
    chomp;
    if($_=~/^#CHROM/)
    {
        @name=split("\t",$_);
    }
    if($_=~/^\d/)
    {
        %alt=();
        @tmp=split("\t",$_);
        @array=split(",",$tmp[4]);
        foreach $i(0..$#array)
        {
            $j=$i+1;
            $alt{$j}=$array[$i];
        }
        %add=();%rev=();
        if(exists $hash{$tmp[1]})
        {
            foreach $i(9..$#tmp)
            {
                @brray=split/\|/,$tmp[$i];
                foreach $m(0..1)
                {
                    if($brray[$m] ne 0 && exists $hash{$tmp[1]}{$alt{$brray[$m]}})
                    {
                        $add{$pop{$name[$i]}}+=1;
                        $sample{$name[$i]}{"add"}+=1;
                    }
                }
                if($brray[0] ne 0 && $brray[0] eq $brray[1])
                {
                    if(exists $hash{$tmp[1]}{$alt{$brray[0]}})
                    {
                        $rev{$pop{$name[$i]}}+=1;
                        $sample{$name[$i]}{"rev"}+=1;
                    }
                }
            }
            print OUT "$tmp[0]\t$tmp[1]\t$tmp[3]\t$tmp[4]\t$hash{$tmp[1]}{$tmp[3]}\t";
            print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[3]\t$tmp[4]\t$hash{$tmp[1]}{$tmp[3]}\t";
            foreach $n(@array)
            {
                if(exists $hash{$tmp[1]}{$n})
                {
                    print OUT "$hash{$tmp[1]}{$n},";
                    print OUT1 "$hash{$tmp[1]}{$n},";
                }
            }
            print OUT "\t$protein{$tmp[1]}\t";
            print OUT1 "\t$protein{$tmp[1]}\t";
            if(exists $gerp{$tmp[1]})
            {
                print OUT "$gerp{$tmp[1]}\t";
                print OUT1 "$gerp{$tmp[1]}\t";
            }
            else
            {
                print OUT "NA\t";
                print OUT1 "NA\t";
            }
            foreach $k(@list)
            {
                if(exists $add{$k})
                {
                    #$rate=$add{$k}/(2*$ind{$k});
                    #print OUT "$rate\t";
                    print OUT "$add{$k}\t";
                }
                else
                {
                    print OUT "0\t";
                }
                if(exists $rev{$k})
                {
                    #$rate=$rev{$k}/$ind{$k};
                    #print OUT1 "$rate\t";
                    print OUT1 "$rev{$k}\t";
                }
                else
                {
                    print OUT1 "0\t";
                }
            }
            print OUT "\n";
            print OUT1 "\n";
        }
    }
}
close OUT;
close OUT1;
=pod
open OUT2,">merge_$ARGV[0].sty.sample" or die "$!";
foreach $key1(keys %sample)
{
    foreach $key2(keys %{$sample{$key1}})
    {
        print OUT2 "$key1\t$key2\t$sample{$key1}{$key2}\t$pop{$key1}\n";
    }
}
close OUT2;
=cut
