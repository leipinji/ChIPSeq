#!/usr/bin/perl
# File name : mapping.pl
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
###############################
use warnings;
use strict;
use Cwd;

my $current_work_dir = cwd();
my @dir = split/,/,$ARGV[0];

for(@dir) {
	my $work_dir = $_;
	chdir $work_dir;
	my $tmp_dir = cwd();
	print "my current work directory is : $tmp_dir\n";
	my ($H3K9me3) = <*H3K9me3.fastq>;
	my ($input) = <*input.fastq>;
	my $H3K9me3_sam = $H3K9me3.'.sam';
	my $input_sam = $input.'.sam';
	system ("ChIPSeq_mapping.pl -bowtie2Se -file $H3K9me3 -output $H3K9me3_sam > H3K9me3_alignment_statistics.txt 2>&1");
	system ("ChIPSeq_mapping.pl -bowtie2Se -file $input -output $input_sam > input_alignment_statistics.txt 2>&1");
	chdir $current_work_dir;
	}


