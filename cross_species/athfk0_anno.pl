#!usr/bin/perl -w
%table=(
    "Gly"=>"G",
    "Ala"=>"A",
    "Val"=>"V",
    "Leu"=>"L",
    "Ile"=>"I",
    "Glu"=>"E",
    "Gln"=>"Q",
    "Asp"=>"D",
    "Asn"=>"N",
    "Met"=>"M",
    "Ser"=>"S",
    "Thr"=>"T",
    "Phe"=>"F",
    "Trp"=>"W",
    "Tyr"=>"Y",
    "Arg"=>"R",
    "His"=>"H",
    "Cys"=>"C",
    "Pro"=>"P",
    "Lys"=>"K"
);
open LI,"<ph_allSPECIES.txt" or die "$!";
readline LI;
%hash=();
while(<LI>)
{
    chomp;
    @tmp=split("\t",$_);
    if($tmp[1] eq "ath")
    {
        $aa=substr($tmp[9],$tmp[10]-1,1);
        if($aa eq $tmp[5])
        {
            $hash{$tmp[0]}{$tmp[4]}=$tmp[5]; #gene pos aa
        }
    }
}
close LI;
open OUT,">ath_fk0.anno" or die "$!";
open IN,"gzip -dc vcf/1001genomes_snp-short-indel_only_ACGTN_v3.1.vcf.snpeff.gz|" or die "$!";
while(<IN>)
{
    if($_=~/missense_variant/)
    {
        chomp;
        @tmp=split("\t",$_);
	if(length($tmp[3])==1 && length($tmp[4])==1)
        {
            @array=split/\|/,$tmp[7];
            if($array[0]=~/missense_variant/)
            {
                #print "$array[10]\n";
                $array[3]=~/^p\.(\w{3})(\d*)(\w{3})/;
                print OUT "$tmp[0]\t$tmp[1]\t$tmp[3]\t$tmp[4]\t$table{$1}\t$table{$3}\t$array[8]\t$2\t";
                if(exists $hash{$array[8]}{$2} && ($hash{$array[8]}{$2} eq $table{$1}))
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
