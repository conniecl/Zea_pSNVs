#!usr/bin/perl -w
open IN,"<ptm_protein.pos" or die "$!";
%hash=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    $pep=join(":",$tmp[0],$tmp[1]);
    $b73=join(":",$tmp[3],$tmp[4]);
    $hash{$pep}{$b73}=1;
}
close IN;
%ref=();
foreach $key1(keys %hash)
{
    $len=scalar(keys %{$hash{$key1}});
    foreach $key2(keys %{$hash{$key1}})
    {
        $rate=$hash{$key1}{$key2}/$len;
        @array=split/_/,$key1;
        $ref{$key2}{$array[0]}+=$rate;
        $sum{$key2}{$array[0]}+=1;
    }
}
open OUT,">ptm_protein.weight" or die "$!";
foreach $key1(keys %ref)
{
    $r=0;
    foreach $key2(keys %{$ref{$key1}})
    {
        $r+=($ref{$key1}{$key2}/$sum{$key1}{$key2});
    }
    @array=split/\:/,$key1;
    print OUT "$array[0]\t$array[1]\t$r\n";
}
close OUT;
