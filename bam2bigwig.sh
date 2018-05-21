#!/usr/bin/bash
#########################
#
#  bam2bigwig.sh
#
#  Author: Lei Pinji
#
#########################
bam=$1
output=${bam/.bam/.bigwig}
bamCoverage --bam $bam --outFileName $output --outFileFormat bigwig --binSize 10 --normalizeUsingRPKM --ignoreDuplicates
