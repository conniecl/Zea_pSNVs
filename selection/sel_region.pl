#!usr/bin/perl -w
%wstat=();
foreach $chr(1..10)
{
    open IN,"<teo_maize.$chr.spline.nocent" or die "$!";
    readline IN;
    while(<IN>)
    {
        chomp;
        @tmp=split("\t",$_);
        $len=$tmp[2]-$tmp[1];
        $pos=join("_",$chr,$tmp[1],$tmp[2]);
        $wstat{$tmp[-1]}{$pos}=$len;
    }
    close IN;
}
$sumlen=0;
$thread=210633812;
open OUT,">teo_maize.sel.class" or die "$!";
print OUT "chr\tstart\tend\twstat\ttype\n";
foreach $key1(sort{$b<=>$a} keys %wstat)
{
    foreach $key2(keys %{$wstat{$key1}})
    {
        $sumlen+=$wstat{$key1}{$key2};
        @array=split/_/,$key2;
        print OUT "$array[0]\t$array[1]\t$array[2]\t$key1\t";
        if($sumlen<$thread)
        {
            print OUT "sel\n";
        }
        else
        {
            print OUT "back\n"; 
        }
    }
}
close OUT;
