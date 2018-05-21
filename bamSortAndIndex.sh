#!/usr/bin/bash
#########################
#
#  bamSortAndIndex.sh
#
#  Author: Lei Pinji
#
#########################
bam=$1
samtools sort $bam -o ${bam/.bam/.srt.bam}
samtools index ${bam/.bam/.srt.bam}

