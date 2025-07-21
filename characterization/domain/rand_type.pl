#!usr/bin/perl -w
open LE,"<Zea_mays.AGPv4.pep.max.fa" or die "$!";
%len=();
while(<LE>)
{
    chomp;
    if($_=~/^>/)
    {
	s/>//g;
        $id=$_;
    }
    else
    {
        $len{$id}=length($_);
    }
}
close LE;
@file=qw/s t y/;
%hash=();
foreach $in(@file)
{
    open IN,"<$ARGV[0].$in" or die "$!";
    while(<IN>)
    {
        chomp;
        @tmp=split("\t",$_);
        $hash{$tmp[0]}{$tmp[1]}=0;
        $up7=$tmp[1]-7;
        $down7=$tmp[1]+7;
        if($up7<1)
        {
            $up7=1;
        }
        if($down7>$len{$tmp[0]})
        {
            $down7=$len{$tmp[0]};
        }
        foreach $i($up7..$down7)
        {
            $loc=$tmp[1]-$i;
            if(!exists $hash{$tmp[0]}{$i})
            {
                $hash{$tmp[0]}{$i}=$loc;
            }
            else
            {
                if(abs($loc)<abs($hash{$tmp[0]}{$i}))
                {
                    $hash{$tmp[0]}{$i}=$loc;
                }
            }
        }
    }
    close IN;
}
open OUT,">rand_$ARGV[0].mutation.add.domain" or die "$!";
open LI,"<../merge_all.mutation.add.type" or die "$!";
$header=<LI>;
print OUT "$header";
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $hash{$tmp[6]}{$tmp[7]})
    {
        foreach $i(0..$#tmp-2)
        {
            print OUT "$tmp[$i]\t";
        }
        print OUT "fk$hash{$tmp[6]}{$tmp[7]}\t$tmp[-1]\n";
    }
}
close LI;
close OUT;
