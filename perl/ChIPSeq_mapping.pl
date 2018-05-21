#!/usr/bin/perl
# File name : ChIPSeq_mapping.pl
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
###############################
BEGIN{
	push @INC,"/usr/local/bin/ChIPSeq";
	}
use warnings;
use strict;
use Cwd;
use Getopt::Long;
use Pod::Usage;
use ChIPSeq_mapping;


my %opt = ();
my $first;
my $second;
my $file;
my $output;
my $help;

GetOptions (\%opt,
	'bwaMemSe',
	'bwaMemPe',
	'bwaAlnSe',
	'bwaAlnPe',
	'bowtie2Se',
	'bowtie2Pe',
	'file=s',
	'first=s',
	'second=s',
	'output=s',
	'help'
	);

if (defined $opt{'help'}) {
	pod2usage { -verbose => 2};
	exit(0);
	}

if (defined $opt{'file'}) {
	$file = $opt{'file'};
	}
if (defined $opt{'first'}) {
	$first = $opt{'first'};
	}
if (defined $opt{'second'}) {
	$second = $opt{'second'};
	}
if (defined $opt{'output'}) {
	$output = $opt{'output'};
	}

if (defined $opt{'bwaMemSe'}) {
	# map single end sequence to reference genome by BWA MEM SE;
	bwa_mem_se ($file,$output);
	}
if (defined $opt{'bwaMemPe'}) {
	# map paired end sequence to reference genome by BWA MEM PE;
	bwa_mem_pe ($first,$second,$output);
	}
if (defined $opt{'bwaAlnSe'}) {
	# map single end sequence to reference genome by BWA ALN SE;
	bwa_aln_se ($file,$output);
	}
if (defined $opt{'bwaAlnPe'}) {
	# map paired end sequence to reference genome by BWA ALN PE;
	bwa_aln_pe ($first,$second,$output);
	}
if (defined $opt{'bowtie2Se'}) {
	# map single end sequence to reference genome by bowtie2;
	bowtie2_se ($file,$output);
	}
if (defined $opt{'bowtie2Pe'}) {
	# map paired end sequence to reference genome by bowtie2;
	bowtie2_pe ($first,$second,$output);
	}



__END__

=head1 NAME 

ChIPSeq_mapping.pl

=head1 SYNOPSIS

ChIPSeq_mapping.pl [options]* <.fastq> <.sam>

=head1 OPTIONS

=over 8

-bwaMemSe	

	$file	$output
		
-bwaMemPe

	$first	$second	$output

-bwaAlnSe

	$file	$output

-bwaAlnPe

	$first	$second	$output

-bowtie2Se

	$file	$output

-bowtie2Pe

	$first	$second	$output
	
=back













