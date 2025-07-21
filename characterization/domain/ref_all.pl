#!usr/bin/perl -w
open IN,"<ptm_protein.weight" or die "$!";
%hash=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    $hash{$tmp[0]}{$tmp[1]}=1;
}
close IN;
open LE,"<Zea_mays.AGPv4.pep.max.fa" or die "$!";
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
        @array=split("",$_);
        foreach $i(0..$#array)
        {
            $j=$i+1;
            if($array[$i]=~/S|T|Y/)
            {
                if(!exists $fh{$array[$i]})
                {
                    open $fh{$array[$i]},">b73_noptm.$array[$i]" or die "$!";
                }
                if(!exists $hash{$id}{$j})
                {
                    $fh{$array[$i]}->print("$id\t$j\n");
                }
            }
            
        }
    }
}
close LE;
