#!/usr/bin/perl
####################
#
#  homer.peaks.annotation.pl
#
#  Author: Lei Pinji
#
####################
use strict;
use warnings;
use Getopt::Long;

my ($peaks_annotate,$genome_element,$tss,$output,$help);
my %opt;

GetOptions(\%opt,
    "peaks=s"   => \$peaks_annotate,
    "element=s" => \$genome_element,
    "help"    => \$help,
);

if ($help) {
        print<<EOF;
        Usage: $0 -peaks [peaks annotated] -element [output genome element]
EOF
        exit(0);
    }

open my $peaks_annotate_fh, "<", $peaks_annotate or die "can not open peaks annotate file\n";
open my $element_fh, ">",$genome_element or die "can not open genome element file\n";

# genome element
my ($promoter_tss,$exon,$intron,$utr3,$utr5,$intergenic,$tts) = (0,0,0,0,0,0,0);

# output refgene with peaks in promoter region
while (<$peaks_annotate_fh>) {
        chomp;
        next if /^PeakID/;
        my @tmp = split/\t/;
        # genome element
        my $element = $tmp[7];
        # 3' UTR
        # 5' UTR
        # Intergenic
        # intron
        # exon
        # non-coding
        # promoter-TSS
        # TTS
        my $distance = $tmp[9];
        next if $element =~ m/NA/;

        if (($element =~ /^promoter-TSS/) or ($distance >= -1000 and $distance <= 1000)) {
            $promoter_tss += 1;
        }
        else {
            if ($element =~ /^3'\sUTR/) {$utr3 += 1;}
            if ($element =~ /^5'\sUTR/) {$utr5 += 1;}
            if ($element =~ /^Intergenic/) {$intergenic += 1;}
            if ($element =~ /^intron/) {$intron += 1;}
            if ($element =~ /^exon/) {$exon += 1;}
            if ($element =~ /^non-coding.*exon/) {$exon +=1;}
            if ($element =~ /^TTS/) {$tts += 1;}
        }
        }

my $element_file=<<EOF;
Promoter_TSS    $promoter_tss
UTR_3   $utr3
Exon    $exon
Intron  $intron
UTR_5   $utr5
TTS $tts
Intergenic  $intergenic
EOF
print $element_fh $element_file;


