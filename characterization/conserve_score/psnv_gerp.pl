#!usr/bin/perl -w
open IN,"<merge_all.mutation.add.type" or die "$!";
$header=<IN>;
chomp($header);
@name=split("\t",$header);
open OUT,">psnv_gerp.dis" or die "$!";
print OUT "gerp\tsample\ttype\n";
#open OUT,">psnv_sift.dis" or die "$!";
#print OUT "sift\tsample\ttype\n";
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[9] ne "NA")
    {
	    #if($tmp[-1] ne "other")
	    #{
	    #$tmp[-1]="psnv";
		#}
        foreach $i(10..$#tmp-1)
        {
            if($tmp[$i]>0)
            {
		    print OUT "$tmp[9]\t$name[$i]\t$tmp[-1]\n";
		    #print OUT "$tmp[8]\t$name[$i]\t$tmp[-1]\n";
            }
        }
	print OUT "$tmp[9]\tall\t$tmp[-1]\n";
	#print OUT "$tmp[8]\tall\t$tmp[-1]\n";
	}
}
close IN;
close OUT;
