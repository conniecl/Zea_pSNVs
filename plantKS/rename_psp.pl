#!usr/bin/perl -w
open IN,"gzip -dc Araport11_pep_20240409.gz|" or die "$!";
%hash=();
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        @tmp=split/ \|/,$_;
        if($tmp[1]=~/no symbol ava/)
        {
            $name=(split/\./,$tmp[0])[0];
        }
        else
        {
            $name=(split/:|,|\s+/,$tmp[1])[3]
        }
        $hash{$tmp[0]}=$name;
    }
}
close IN;
open LI,"<ptm_protein.psp" or die "$!";
readline LI;
open OUT,">at_family_st.psp" or die "$!";
print OUT "family\tsubstrate\n";#kinase\n";
open OUT1,">at_family_y.psp" or die "$!";
print OUT1 "family\tsubstrate\n";#kinase\n";
#open OUT,">at_ind_st.psp" or die "$!";
#open OUT1,">at_ind_y.psp" or die "$!";
#print OUT "kinase\tsubstrate\n";
#print OUT1 "kinase\tsubstrate\n";
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[-1] eq "same")
    {
        $tmp[1]=~s/ //g;
	$sub=substr($tmp[3],7,1);
	if($sub=~/S|T/)
	{
	print OUT "$tmp[1]\t$tmp[3]\n";
	#print OUT "$tmp[1]/$hash{$tmp[0]}\t$tmp[3]\n";
        }
        else
	{
		#print OUT1 "$tmp[1]/$hash{$tmp[0]}\t$tmp[3]\n";
		print OUT1 "$tmp[1]\t$tmp[3]\n";
	}
    }
}
close LI;
close OUT;
