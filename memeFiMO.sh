#!/usr/bin/bash
#########################
#
#  memeFiMO.sh
#
#  Author: Lei Pinji
#
#########################
fa=$1
meme_motif=$2
# meme_motif=/home/leipinji/genomeIndex_lei/meme_motif/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme
fimo --oc fimo-output-dir --parse-genomic-coord $meme_motif $fa
