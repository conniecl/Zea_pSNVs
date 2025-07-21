#!usr/bin/perl -w
@file=glob("*.txt");
open OUT,">phosphat.kinase" or die "$!";
print OUT "effector\ttype\tfamily\tinteraction\tpathway\ttarget\tpSite\tpubmed\n";
foreach $in(@file)
{
    open IN,"<$in" or die "$!";
    readline IN;
    while(<IN>)
    {
	if($_=~/^AT/ && !exists $hash{$_})
	{
	       	print OUT "$_";
        }
	$hash{$_}=1;
    }
    close IN;
}
close OUT;
