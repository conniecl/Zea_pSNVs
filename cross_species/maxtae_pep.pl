#!usr/bin/perl -w
open CD,"<iwgsc_refseqv1.0_HighConf_CDS_2017Mar13.fa" or die "$!";
%seq=();
while(<CD>)
{
    chomp;
    if($_=~/^>/)
    {
        $name=(split/\s+/,$_)[0];
    }
    else
    {
        $seq{$name}.=$_;
    }
}
close CD;
open IN,"<iwgsc_refseqv1.0_HighConf_PROTEIN_2017Mar13.fa" or die "$!";
%gene=();%hash=();
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        @array=split/\./,$_;
        $gene{$array[0]}{$_}=1;
        $id=$_;
    }
    else
    {
        $hash{$id}.=$_;
    }
}
close IN;
open OUT,">tae.max.pep" or die "$!";
open OUT2,">tae.max.cds" or die "$!";
%pep=();
foreach $key1(keys %gene)
{
    $max=0;$flag="";
    foreach $key2(keys %{$gene{$key1}})
    {
        $len=length($hash{$key2});
        if($len>$max)
        {
            $flag=$key2;
            $max=$len;
        }
    }
    print OUT "$flag\n$hash{$flag}\n";
    print OUT2 "$flag\n$seq{$flag}\n";
    $flag=~s/^>//g;
    $pep{$flag}=1;
}
close OUT;
close OUT2;
open LI,"<iwgsc_refseqv1.0_HighConf_2017Mar13.gff3" or die "$!";
open OUT1,">tae.max.gtf" or die "$!";
%exon=();%cds=();
while(<LI>)
{
    if($_!~/^#/)
    {
    chomp;
    @tmp=split("\t",$_);
    if($tmp[2] eq "mRNA")
    {
        $tmp[-1]=~/ID=(.*?);Parent=(.*?);/;
        if(exists $pep{$1})
        {
            print OUT1 "$tmp[0]\t$tmp[1]\ttranscript\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$2\"; transcript_id \"$1\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }
    }
    if($tmp[2] eq "exon")
    {
        $tmp[-1]=~/^Parent=(.*?)$/; #print "done.$1.done\n"; exit 0;
        if(exists $pep{$1})
        {
            @brray=split/\./,$1;
            $exon{$1}+=1;
            print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$1\"; exon_number \"$exon{$1}\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\"; exon_id \"$1.exon$exon{$1}\";\n";
        }
    }
    if($tmp[2] eq "CDS")
    {
        $tmp[-1]=~/^Parent=(.*?)$/;
        if(exists $pep{$1})
        {
            @brray=split/\./,$1;
            $cds{$1}+=1;
            print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$1\"; exon_number \"$cds{$1}\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\"; protein_id \"$1\"; protein_version \"1\";\n";
        }
    }
    if($tmp[2] eq "five_prime_UTR")
    {
        $tmp[-1]=~/^Parent=(.*?)$/;
        if(exists $pep{$1})
        {
            @brray=split/\./,$1;
            print OUT1 "$tmp[0]\t$tmp[1]\tfive_prime_utr\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$1\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }    
    }
    if($tmp[2] eq "three_prime_UTR")
    {
        $tmp[-1]=~/^Parent=(.*?)$/;
        if(exists $pep{$1})
        {
            @brray=split/\./,$1;
            print OUT1 "$tmp[0]\t$tmp[1]\tthree_prime_utr\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$1\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }
    }
    }
}
close OUT1;
close LI;

