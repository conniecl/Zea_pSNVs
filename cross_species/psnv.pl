#!usr/bin/perl -w
#open LI,"gzip -dc proteom/proteome.all_transcripts.ath.fasta.gz|" or die "$!";
open LI,"<proteom/$ARGV[0].max.pep" or die "$!";
%len=();
while(<LI>)
{
    chomp;
    if($_=~/^>/)
    {
        s/^>//g;
	#$id=(split/\s+/,$_)[0];
	$id=$_;
    }
    else
    {
        $len{$id}=length($_);
    }
}
close LI;
open IN,"<$ARGV[0]_fk0.anno" or die "$!";
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[-1] eq "fk0")
    {
        $hash{$tmp[6]}{$tmp[7]}=0;
        $up7=$tmp[7]-7;
        $down7=$tmp[7]+7;
        if($up7<1)
        {
            $up7=1;
        }
        if($down7>$len{$tmp[6]})
        {
            $down7=$len{$tmp[6]};
        }
        foreach $i($up7..$down7)
        {
            $loc=$tmp[7]-$i;
            if(!exists $hash{$tmp[6]}{$i})
            {
                $hash{$tmp[6]}{$i}=$loc;
            }
            else
            {
                if(abs($loc)<abs($hash{$tmp[6]}{$i}))
                {
                    $hash{$tmp[6]}{$i}=$loc;
                }
            }
        }
    }
}
close IN;
open IN,"<$ARGV[0]_fk0.anno" or die "$!";
open OUT,">$ARGV[0]_psnv.anno" or die "$!";
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $hash{$tmp[6]}{$tmp[7]})
    {
        print OUT "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\tfk$hash{$tmp[6]}{$tmp[7]}\n";
    }
    else
    {
        print OUT "$_\n";
    }
}
close IN;
close OUT;
