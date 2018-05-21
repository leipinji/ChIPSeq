#!/usr/bin/bash
#########################
#
#  homer_motif.sh
#
#  Author: Lei Pinji
#
#########################
peaks=$1
genome=/opt/homer/data/genomes/hg38/genome.fa
output_dir=motif
motif=/home/leipinji/genomeIndex_lei/meme_motif/HOCOMOCOv11_full_HUMAN_mono_homer_format_0.001.motif
findMotifsGenome.pl $peaks $genome $output_dir -size 200 -p 10 -S 50 -mknown $motif -len 6,8,10,12,15,20 -mis 3 -h -cpg
