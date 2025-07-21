#!usr/bin/perl -w
open CD,"gzip -dc osa1_r7.all_models.cds.fa.gz|" or die "$!";
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
open IN,"gzip -dc osa1_r7.all_models.pep.fa.gz|" or die "$!";
%gene=();%hash=();
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        @tmp=split/\s+/,$_;
        @array=split/\./,$tmp[0];
        $gene{$array[0]}{$tmp[0]}=1;
        $id=$tmp[0];
    }
    else
    {
        $hash{$id}.=$_;
    }
}
close IN;
open OUT,">osa.max.pep" or die "$!";
open OUT2,">osa.max.cds" or die "$!";
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
    #$len1=length($hash{$flag});
    #$len2=length($seq{$flag});
    #print "$flag\t$len1\t$len2\n";
    $flag=~s/^>//g;
    $pep{$flag}=1;
}
close OUT;
close OUT2;
open LI,"gzip -dc osa1_r7.all_models.gff3.gz|" or die "$!";
open OUT1,">osa.max.gtf" or die "$!";
while(<LI>)
{
    if($_!~/^#/ && $_!~/^\s/ && $_!~/^ChrUn/ && $_!~/^ChrSy/)
    {
    chomp;
    @tmp=split("\t",$_);
    if($tmp[2] eq "mRNA")
    {
        $tmp[-1]=~/Name=(.*?);Parent=(.*?)$/;
        if(exists $pep{$1})
        {
            print OUT1 "$tmp[0]\t$tmp[1]\ttranscript\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$2\"; transcript_id \"$1\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }
    }
    if($tmp[2] eq "exon")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?)$/; #print "done.$1.done\n"; exit 0;
        if(exists $pep{$2})
        {
            @brray=split/\.|\:|\_/,$1;
            print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$2\"; exon_number \"$brray[3]\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\"; exon_id \"$2.exon$brray[3]\";\n";
        }
    }
    if($tmp[2] eq "CDS")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?)$/;
        if(exists $pep{$2})
        {
            @brray=split/\.|\:|\_/,$1;
            print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$2\"; exon_number \"$brray[3]\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\"; protein_id \"$2\"; protein_version \"1\";\n";
        }
    }
    if($tmp[2] eq "five_prime_UTR")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?)$/;
        if(exists $pep{$2})
        {
            @brray=split/\.|\:|\_/,$1;
            print OUT1 "$tmp[0]\t$tmp[1]\tfive_prime_utr\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$2\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }    
    }
    if($tmp[2] eq "three_prime_UTR")
    {
        $tmp[-1]=~/^ID=(.*?);Parent=(.*?)$/;
        if(exists $pep{$2})
        {
            @brray=split/\./,$1;
            print OUT1 "$tmp[0]\t$tmp[1]\tthree_prime_utr\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t";
            print OUT1 "gene_id \"$brray[0]\"; transcript_id \"$2\"; gene_source \"gramene\"; gene_biotype \"protein_coding\"; transcript_source \"gramene\"; transcript_biotype \"protein_coding\";\n";
        }
    }
    }
}
close OUT1;
close LI;
