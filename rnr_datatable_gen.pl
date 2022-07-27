#!/usr/bin/perl

use strict;
use warnings;


my $pasv_orf = $ARGV[0];
my $btab = $ARGV[1];

my %hash = ();
print "orf_id\ttarget_top_hit\taa_identity\tcoverage\tevalue\tbitscore\t";

open (ORF, $pasv_orf) or die "Error! Cannot open file $pasv_orf\n";

my $firstLine = <ORF>;
chomp $firstLine;

my @file = split("\t", $firstLine);
shift @file;

my $pasv_header = join("\t", @file);
print "$pasv_header\tcontains_NCEC\n";

while (my $line = <ORF>){
	chomp $line;	
	
	my @arr = split("\t", $line);
	my $id = $arr[0];
	my $sig = $arr[6];
	substr($sig, 1, 1, '');	
	shift @arr;

	my $pasv_data = join("\t", @arr);

	if($sig eq "NCEC"){
		$hash{$id} = "$pasv_data\t1";
	}
	else{
		$hash{$id} = "$pasv_data\t0";
	}
}
close ORF;


open (GEN, $btab) or die "Error! Cannot open file $btab\n";

while (my $line = <GEN>){
	chomp $line;
	my @arr = split("\t", $line);

	my $id     = $arr[0];
	my $target = $arr[1];
	my $ident  = $arr[2];
	my $cov    = $arr[3];
	my $eval   = $arr[10];
	my $bit    = $arr[11];
	
	if(exists $hash{$id}){
		print "$id\t$target\t$ident\t$cov\t$eval\t$bit\t" . $hash{$id} . "\n";
	}
}

close GEN;


