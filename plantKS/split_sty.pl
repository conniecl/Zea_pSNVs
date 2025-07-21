#!usr/bin/perl -w
open LI,"<kinase_substrate.subcell" or die "$!";
readline LI;
open OUT,">maize_family_st.psp" or die "$!";
print OUT "family\tsubstrate\n";#kinase\n";
open OUT1,">maize_family_y.psp" or die "$!";
print OUT1 "family\tsubstrate\n";#kinase\n";
#open OUT,">at_ind_st.psp" or die "$!";
#open OUT1,">at_ind_y.psp" or die "$!";
#print OUT "kinase\tsubstrate\n";
#print OUT1 "kinase\tsubstrate\n";
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    $tmp[0]=~s/\//_/g;
    #if($tmp[-1] eq "same")
    #{
    #   $tmp[1]=~s/ //g;
        $sub=substr($tmp[1],7,1);
        if($sub=~/S|T/)
        {
        print OUT "$tmp[0]\t$tmp[1]\n";
        #print OUT "$tmp[1]/$hash{$tmp[0]}\t$tmp[3]\n";
        }
        else
        {
                #print OUT1 "$tmp[1]/$hash{$tmp[0]}\t$tmp[3]\n";
                print OUT1 "$tmp[0]\t$tmp[1]\n";
        }
	#}
}
close LI;
close OUT;
close OUT1;
