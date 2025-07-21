#!usr/bin/perl -w
open NO,"<merge_all.mutation.add.type" or die "$!";
readline NO;
while(<NO>)
{
    chomp;
    @tmp=split("\t",$_,3);
    $non{$tmp[0]}{$tmp[1]}=1
}
close NO;

open LI,"<maize.maf_0.05.vcf" or die "$!";
open OUT,">maize.gwas.hmp" or die "$!";
print OUT "rs#\talleles\tchrom\tpos\tstrand\tassembly#\tcenter\tprotLSID\tassayLSID\tpanelLSID\tQCdode\t";
while(<LI>)
{
    chomp;
    if($_=~/^#CHROM/)
    {
        @array=split("\t",$_);
        foreach $i(9..$#array-1)
        {
            print OUT "$array[$i]\t";
        }
        print OUT "$array[-1]\n";
        foreach $chr(1..10)
        {
            open $fh{$chr},">chr${chr}_nonsys_imp.hmp" or die "$!";
            $fh{$chr}->print("rs#\talleles\tchrom\tpos\tstrand\tassembly#\tcenter\tprotLSID\tassayLSID\tpanelLSID\tQCdode\t");
            foreach $i(9..$#array-1)
            {
                $fh{$chr}->print("$array[$i]\t");
            }
            $fh{$chr}->print("$array[-1]\n");
        }
    }
    if($_=~/^\d/)
    {
        %base=();$count=0;
        @tmp=split("\t",$_);
        foreach $m(9..$#tmp)
        {
            if($tmp[$m]=~/^\./)
            {
                $count++;
            }
            else
            {
                @brray=split/\||\:|\//,$tmp[$m];#print "$j\t$list[$j]\t$tmp[$list[$j]]\n";
                if($brray[0] ne $brray[1])
                {
                    $count++;
                }
            }
        }
        $rate=$count/($#tmp-8);
        if($rate<0.75)
        {
            $base{0}=$tmp[3];
            $base{1}=$tmp[4];
            print OUT "$tmp[2]\t$tmp[3]/$tmp[4]\t$tmp[0]\t$tmp[1]\t+\tAPGV4\tNA\tNA\tNA\tNA\tNA\t";
            if(exists $non{$tmp[0]}{$tmp[1]})
            {
                $fh{$tmp[0]}->print("$tmp[2]\t$tmp[3]/$tmp[4]\t$tmp[0]\t$tmp[1]\t+\tAPGV4\tNA\tNA\tNA\tNA\tNA\t");
            }
            foreach $j(9..$#tmp-1)
            {
                if($tmp[$j]=~/^\./)
                {
                    if(exists $non{$tmp[0]}{$tmp[1]})
                    {
                        $fh{$tmp[0]}->print("NN\t");
                    }
                    print OUT "NN\t";
                }
                else
                {
                    @brray=split/\||\:|\//,$tmp[$j];#print "$j\t$list[$j]\t$tmp[$list[$j]]\n";
                    if($brray[0] ne $brray[1])
                    {
                        if(exists $non{$tmp[0]}{$tmp[1]})
                        {
                            $fh{$tmp[0]}->print("NN\t");
                        }
                        print OUT "NN\t";
                    }
                    else
                    {
                        if(exists $non{$tmp[0]}{$tmp[1]})
                        {
                            $fh{$tmp[0]}->print("$base{$brray[0]}");
                            $fh{$tmp[0]}->print("$base{$brray[1]}\t");
                        }
                        print OUT "$base{$brray[0]}$base{$brray[1]}\t";
                    }
                }
            }
            if($tmp[-1]=~/^\./)
            {
                if(exists $non{$tmp[0]}{$tmp[1]})
                {
                    $fh{$tmp[0]}->print("NN\n");
                }
                print OUT "NN\n";
            }
            else
            {
                @brray=split/\||\:|\//,$tmp[-1];#print "$list[-1]\t$tmp[$list[-1]]\n";
                if($brray[0] ne $brray[1])
                {
                    if(exists $non{$tmp[0]}{$tmp[1]})
                    {
                        $fh{$tmp[0]}->print("NN\n");
                    }
                    print OUT "NN\n";
                }
                else
                {
                    if(exists $non{$tmp[0]}{$tmp[1]})
                    {
                        $fh{$tmp[0]}->print("$base{$brray[0]}");
                        $fh{$tmp[0]}->print("$base{$brray[1]}\n");
                    }
                    print OUT "$base{$brray[0]}$base{$brray[1]}\n";
                }
            }
        }
    }
}
close LI;
