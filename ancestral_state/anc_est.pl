#!usr/bin/perl -w
use List::Util qw/sum/;
open SO,"<maize.$ARGV[0].score" or die "$!";
readline SO;
while(<SO>)
{
    chomp;
    @tmp=split("\t",$_);
    $pos=join("","chr",$tmp[0],"_",$tmp[1]);
    $score{$pos}=join("\t",$tmp[3],$tmp[5]);
}
close SO;
open FI,"<maize_$ARGV[0].sfs.pvalue" or die "$!";
while(<FI>)
{
    if($_!~/^0/)
    {
        chomp;
        @tmp=split/\s+/,$_;
        $pvalue{$tmp[0]}=$tmp[2];
    }
}
close FI;
open IN,"<maize_$ARGV[0].est.pos" or die "$!";
@base=qw/A C G T/;
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    foreach $i(0..$#base)
    {
        if($tmp[1] eq $base[$i])
        {
            $ref{$.}=$i;
        }
    }
    $pos{$.}=$tmp[0];
}
close IN;
open LI,"<maize_$ARGV[0].est" or die "$!";
open OUT,">maize_$ARGV[0].anc" or die "$!";
print OUT "line\tpos\tref\tref_count\talt_count\tgerp\tsift\tstate\tp_anc\n";
while(<LI>)
{
    chomp;
    #$zero=0;
    @tmp=split/\s+/,$_;
    @array=split/,/,$tmp[0]; #foreach $z(@array){if($z==0){$zero++;}}
    $ref_count=$array[$ref{$.}];
    $alt_count=sum(@array)-$array[$ref{$.}];
    #if($zero==2)
    #{
    if($pvalue{$.}>=0.55)
    {
        print OUT "$.\t$pos{$.}\t$base[$ref{$.}]\t$ref_count\t$alt_count\t$score{$pos{$.}}\t";
        if($ref_count>$alt_count)
        {
            print OUT "Ancestral\t$pvalue{$.}\n";
        }
        else
        {
            print OUT "Derived\t$pvalue{$.}\n";
        }
    }
    if($pvalue{$.}<=0.45)
    {
        print OUT "$.\t$pos{$.}\t$base[$ref{$.}]\t$ref_count\t$alt_count\t$score{$pos{$.}}\t";
        if($ref_count>$alt_count)
        {
            print OUT "Derived\t$pvalue{$.}\n";
        }
        else
        {
            print OUT "Ancestral\t$pvalue{$.}\n";
        }
    }
    #}
}
close LI;
close OUT;
