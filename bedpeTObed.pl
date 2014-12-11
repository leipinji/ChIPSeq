#!/usr/bin/perl
# File name : bedpeTObed.pl
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
###############################
use warnings;
use strict;
use List::Util qw(min max);
my $input = $ARGV[0];
open my $input_fh, "<", $input or die;
while (<$input_fh>) {
	chomp;
	next unless /^chr/;
	my @t = split/\t/;
	# chr start end chr start end name score strand1 strand2
	my $new_start = min (@t[1,2,4,5]);
	my $new_end = max (@t[1,2,4,5]);
	print join("\t",$t[0],$new_start,$new_end,$t[6],255,"+"),"\n";
	}
close $input_fh;


