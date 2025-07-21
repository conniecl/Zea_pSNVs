#!usr/bin/perl -w
@list=();%fst=();
foreach $chr(1..10)
{
    open IN,"gzip -dc $ARGV[0]_$ARGV[1].$chr.Fst.Dxy.pi.csv.gz|" or die "$!";
    readline IN;
    while(<IN>)
    {
        chomp;
        @tmp=split(",",$_);
=pod
        if($tmp[7]!~/^\d/ || $tmp[7]<0)
        {
	    $tmp[7]=0;
        }
        $fst{$tmp[0]}{$tmp[1]}=$tmp[7];
        push @list,$tmp[7];
=cut
	#=pod
	if($tmp[8]!~/^\d/ || $tmp[8]<0)
	{
	     $tmp[8]=0;
        }
	$fst{$tmp[0]}{$tmp[1]}=$tmp[8];
	push @list,$tmp[8];
	#=cut

    }
    close IN;
}
$index=0.1*(scalar(@list));
@list=sort{$b <=> $a} @list;
open LI,"<merge_all.mutation.add.rate" or die "$!";
#open OUT,">$ARGV[0]_$ARGV[1].psnv_top10.dxy" or die "$!";
open OUT,">$ARGV[0]_$ARGV[1].psnv_top10.fst" or die "$!";
print OUT "chr\tpos\tgene\t$ARGV[0]\t$ARGV[1]\tfst\ttype\n";
readline LI;
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    #print "$tmp[$ARGV[2]]\n"; exit 0;
    if($tmp[10] eq "psnv")
    {
        if($tmp[$ARGV[2]]!=0 || $tmp[$ARGV[3]]!=0 )
        {
            if(exists $fst{$tmp[0]}{$tmp[1]} && $fst{$tmp[0]}{$tmp[1]}>$list[$index])
            {
                print OUT "$tmp[0]\t$tmp[1]\t$tmp[6]\t$tmp[$ARGV[2]]\t$tmp[$ARGV[3]]\t$fst{$tmp[0]}{$tmp[1]}\t";
                if($tmp[$ARGV[2]]>$tmp[$ARGV[3]])
                {
                    print OUT "gain\n";
                }
                else
                {
                    print OUT "loss\n";
                }
		#print "$tmp[0]\t$tmp[1]\t$fst{$tmp[0]}{$tmp[1]}\tsel\n";
            }
        }
    }
=pod
    else
    {
		    print "$tmp[0]\t$tmp[1]\t$fst{$tmp[0]}{$tmp[1]}\tother\n";
    }
=cut
}
close LI;
close OUT;
