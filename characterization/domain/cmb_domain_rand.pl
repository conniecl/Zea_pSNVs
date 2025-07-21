#!usr/bin/perl -w
use Statistics::Descriptive;
%hash=();
open IN,"<rand/rand.add.domain" or die "$!";
readline IN;
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    $type=join("\t",$tmp[0],$tmp[1],$tmp[3]);
    push @{$hash{$type}},$tmp[4];
}
close IN;
open OUT,">mutation.add.domain.rand" or die "$!";
print OUT "pop\tpos\tdomain\tavg\tsd\ttype\n";
foreach $key(keys %hash)
{
    $stat=Statistics::Descriptive::Full->new();
    $stat->add_data(@{$hash{$key}});
    $mean=$stat->mean();
    $sd=$stat->standard_deviation();
    print OUT "$key\t$mean\t$sd\trand\n";
}
open LI,"< merge_all.mutation.add.type" or die "$!";
$header=<LI>;
chomp($header);
@name=split("\t",$header);
%real=();
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[-2]=~/fk/)
    {
        $type=join("\t",$tmp[-2],$tmp[-1]);
        $real{"zea"}{$type}+=1;
        $real{"zea"}{$tmp[-2]}+=1;
        foreach $i(10..$#tmp-2)
        {
            if($tmp[$i]>0)
            {
                $real{$name[$i]}{$type}+=1;
                $real{$name[$i]}{$tmp[-2]}+=1;
            }
        }
    }
}
close LI;
foreach $key1(keys %real)
{
    foreach $key2(keys %{$real{$key1}})
    {
        if($key2!~/NA/)
        {
            if($key2=~/dis|strc/)
            {
                print OUT "$key1\t$key2\t$real{$key1}{$key2}\t0\treal\n";
            }
            else
            {
                print OUT "$key1\t$key2\tall\t$real{$key1}{$key2}\t0\treal\n";
            }
        }
    }
}
close OUT;
