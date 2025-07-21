#!usr/bin/perl -w
%anc=();
foreach $chr(1..10)
{
    open AN,"<maize_$chr.anc" or die "$!";
    readline AN;
    while(<AN>)
    {
        chomp;
        @tmp=split("\t",$_);
        $tmp[1]=~s/chr//g;
        @array=split("_",$tmp[1]);
        $anc{$array[0]}{$array[1]}=$tmp[7];
    }
}
@sample=qw/14 14 14 20 19 5 81 70 210 280 17/;
open OUT,">merge_all.mutation.add.rate" or die "$!";
#open OUT,">merge_all.mutation.rev.rate" or die "$!";
print OUT "chr\tpos\tref\talt\trefaa\taltaa\tgene\tloc\tsift\tgerp\tdistance\tteo_mix\tnicaraguensis\tluxurians\tdiploperennis\tperennis\thuehuetenangensis\tmexicana\tparviglumis\tTST\tTEM\tmaize_mix\tstat\n";
open LI,"<merge_all.mutation.add.type" or die "$!";
#open LI,"<merge_all.mutation.rev.type" or die "$!";
$header=<LI>;
chomp($header);
@name=split("\t",$header);
open OUT1,">snv_ancrate.diff" or die "$!";
#open OUT1,">snv_ancrate.rev.diff" or die "$!";
print OUT1 "pos\trate\ttype\tclass\tstate\n";
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    #if($tmp[-2]=~/fk/ && exists $anc{$tmp[0]}{$tmp[1]})
    if(exists $anc{$tmp[0]}{$tmp[1]})
    {
        foreach $i(0..9)
        {
            print OUT "$tmp[$i]\t";
        }
	if($tmp[-2]=~/fk/){$tmp[-2]="psnv";}
	print OUT "$tmp[-2]\t";
        if($anc{$tmp[0]}{$tmp[1]} eq "Ancestral")
        {
            foreach $i(10..20)
            {
                $rate=$tmp[$i]/($sample[$i-10]*2);
                print OUT "$rate\t";
                print OUT1 "$tmp[0]_$tmp[1]\t$rate\t$name[$i]\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
            }
            $teo=($tmp[11]+$tmp[12]+$tmp[13]+$tmp[15]+$tmp[16]+$tmp[17])/(204*2);
            $maize=($tmp[18]+$tmp[19])/(490*2);
            $zea=($tmp[11]+$tmp[12]+$tmp[13]+$tmp[15]+$tmp[16]+$tmp[17]+$tmp[18]+$tmp[19])/(694*2);
            print OUT1 "$tmp[0]_$tmp[1]\t$teo\tteo\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
            print OUT1 "$tmp[0]_$tmp[1]\t$maize\tmaize\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
            print OUT1 "$tmp[0]_$tmp[1]\t$zea\tzea\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
        }
        else
        {
            foreach $i(10..20)
            {
                $rate=1-($tmp[$i]/($sample[$i-10]*2));
                print OUT "$rate\t";
                print OUT1 "$tmp[0]_$tmp[1]\t$rate\t$name[$i]\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
            }
            $teo=1-(($tmp[11]+$tmp[12]+$tmp[13]+$tmp[15]+$tmp[16]+$tmp[17])/(204*2));
            $maize=1-(($tmp[18]+$tmp[19])/(490*2));
            $zea=1-(($tmp[11]+$tmp[12]+$tmp[13]+$tmp[15]+$tmp[16]+$tmp[17]+$tmp[18]+$tmp[19])/(694*2));
            print OUT1 "$tmp[0]_$tmp[1]\t$teo\tteo\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
            print OUT1 "$tmp[0]_$tmp[1]\t$maize\tmaize\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
            print OUT1 "$tmp[0]_$tmp[1]\t$zea\tzea\t$tmp[-2]\t$anc{$tmp[0]}{$tmp[1]}\n";
        }
        print OUT "$anc{$tmp[0]}{$tmp[1]}\n";
    }
}
close LI;
close OUT;
close OUT1;
