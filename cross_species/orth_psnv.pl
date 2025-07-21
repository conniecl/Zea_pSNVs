#!usr/bin/perl -w
open PA,"<ma" or die "$!";
%psnv=();
while(<PA>)
{
    chomp;
    $psnv{$_}=1;
}
close PA;
@sub=qw/ath osa tae/;
foreach $in(@sub)
{
    open PA,"<$in" or die "$!";
    while(<PA>)
    {
        chomp;
        $psnv{$_}=1;
    }
    close PA;
}
open IN,"<Zea_mays.AGPv4.pep.max.fa" or die "$!";
while(<IN>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        $id=$_;
    }
    else
    {
        s/\*$//g;
        $hash{$id}.=$_;
    }
}
close IN;
open LI,"<tae.max.pep" or die "$!";
while(<LI>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        $id=$_;
    }
    else
    {
        s/\*$//g;
        $hash{$id}.=$_;
    }
}
close LI;
open LI,"<osa.max.pep" or die "$!";
while(<LI>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        $id=$_;
    }
    else
    {
        s/\*$//g;
        $hash{$id}.=$_;
    }
}
close LI;
open LI,"<proteome.all_transcripts.ath.fasta" or die "$!";
while(<LI>)
{
    chomp;
    if($_=~/^>/)
    {
        s/>//g;
        $id=(split/\s+/,$_)[0];
    }
    else
    {
        $hash{$id}.=$_;
    }
}
close LI;
open IN,"<maize2rice.blastp" or die "$!";
%rice=();%all=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $psnv{$tmp[0]} && exists $psnv{$tmp[1]})
    {
        $cov1=($tmp[7]-$tmp[6]+1)/length($hash{$tmp[0]});
        $cov2=($tmp[9]-$tmp[8]+1)/length($hash{$tmp[1]});
        if(!exists $rice{$tmp[0]})
        {
            $rice{$tmp[0]}{$tmp[1]}=join("\t",$tmp[2],$cov1,$cov2);
            $all{$tmp[0]}=1;
        }
    }
}
close IN;
open IN,"<maize2tair.blastp" or die "$!";
%tair=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $psnv{$tmp[0]} && exists $psnv{$tmp[1]})
    {
        $cov1=($tmp[7]-$tmp[6]+1)/length($hash{$tmp[0]});
        $cov2=($tmp[9]-$tmp[8]+1)/length($hash{$tmp[1]});
        if(!exists $tair{$tmp[0]})
        {
            $tair{$tmp[0]}{$tmp[1]}=join("\t",$tmp[2],$cov1,$cov2);
            $all{$tmp[0]}=1;
        }
    }
}
close IN;
open IN,"<maize2wheat.blastp" or die "$!";
%wheat=();
while(<IN>)
{
    chomp;
    @tmp=split("\t",$_);
    if(exists $psnv{$tmp[0]} && exists $psnv{$tmp[1]})
    {
        $cov1=($tmp[7]-$tmp[6]+1)/length($hash{$tmp[0]});
        $cov2=($tmp[9]-$tmp[8]+1)/length($hash{$tmp[1]});
        if(!exists $wheat{$tmp[0]})
        {
            $wheat{$tmp[0]}{$tmp[1]}=join("\t",$tmp[2],$cov1,$cov2);
            $all{$tmp[0]}=1;
        }
    }
}
close IN;
open OUT,">all_orth_psnv" or die "$!";
$flag=1;
foreach $key1(keys %all)
{
    if(exists $tair{$key1})
    {
        if(exists $rice{$key1})
        {
            if(exists $wheat{$key1})
            {
                foreach $m(keys %{$tair{$key1}})
                {
                    foreach $n(keys %{$rice{$key1}})
                    {
                        foreach $o(keys %{$wheat{$key1}})
                        {
                            print OUT "$key1\t$m\t$tair{$key1}{$m}\t$n\t$rice{$key1}{$n}\t$o\t$wheat{$key1}{$o}\n";
                            open OUT1,">aln/$flag.fa" or die "$!";
                            print OUT1 ">$key1\n$hash{$key1}\n>$m\n$hash{$m}\n>$n\n$hash{$n}\n>$o\n$hash{$o}\n";
                            $flag++;
                        }
                    }
                }
            }
            else
            {
                foreach $m(keys %{$tair{$key1}})
                {
                    foreach $n(keys %{$rice{$key1}})
                    {
                        print OUT "$key1\t$m\t$tair{$key1}{$m}\t$n\t$rice{$key1}{$n}\tNA\tNA\tNA\tNA\n";
                        open OUT1,">aln/$flag.fa" or die "$!";
                        print OUT1 ">$key1\n$hash{$key1}\n>$m\n$hash{$m}\n>$n\n$hash{$n}\n";
                        $flag++;
                    }
                }
            }
        }
        else
        {
            if(exists $wheat{$key1})
            {
                foreach $m(keys %{$tair{$key1}})
                {
                    foreach $o(keys %{$wheat{$key1}})
                    {
                        print OUT "$key1\t$m\t$tair{$key1}{$m}\tNA\tNA\tNA\tNA\t$o\t$wheat{$key1}{$o}\n";
                        open OUT1,">aln/$flag.fa" or die "$!";
                        print OUT1 ">$key1\n$hash{$key1}\n>$m\n$hash{$m}\n>$o\n$hash{$o}\n";
                        $flag++;
                    }
                }
            }
            else
            {
                foreach $m(keys %{$tair{$key1}})
                {
                    print OUT "$key1\t$m\t$tair{$key1}{$m}\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n";
                    open OUT1,">aln/$flag.fa" or die "$!";
                    print OUT1 ">$key1\n$hash{$key1}\n>$m\n$hash{$m}\n";
                    $flag++;
                }
            }
        }
    }
    else
    {
        if(exists $rice{$key1})
        {
            if(exists $wheat{$key1})
            {
                foreach $n(keys %{$rice{$key1}})
                {
                    foreach $o(keys %{$wheat{$key1}})
                    {
                        print OUT "$key1\tNA\tNA\tNA\tNA\t$n\t$rice{$key1}{$n}\t$o\t$wheat{$key1}{$o}\n";
                        open OUT1,">aln/$flag.fa" or die "$!";
                        print OUT1 ">$key1\n$hash{$key1}\n>$n\n$hash{$n}\n>$o\n$hash{$o}\n";
                        $flag++;
                    }
                }
            }
            else
            {
                foreach $n(keys %{$rice{$key1}})
                {
                    print OUT "$key1\tNA\tNA\tNA\tNA\t$n\t$rice{$key1}{$n}\tNA\tNA\tNA\tNA\n";
                    open OUT1,">aln/$flag.fa" or die "$!";
                    print OUT1 ">$key1\n$hash{$key1}\n>$n\n$hash{$n}\n";
                    $flag++;
                }
            }
        }
        else
        {
            if(exists $wheat{$key1})
            {
                foreach $o(keys %{$wheat{$key1}})
                {
                    print OUT "$key1\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$o\t$wheat{$key1}{$o}\n";
                    open OUT1,">aln/$flag.fa" or die "$!";
                    print OUT1 ">$key1\n$hash{$key1}\n>$o\n$hash{$o}\n";
                    $flag++;
                }
            }
        }
    }
}
close OUT;
