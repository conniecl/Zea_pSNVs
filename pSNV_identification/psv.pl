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
open IN,"<ptm_protein.weight" or die "$!";
%hash=();
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
open FI,"<b73_v4.mp.tsv" or die "$!";
%domain=();
while(<FI>)
{
    chomp;
    @tmp=split("\t",$_);
    foreach $i($tmp[6]..$tmp[7])
    {
        if($tmp[3] eq "Pfam")
        {
            $domain{$tmp[0]}{$i}="strc";
        }
        else
        {
            if(!exists $domain{$tmp[0]}{$i})
            {
                $domain{$tmp[0]}{$i}="dis";
            }
        }
    }
}
close FI;
open OUT,">merge_all.mutation.$ARGV[0].type" or die "$!";
foreach $chr(1..10)
{
    open LI,"<merge_$chr.mutation.$ARGV[0].site" or die "$!";
    if($chr==1)
    {
        $header=<LI>;
        chomp($header);
        print OUT "$header\ttype\tdomain\n";
    }
    else
    {
        readline LI;
    }
    while(<LI>)
    {
        chomp;
        @tmp=split("\t",$_);
        $len=length($tmp[3]);
        if($len==1)
        {
            if(exists $hash{$tmp[6]}{$tmp[7]} && ($tmp[4]!~/S|T|Y/ || $tmp[5]!~/S|T|Y/))
            {
                print OUT "$_"; print OUT "fk$hash{$tmp[6]}{$tmp[7]}\t";
                delete($hash{$tmp[6]}{$tmp[7]});
            }
            else
            {
                print OUT "$_"; print OUT "other\t";
            }
            if(exists $domain{$tmp[6]}{$tmp[7]})
            {
                print OUT "$domain{$tmp[6]}{$tmp[7]}\n";
            }
            else
            {
                print OUT "NA\n";
            }
        }
    }
    close LI;
}
close OUT;
open OUT1,">ptm_nomutation.site" or die "$!";
foreach $key1(keys %hash)
{
    foreach $key2(keys %{$hash{$key1}})
    {
	print OUT1 "$key1\t$key2\tfk$hash{$key1}{$key2}\n";
    }
}
close OUT1;
