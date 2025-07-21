#!usr/bin/perl -w
open IN,"<at.kinase" or die "$!";
while(<IN>)
{
    chomp;
    @tmp=split/\s+/,$_;
    $hash{$tmp[0]}{$tmp[1]}=1;
}
close IN;
open FA,"<ptm_protein.psp" or die "$!";
%pep=();
while(<FA>)
{
    chomp;
    if($_=~/^>/)
    {
        s/^>//g;
        @tmp=split("_",$_);
        $line=<FA>;
        $pep{$tmp[0]}{$tmp[2]}=$line;
    }
}
close FA;
open LI,"<maize2tair.blastp" or die "$!";
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    @array=split/\./,$tmp[1];
    @brray=split/\_/,$tmp[0];
    if(exists $hash{$array[0]} && $tmp[2]>60)
    {
        foreach $key(keys %{$hash{$array[0]}})
        {
            $kinase{$brray[0]}=$key;
        }
    }
}
close LI;
close OUT;
open PI,"<ppi-highfinl.txt" or die "$!";
readline PI;
open OUT,">kinase_substrate.ppi" or die "$!";
print OUT "kinase\tsubstrate\ttype\tpos\tseq\n";
#open OUT1,">kinase_substrate.ppi.input" or die "$!";
#print OUT1 "kinase\tsubstrate\n";
while(<PI>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $kinase{$tmp[0]} && exists $kinase{$tmp[1]})
    {
        if(exists $pep{$tmp[1]})
        {
            foreach $m(keys %{$pep{$tmp[1]}})
            {
                $sub=substr($pep{$tmp[1]}{$m},8,15);
		#print OUT1 "$kinase{$tmp[0]}\t$sub\n";
                print OUT "$tmp[0]\t$tmp[1]\t$kinase{$tmp[0]}\t$m\t$sub\n";
            }
        }
        if(exists $pep{$tmp[0]})
        {
            foreach $m(keys %{$pep{$tmp[0]}})
            {
                $sub=substr($pep{$tmp[0]}{$m},8,15);
		#print OUT1 "$kinase{$tmp[1]}\t$sub\n";
                print OUT "$tmp[1]\t$tmp[0]\t$kinase{$tmp[1]}\t$m\t$sub\n";
            }
        }
    }
    if(exists $kinase{$tmp[0]} && !exists $kinase{$tmp[1]})
    {
        if(exists $pep{$tmp[1]})
        {
            foreach $m(keys %{$pep{$tmp[1]}})
            {
                $sub=substr($pep{$tmp[1]}{$m},8,15);
		#print OUT1 "$kinase{$tmp[0]}\t$sub\n";
                print OUT "$tmp[0]\t$tmp[1]\t$kinase{$tmp[0]}\t$m\t$sub\n";
            }
        }
    }
    if(!exists $kinase{$tmp[0]} && exists $kinase{$tmp[1]})
    {
        
        if(exists $pep{$tmp[0]})
        {
            foreach $m(keys %{$pep{$tmp[0]}})
            {
                $sub=substr($pep{$tmp[0]}{$m},8,15);
		#print OUT1 "$kinase{$tmp[1]}\t$sub\n";
                print OUT "$tmp[1]\t$tmp[0]\t$kinase{$tmp[1]}\t$m\t$sub\n";
            }
        }
    }
}
close PI;
close OUT;
#close OUT1;
