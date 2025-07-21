#!usr/bin/perl -w
open IN,"<walley_fpkm.txt" or die "$!";
readline IN;
%hash=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_,2);
    $hash{$tmp[0]}=$tmp[1];
}
close IN;
open FI,"<../merge_all.mutation.add.type" or die "$!";
open OUT,">../merge_all.add.exp" or die "$!";
readline FI;
%real=();
while(<FI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[-2]=~/fk/)
    {
        $gene=(split(/\_/,$tmp[6]))[0];
        if(!exists $real{$gene})
        {
            print OUT "$gene\t$hash{$gene}\n";
        }
        $real{$gene}=1;
    }
}
close FI;
close OUT;
#=pod
foreach $num(1..1000)
{
    open LI,"<rand_$num.mutation.add.domain" or die "$!";
    open OUT,">rand_$num.exp" or die "$!";
    readline LI;
    %rand=();
    while(<LI>)
    {
        chomp;
        @tmp=split("\t",$_);
        $gene=(split(/\_/,$tmp[6]))[0];
        if(!exists $rand{$gene})
        {
            print OUT "$gene\t$hash{$gene}\n";
        }
        $rand{$gene}=1;
    }
    close LI;
    close OUT;
}
#=cut
