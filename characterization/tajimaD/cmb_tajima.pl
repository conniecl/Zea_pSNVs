#!usr/bin/perl -w
open IN,"</mnt/sda/lchen/dele_mu/04.sift/maize/dbSNP/merge_all.mutation.add.rate" or die "$!";
readline IN;
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[10] eq "psnv")
    {
        $psnv{$tmp[0]}{$tmp[1]}=1;
    }
}
close IN;
@file=qw/nicaraguensis luxurians diploperennis perennis huehuetenangensis mexicana parviglumis TST TEM zea/;
open OUT,">all_cmb.Tajima" or die "$!";
print OUT "TajimaD\tpop\ttype\n";
foreach $i(@file)
{
    foreach $j(1..10)
    {
        open LI,"<${i}_$j.nonsys.Tajima.D.f" or die "$!";
        readline LI;
        while(<LI>)
        {
            chomp;
            @tmp=split("\t",$_);
            if(exists $psnv{$tmp[0]}{$tmp[1]})
            {
                print OUT "$tmp[-1]\t$i\tpsnv\n";
            }
            else
            {
                print OUT "$tmp[-1]\t$i\tother\n";
            }
        }
        close LI;
    }
}
close OUT;
