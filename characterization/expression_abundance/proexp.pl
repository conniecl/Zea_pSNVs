#!usr/bin/perl -w
open CH,"<maize.v3TOv4.geneIDhistory.txt" or die "$!";
readline CH;
%change=();
while(<CH>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[1]=~/^Zm/)
    {
        $change{$tmp[1]}{$tmp[0]}=1;
    }
}
close CH;
open IN,"<walley_protein_nsaf_v3.txt" or die "$!";
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
open OUT,">../merge_all.add.protein" or die "$!";
readline FI;
%real=();
while(<FI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[-2]=~/fk/)
    {
        $gene=(split(/\_/,$tmp[6]))[0];
        $count=0;%sum=();
        if(!exists $real{$gene})
        {
            if(exists $change{$gene})
            {
                foreach $key(keys %{$change{$gene}})
                {
                    if(exists $hash{$key})
                    {
                        $count++;
                        @array=split("\t",$hash{$key});
                        foreach $i(0..$#array)
                        {
                            $sum{$i}+=$array[$i];
                        }
                    }
                }
                if($count>0)
                {
                    print OUT "$gene\t";
                    foreach $i(0..31)
                    {
                        $rate=$sum{$i}/$count;
                        print OUT "$rate\t";
                    }
                    $rate=$sum{32}/$count;
                    print OUT "$rate\n";
                }
            }
        }
        $real{$gene}=1;
    }
}
close FI;
close OUT;

foreach $num(1..1000)
{
    open LI,"<rand_$num.mutation.add.domain" or die "$!";
    open OUT,">rand_$num.pexp" or die "$!";
    readline LI;
    %rand=();
    while(<LI>)
    {
        chomp;
        @tmp=split("\t",$_);
        $gene=(split(/\_/,$tmp[6]))[0];
        $count=0;%sum=();
        if(!exists $rand{$gene})
        {
            if(exists $change{$gene})
            {
                foreach $key(keys %{$change{$gene}})
                {
                    if(exists $hash{$key})
                    {
                        $count++;
                        @array=split("\t",$hash{$key});
                        foreach $i(0..$#array)
                        {
                            $sum{$i}+=$array[$i];
			    #print "$gene\t$key\t$i\t$array[$i]\n";
                        }
                    }
                }
                if($count>0)
                {
                    print OUT "$gene\t";
                    foreach $i(0..31)
                    {
                        $rate=$sum{$i}/$count;
                        print OUT "$rate\t";
                    }
                    $rate=$sum{32}/$count;
                    print OUT "$rate\n";
                }
            }
        }
        $rand{$gene}=1;
    }
    close LI;
    close OUT;
}

