#!usr/bin/perl -w
open IN,"gzip -dc Araport11_pep_20240409.gz|" or die "$!";
#open IN,"<test.fa";
%hash=();
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        $id=(split/\s+/,$_)[0];
    }
    else
    {
        s/\*$//;
        $hash{$id}.=$_;
    }
}
close IN;
open FI,"<kinase.uniq" or die "$!";
readline FI;
%ki=();
while(<FI>)
{
    chomp;
    @tmp=split("\t",$_);
    $ki{$tmp[0]}{$tmp[1]}=$tmp[2];
}
close FI;
open LI,"<phosphat.kinase" or die "$!";
readline LI;
open OUT,">ptm_protein.psp" or die "$!";
print OUT "kinase\tfamily\ttarget\ttseq\tpubmed\ttype\n";
%site=();
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $ki{$tmp[0]}{$tmp[1]} && $ki{$tmp[0]}{$tmp[1]} eq $tmp[2] && $tmp[5]=~/^AT/ && $tmp[6]=~/^S|^T|^Y/)
    {
        $len=length($hash{$tmp[5]}); #print "len:$len\t$hash{$tmp[0]}\n";
        @array=split/;\s+|;|,\s+/,$tmp[6]; #print "@array\n"; exit 0;
        foreach $key(@array)
        {
            $aa="";
            $phy=substr($key,0,1);
	    $key=~s/^S|^T|^Y//;
	    #print "$key\n"; exit 0;
            if(!exists $site{$tmp[5]}{$key})
            {
            $site{$tmp[5]}{$key}=1;
            if($key<8)
            {
                $aa.="_"x(8-$key);
                $remain=$len-$key; #print "remain:$remain\n";
                if($remain>=8)
                {
                    $aa.=substr($hash{$tmp[5]},0,7+$key); #print "$aa\n";
                }
                else
                {
                    $aa.=$hash{$tmp[5]};
                    $aa.="_"x(7+$key-$len);
                }
            }
            else
            {
                $remain=$len-$key;
                if($remain>=8)
                {
                    $aa=substr($hash{$tmp[5]},$key-8,15);
                }
                else
                {
                    $aa.=substr($hash{$tmp[5]},$key-8,15);
                    $aa.="_"x(7-($len-$key));
                }
            }
            print OUT "$tmp[0]\t$tmp[2]\t$tmp[5]_$key\t$aa\t$tmp[-1]\t";
            $mid=substr($aa,7,1);
            if($mid eq $phy)
            {
                print OUT "same\n";
            }
            else
            {
                print OUT "diff\n";
            }
            }
        }
    }
}
close LI;
close OUT;
