#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	tss_region_pileup.pl
##>>	Created Time:	2014-02-21 19-52-30
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
use Getopt::Long;

my ($bed, $refgene);
my %opt = ('bed' =>\$bed, 'refgene' => \$refgene); 
# $refgene used to pileup TSS region read number 
# $refgene must be given in BED like format 
# chr start end name <score/options>* strand 
GetOptions(\%opt,"output=s","extend=i","bins=i","bed=s","refgene=s","help"
);

if (defined $opt{"help"}) {
	print "Usage : tss_region_pileup.pl <BED> <refGene> <bins>* <extend>* <output>*\n";
	print "default:\nbins: 20\nextend: 3000\noutput: STDOUT\n";
	exit(0);
			}
my $gap=0;
my @index; # order refseq gene order (increase or decrease expression);
open my $refgene_fh, "<", $refgene || die "can not open the file $refgene:$!";
open my $tmp_fh, ">", "./tmp_tss_bins" || die "can not open the file tmp_tss_bins :$!"; 
OUTER: while (<$refgene_fh>) {
			chomp;
			next if /^#/;
			my($chr,$start,$end,$name,$strand) = (split/\t/)[0,1,2,3,5];
			$name = "$chr:$start-$end;$name";
			my ($extend,$bins,$tss);
		       				if ($strand eq "+") {
							$tss=$start;
							}
						elsif ($strand eq "-") {
							$tss=$end;
							}
						#default upstream and downstream extend 3000bps;
						if (defined $opt{"extend"}) {
							$extend = $opt{"extend"};
						}
						elsif (!defined $opt{"extend"}) {
							$extend = 3000;
						}
						# default bins 20;
						# upstream 10 bins and downstream 10 bins;

						if (defined $opt{"bins"}) {
							$bins = $opt{"bins"};
						}
						elsif (!defined $opt{"bins"}) {
							$bins = 20;
						}
						$gap = 2*$extend/$bins;
						# bins postion;
						if ($tss >= $extend) {
							push @index,$name;
							for (1..$bins) {
								my $bin_start = ($tss-$extend)+($_-1)*$gap;
								my $bin_end = ($tss-$extend)+$_*$gap-1;
								print $tmp_fh join("\t",$chr,$bin_start,$bin_end,$name,"500",$strand),"\n";
								}
							}
						elsif($tss < $extend) {
							next OUTER;
						}
					}


############################ pileup reads number in each bins (FPKM) #############################

my $read_number = `wc -l $bed`;
$read_number = (split/\s/,$read_number)[0];
$read_number=$read_number/1000000;
system ("bedtools intersect -a ./tmp_tss_bins -b $bed -c > tmp_bins.pileup");

open my $pileup_fh, "<", "./tmp_bins.pileup" || die "can not open tmp_bins.pileup:$!";
my %gene=();
while (<$pileup_fh>) {
	chomp;
	my @tmp=split/\t/;
	my $rpm = $tmp[6]/$read_number;
	# normalize read count to RPKM;
	if ($tmp[5] eq "+") {
		push @{$gene{$tmp[3]}},$rpm;
		}
	elsif ($tmp[5] eq "-") {
		unshift @{$gene{$tmp[3]}},$rpm;
		}
	}

my $output_fh;
if (defined $opt{"output"}) {
	open $output_fh, ">", $opt{"output"} || die "can not open the file $opt{'output'}:$!";
	for (0..$#index) {
		my $key = $index[$_];
		print $output_fh join("\t",$key,@{$gene{$key}}),"\n";
	}
}

close $pileup_fh;
close $output_fh;
unlink "./tmp_tss_bins";
unlink "./tmp_bins.pileup";

#################################################################################################

__END__

	




