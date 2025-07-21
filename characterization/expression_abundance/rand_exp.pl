#!usr/bin/perl -w
open KI,"<walley_fpkm.txt" or die "$!";
readline KI;
%hash=();
while(<KI>)
{
    chomp;
    @tmp=split("\t",$_,2);
    $hash{$tmp[0]}=$tmp[1];
}
close KI;
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
%pro=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_,2);
    $pro{$tmp[0]}=$tmp[1];
}
close IN;
foreach $num(1..1000)
{
    $rand=`grep -w "other" ../merge_all.mutation.add.type |cut -f 7|sort|uniq|shuf -n 6390`;
    @line=split("\n",$rand);
    open OUT,">rand_$num.exp" or die "$!";
    open OUT1,">rand_$num.pexp" or die "$!";
    foreach $l(@line)
    {
        $l=~s/\>//g;
        $gene=(split(/\_/,$l))[0];
        if(exists $hash{$gene})
        {
            print OUT "$gene\t$hash{$gene}\n";
        }
        $count=0;%sum=();
        if(exists $change{$gene})
        {
            foreach $key(keys %{$change{$gene}})
            {
                if(exists $pro{$key})
                {
                    $count++;
                    @array=split("\t",$pro{$key});
                    foreach $i(0..$#array)
                    {
                        $sum{$i}+=$array[$i];
                    }
                }
            }
            if($count>0)
            {
                print OUT1 "$gene\t";
                foreach $i(0..31)
                {
                    $rate=$sum{$i}/$count;
                    print OUT1 "$rate\t";
                }
                $rate=$sum{32}/$count;
                print OUT1 "$rate\n";
            }
        }
    }
    close OUT;
    close OUT1;
}


