#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	tss_region_rpm.pl
##>>	Created Time:	2014-07-21 15-41-21
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;

###########################
# this script calculates TSS region ChIP-Seq reads RPM value;
###########################

unless (@ARGV) { 
	pod2usage (-verbose => 2 );
	}
my $genome = "/home/whu5003data/genome_index/hg19/hg19.chrom.txt"; 

my %genome = ();

open my $genome_fh, "<", $genome or die "can not open given genome file. \n";

while (<$genome_fh>) {
	chomp;
	next if /^#/;
	my @tmp = split /\t/;
	$genome{$tmp[0]} = $tmp[1];
	}
close $genome_fh;

my ($bed,$refgene,$extend,$output);

GetOptions (
		"bed=s"		=>\$bed,
		"refgene=s"	=>\$refgene,
		"extend=i"	=>\$extend,
		"output=s"	=>\$output,
		);
	
############  get TSS region of each refgeen  #######################

open my $tmp_tss_fh, ">", "./tmp_tss_region" or die "can not open tmp tss region file. \n";
open my $refgene_fh, "<", $refgene or die "can not open given refgene file. \n";

while (<$refgene_fh>) {
	chomp;
	my @tmp = split/\t/;
	# chr	$start	$end	$refgene_name	0	$strand		...
	my ($chr,$start,$end,$refgene_name,$strand) = @tmp[0,1,2,3,5];
	my $chr_end = $genome{$chr};	# end position of given chromosome
	my ($tss_start,$tss_end);
	if ($strand eq "+") {
		$tss_start = $start - $extend;
		$tss_end = $start + $extend;
		if ($tss_start >= 0 and $tss_end <= $chr_end) {
			print $tmp_tss_fh join("\t",$chr,$tss_start,$tss_end,$refgene_name,"0",$strand),"\n";
			}
		}
	if ($strand eq "-") {
		$tss_start = $end - $extend;
		$tss_end = $end + $extend;
		if ($tss_start >= 0 and $tss_end <= $chr_end) {
			print $tmp_tss_fh join("\t",$chr,$tss_start,$tss_end,$refgene_name,"0",$strand),"\n";
			}
		}
	}
close $tmp_tss_fh;

################### calculate TSS region reads FPKM value ##########################

open my $tmp_bed_fh, "<", $bed or die "can not open bed reads file. \n";

my $read_number=0;

while (<$tmp_bed_fh>) {
	chomp;
	$read_number+=1;
	}

close $tmp_bed_fh;

my $cmd = "bedtools intersect -a ./tmp_tss_region -b $bed -c -f 1e-3 > tmp_tss_reads";
# reads overlap with TSS region more than 10bp;
system ($cmd);

unlink("./tmp_tss_region");

open my $tmp_tss_reads_fh, "<", "./tmp_tss_reads" or die "can not open tmp tss reads file. \n";
open my $output_fh,">",$output or die "can not open output file. \n";

while (<$tmp_tss_reads_fh>) {
	chomp;
	my @tmp = split/\t/;
	# chr	start	end	name	0	strand	number;
	my $rpm = $tmp[6]*1000000/$read_number;
	print $output_fh join("\t",@tmp[0..5],$rpm),"\n";
	}
close $tmp_tss_reads_fh;
close $output_fh;
unlink("./tmp_tss_reads");



__END__

=head1	NAME

tss_region_rpm.pl

=head1 SYNOPSIS

tss_region_rpk -bed <reads.bed>	-refgene <gene.bed>	-extend	<int>	-output <output-file>


