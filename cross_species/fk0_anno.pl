#!usr/bin/perl -w
open LI,"<proteom/$ARGV[0]_ptm.pos" or die "$!";
%hash=();
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    $hash{$tmp[3]}{$tmp[4]}=$tmp[5]; #gene pos aa
}
close LI;
open OUT,">$ARGV[0]_fk0.anno1" or die "$!";
open IN,"gzip -dc ./vcf/$ARGV[1]_geno_snpeff.bed.gz|" or die "$!";
#open IN,"<./vcf/$ARGV[1]_geno_snpeff1.bed" or die "$!";
while(<IN>)
{
    if($_=~/NON_SYNONYMOUS_CODING/)
    {
        chomp;
        @tmp=split("\t",$_);
	if(length($tmp[3])==1 && length($tmp[4])==1)
        {
            @array=split/\|/,$tmp[7];
            if($array[1]=~/MISSENSE/)
            {
                #print "$array[10]\n";
                $array[3]=~/^(\w{1})(\d*)(\w{1})/;
                print OUT "$tmp[0]\t$tmp[1]\t$tmp[3]\t$tmp[4]\t$1\t$3\t$array[4]\t$2\t";
                if(exists $hash{$array[4]}{$2} && ($hash{$array[4]}{$2} eq $1))
                {
                    print OUT "fk0\n";
                }
                else
                {
                    print OUT "other\n";
                }
            }
        }
    }
}
close IN;
close OUT;
