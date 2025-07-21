#!usr/bin/perl -w
open IN,"gzip -dc proteome.all_transcripts.$ARGV[0].fasta.gz|" or die "$!";
%gene=();%hash=();
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        @array=split/\s+/,$_;
        $gene{$array[-1]}{$array[0]}=1;
        $id=$array[0];
    }
    else
    {
        $hash{$id}.=$_;
    }
}
close IN;
open OUT,">$ARGV[0].max.pep" or die "$!";
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
    $flag=~s/^>//g;
    $pep{$flag}=1;
}
close OUT;
open LI,"gzip -dc annotation.all_transcripts.all_features.$ARGV[0].gff3.gz|" or die "$!";
open OUT1,">$ARGV[0].max.gtf" or die "$!";
%cds=();
while(<LI>)
{
    if($_!~/^#/)
    {
    chomp;
    @tmp=split("\t",$_);
    if($tmp[2] eq "mRNA")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?);/;
        if(exists $pep{$1})
        {
        print OUT1 "$tmp[0]\t$tmp[1]\ttranscript\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
        print OUT1 "gene_id \"$2\"; transcript_id \"$1\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }
    }
    if($tmp[2] eq "exon")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?);Name=(.*?);/;
        if(exists $pep{$2})
        {
        @brray=split(":",$1);
        #$exon=$brray[2];
        print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
        print OUT1 "gene_id \"$3\"; transcript_id \"$2\"; exon_number \"$brray[2]\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\"; exon_id \"$brray[0].exon$brray[2]\";\n";
        }
    }
    if($tmp[2] eq "CDS")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?);Name=(.*?);/;
        #@brray=split(":",$1); #for gma
        if(exists $pep{$2})
        {
            $cds{$2}+=1;
        print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
        print OUT1 "gene_id \"$3\"; transcript_id \"$2\"; exon_number \"$cds{$2}\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\"; protein_id \"$2\"; protein_version \"1\";\n";
        }
    }
    if($tmp[2] eq "five_prime_UTR")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?);Name=(.*?);/;
        if(exists $pep{$2})
        {
        @brray=split(":",$1);
        print OUT1 "$tmp[0]\t$tmp[1]\tfive_prime_utr\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
        print OUT1 "gene_id \"$3\"; transcript_id \"$2\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }
    }
    if($tmp[2] eq "three_prime_UTR")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?);Name=(.*?);/;
        if(exists $pep{$2})
        {
        @brray=split(":",$1);
        print OUT1 "$tmp[0]\t$tmp[1]\tthree_prime_utr\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
        print OUT1 "gene_id \"$3\"; transcript_id \"$2\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }
    }
    }
}
close OUT1;
close LI;
