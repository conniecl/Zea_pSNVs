#!usr/bin/perl -w
%hash=();%strc=();%dis=();
foreach $num(1..1000)
{
    open IN,"<rand_$num.mutation.add.domain" or die "$!";
    $header=<IN>;
    chomp($header);
    @name=split("\t",$header);
    while(<IN>)
    {
        chomp;
        @tmp=split("\t",$_);
        $type=join("\t",$tmp[-2],$tmp[-1]);
        $hash{$num}{$type}+=1; #num fk type number
        foreach $i(10..$#tmp-2)
        {
            $pop=join("\t",$name[$i],$tmp[-2]);
            if($tmp[$i]>0)
            {
                $sub{$pop}{$num}+=1; #taxon fk number
            }
        }
        if($tmp[-1] eq "strc")
        {
            foreach $i(10..$#tmp-2)
            {
                $pop=join("\t",$name[$i],$tmp[-2]);
                if($tmp[$i]>0)
                {
                    $strc{$pop}{$num}+=1; #taxon fk strc number
                }
            }
        }
        if($tmp[-1] eq "dis")
        {
            foreach $i(10..$#tmp-2)
            {
                $pop=join("\t",$name[$i],$tmp[-2]);
                if($tmp[$i]>0)
                {
                    $dis{$pop}{$num}+=1; #taxon fk dis number
                }
            }
        }
    }
    close IN;
}
open OUT,">rand.add.domain" or die "$!";
print OUT "pop\tpos\trand\tdomain\tcount\n";
foreach $key1(keys %sub)
{
    foreach $key2(keys %{$sub{$key1}})
    {
        print OUT "$key1\t$key2\tall\t$sub{$key1}{$key2}\n";
        print OUT "$key1\t$key2\tstrc\t$strc{$key1}{$key2}\n";
        print OUT "$key1\t$key2\tdis\t$dis{$key1}{$key2}\n";
    }
}
foreach $key1(keys %hash)
{
    %flag=();
    foreach $key2(keys %{$hash{$key1}})
    {
        @array=split("\t",$key2);
        $flag{$array[0]}+=$hash{$key1}{$key2};
        if($array[1] ne "NA")
        {
            print OUT "zea\t$array[0]\t$key1\t$array[1]\t$hash{$key1}{$key2}\n";
        }
    }
    foreach $key(keys %flag)
    {
        print OUT "zea\t$key\t$key1\tall\t$flag{$key}\n";
    }
}
close OUT;
