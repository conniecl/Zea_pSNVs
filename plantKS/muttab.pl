#!usr/bin/perl -w
open IN,"<merge_all.mutation.add.type" or die "$!";
readline IN;
open OUT,">zea_pmut.tab" or die "$!";
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[-2]=~/fk/)
    {
        if(length($tmp[5])==2)
        {
            $tmp[5]=~s/\,//;
            print OUT "$tmp[6]\t$tmp[4]$tmp[7]$tmp[5]\n";
	    #$gene{$tmp[6]}=1;
        }
    }
}
close OUT;
