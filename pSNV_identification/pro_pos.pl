#!usr/bin/perl -w
open IN,"<phopeptide.fa" or die "$!";
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        $id=$_;
    }
    else
    {
        $hash{$id}=length($_);
        $fa{$id}=$_;
    }
}
close IN;
open FI,"<ptm_v4.blastp" or die "$!";
open OUT,">ptm_protein.pos" or die "$!";
%count=();
while(<FI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[2]==100 && exists $hash{$tmp[0]})
    {
        $cov=$tmp[3]/$hash{$tmp[0]};
        if($cov==1)
        {
            @array=split("_",$tmp[0]);
            foreach $i(2..$#array)
            {
                $gpos=$tmp[8]+$array[$i]-1;
                $aa=substr($fa{$tmp[0]},$array[$i]-1,1);
                print OUT "$array[0]_$array[1]\t$array[$i]\t$fa{$tmp[0]}\t$tmp[1]\t$gpos\t$aa\t$tmp[-1]\n";
            }
            $m=join("_",$array[0],$array[1]);
            $count{$m}+=1;
        }
    }
}
close FI;
close OUT;
open OUT1,">ptm_protein.align.count" or die "$!";
foreach $key(keys %count)
{
    print OUT1 "$key\t$count{$key}\n";
}
close OUT1;
