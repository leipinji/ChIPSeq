#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	peaks_region_pileup.pl
##>>	Created Time:	2014-03-03 20-51-59
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
use Getopt::Long;
my %opt=();
GetOptions(\%opt,"peaks=s","reads=s","output=s","bins=i",'extend=i',"help");

if (defined $opt{"help"}) {
	print "Usage:	peaks_region_pileup.pl <peaks locus> <read bed file> <output>\n";
	print "Options\n\t-peaks\n\t-reads\n\t-output\n\t-bins\n\t-extend\n";
	print "calculate RPM value\n";
	print "\n";
	exit(0);
	}
open my $genome_fh, "<","/home/whu5003data/genome_index/hg19/hg19.chrom.txt" or die;
open my $peaks_fh, "<",$opt{"peaks"} || die;
open my $tmp_fh,">","./tmp.file" || die;
my $count=0;
my @peaks_number=();
my %genome = ();
while (<$genome_fh>) {
	chomp;
	my @tmp = split/\t/;
	# chr length;
	$genome{$tmp[0]} = $tmp[1];
	}
close $genome_fh;
while (<$peaks_fh>) {
	chomp;
	my ($chr,$start,$end) = split/\t/;
	my $count = "$chr:$start-$end";
		push @peaks_number,$count;
		my $bin_start = $start - $opt{'extend'};
		if ($bin_start < 0) {
			$bin_start = 0;
			}
		my $bin_end = $end + $opt{'extend'};
		if ($bin_end > $genome{$chr}) {
			$bin_end = $genome{$chr};
			}
		my $gap = int(($bin_end-$bin_start)/$opt{"bins"});
		for(1..$opt{"bins"}) {
			my $binStart = $bin_start+($_-1)*$gap;
			my $binEnd   = $bin_start+$_*$gap;
			print $tmp_fh join("\t",$chr,$binStart,$binEnd,$count),"\n";
			}
		}


system("bedtools intersect -a ./tmp.file -b $opt{'reads'} -c >pileup");

my $read_number=0;
open my $read_fh, "<",$opt{"reads"} || die;
while (<$read_fh>) {
	chomp;
	$read_number+=1;
	}
$read_number = $read_number/1000000;
open my $pileup_fh, "<", "./pileup" || die;
my %index=();
while(<$pileup_fh>){
	chomp;
	my @tmp=split/\t/;
	# chr start end index read_number;
	my $read_rpm = $tmp[4]/$read_number;
	push @{$index{$tmp[3]}},$read_rpm;
	}
open my $output_fh,">",$opt{"output"} || die;
for(@peaks_number) {
	print $output_fh join("\t",$_,@{$index{$_}}),"\n";
	}

unlink "./tmp.file";
unlink "./pileup";
	


