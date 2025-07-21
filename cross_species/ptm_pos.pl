#!usr/bin/perl -w
open IN,"<$ARGV[0]_ptm.fa" or die "$!";
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        $id=$_;#print "done.$id.done\n"; exit 0;
    }
    else
    {
        $hash{$id}=length($_);
        $fa{$id}=$_;
    }
}
close IN;
open FI,"<$ARGV[0]_ptm.blastp" or die "$!";
open OUT,">$ARGV[0]_ptm.pos" or die "$!";
while(<FI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[2]==100)
    { #print "done.$tmp[0].done\n";
        $cov=$tmp[3]/$hash{$tmp[0]};
        if($cov==1)
        {
            @array=split("_",$tmp[0]);
            $gpos=$tmp[8]+$array[1]-1;
            $aa=substr($fa{$tmp[0]},$array[1]-1,1);
            print OUT "$tmp[0]\t$array[1]\t$fa{$tmp[0]}\t$tmp[1]\t$gpos\t$aa\t$tmp[-1]\n";
        }
    }
}
close FI;
close OUT;
