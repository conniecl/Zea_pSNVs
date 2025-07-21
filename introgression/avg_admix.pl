#!usr/bin/perl -w
#foreach $chr(1..10)
#{
    open IN,"<../maize_$ARGV[0].recode.geno.txt" or die "$!";
    open OUT,">mex_maize_chr$ARGV[0].mix" or die "$!";
    open OUT1,">par_maize_chr$ARGV[0].mix" or die "$!";
    open OUT2,">maize_chr$ARGV[0].intro.snp" or die "$!";
    @array=();%hash=();
    readline IN;readline IN;
    $header=<IN>;
    print OUT "$header";    print OUT1 "$header";
    chomp($header);@array=split(",",$header);  #sample name
    close IN;
    
    open SN,"<chr$ARGV[0].snpinfo.txt" or die "$!";
    readline SN;
    while(<SN>)
    {
        if($_=~/^chr/)
        {
            $name=(split("\t",$_))[0];
            $linenum=$.-1;
            $hash{$linenum}=$name;  #snp name
	    #print "$.\t$linenum\t$name\n"; exit 0;
    	}
    }
    close SN;
    
    %par=();%mex=();
    @file=glob("chr$ARGV[0].*s21.txt");
    foreach $run(@file)
    {
        open LI,"<$run" or die "$!";
        while(<LI>)
        {
            chomp;
	    $line=$.;
            @tmp=split/\s+/,$_; #print "@tmp"; exit 0;
            for($i=0;$i<$#tmp;$i+=2)
            {
                $j=$i+1;
                $s=($i/2)+1; #print "$s\t$array[$s]\n"; 
                $mex{$s}{$array[$line]}+=$tmp[$i];
                $par{$s}{$array[$line]}+=$tmp[$j]; #snp name, sample name, elai
            }
        }
        close LI;
    }
    foreach $key1(sort{$a <=> $b} keys %mex)
    {
        print OUT "$hash{$key1},";
        print OUT1 "$hash{$key1},";
        $count=0;
        foreach $key2(1..$#array-1)
        {
            print OUT "$mex{$key1}{$array[$key2]},";
            print OUT1 "$par{$key1}{$array[$key2]},";
            if($mex{$key1}{$array[$key2]}>18)
            {
                $count++;
            }
        }
        print OUT "$mex{$key1}{$array[-1]}\n";
        print OUT1 "$par{$key1}{$array[-1]}\n";
        if($mex{$key1}{$array[-1]}>18)
        {
            $count++;
        }
        $rate=$count/507;
        print OUT2 "$hash{$key1}\t$rate\t";
        if($rate>0.8)
        {
            print OUT2 "1\n";
        }
        else
        {
            print OUT2 "0\n";
        }
    }
    close OUT;
    close OUT1;
    close OUT2;
#}
