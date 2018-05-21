#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	peaks_region_rpm.pl
##>>	Created Time:	2014-03-21 08-44-35
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;

my %opt = ();
GetOptions (\%opt,"reads=s","peaks=s","help");

if (defined $opt{"help"}) {
	pod2usage { -verbose => 2};
	}

my $count = 0;
open (IN,"<",$opt{"reads"}) || die;

while (<IN>) {
	chomp;
	$count+=1;
	}
close IN;

system ("coverageBed -a $opt{'reads'} -b $opt{'peaks'} | sort -k1,1 -k2,2n > temp");

open (IN2,"<", "./temp") || die;

while (<IN2>) {
	chomp;
	my @tmp = split/\t/;
	# chr	start	end	reads_number
	my $peaks_length = $tmp[2] - $tmp[1];
	my $peaks_rpm = ($tmp[3]*1000000)/$count;
	print join("\t",@tmp[0,1,2],$peaks_rpm),"\n";
	}
close IN2;
unlink "./temp";
exit(0);

__END__

=head1 SYNOPSIS

peaks_region_rpm.pl -reads <non-redundant reads> -peaks <peaks region> -help


