#!usr/bin/perl -w
open IN,"<merge_all.mutation.add.rate" or die "$!";
readline IN;
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    $hash{$tmp[0]}{$tmp[1]}=$tmp[10];
}
close IN;
open OUT,">$ARGV[0].$ARGV[1].fst.type" or die "$!";
foreach $chr(1..10)
{
    open FI,"gzip -dc $ARGV[0]_$ARGV[1].$chr.Fst.Dxy.pi.csv.gz|" or die "$!";
    readline FI;
    while(<FI>)
    {
        chomp;
        @tmp=split(",",$_);
        if($tmp[-1] ne "nan")
        {
            if($tmp[-1]<0)
            {
                $tmp[-1]=0;
            }
	    print OUT "$ARGV[0]_$ARGV[1]\t$tmp[-1]\t$hash{$tmp[0]}{$tmp[1]}\n";
            $sum{$hash{$tmp[0]}{$tmp[1]}}+=$tmp[-1];
            $count{$hash{$tmp[0]}{$tmp[1]}}+=1;
        }
    }
    close FI;
}
foreach $key(keys %sum)
{
    $rate=$sum{$key}/$count{$key};
    print "$ARGV[0]\t$ARGV[1]\t$key\t$rate\n";
}
