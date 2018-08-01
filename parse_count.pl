#!/usr/bin/env perl
#
# USGAE: perl parse_count.pl Mhet.proteinortho > Mhet.proteinortho.Count_report.txt
#
use strict;
use warnings;

my $header= <>;
chomp($header);
my ($SP,$GENCT,$CONHDR,@SPECIES) = split(/\t/,$header);

my %total_counts;
for my $sp ( @SPECIES ) {
	open(my $fh => "grep -c '>' pep/$sp |") || die $!;
	my $count = <$fh>;
	chomp($count);
	$total_counts{$sp} = $count;
}
my %freq;
my $famcount = 0;
while(<>){
	chomp;
	my ($sp,$gene,$algcon,@taxa) = split(/\t/,$_);
	my $i = 0;
	for my $t ( @taxa ) {
		my $c = ($t eq '*' ) ? 0 : scalar split(',',$t);
		$freq{$SPECIES[$i++]}->{$c}++;
	}
	$famcount++;
}
printf "%d total families\n",$famcount;
for my $sp ( keys %freq ) {
	print "$sp:\n";
	my $seen = 0;
	for my $copyNo ( sort { $a <=> $b } 
		keys %{$freq{$sp}} ) {
		printf "\t%d: %d (%.2f%%)\n", $copyNo, $freq{$sp}->{$copyNo}, 100 * $freq{$sp}->{$copyNo} / $famcount; 
		$seen += $copyNo * $freq{$sp}->{$copyNo};
	}
	printf "%d proteins participate in orthogrps. %d total in dataset. %d (%.2f%%) were not clustered\n====\n", $seen,$total_counts{$sp}, $total_counts{$sp}-$seen,100*($total_counts{$sp}-$seen)/$total_counts{$sp};
}	
