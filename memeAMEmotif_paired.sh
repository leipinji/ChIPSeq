#!/bin/bash
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
################################
summit=$1	# peaks summit
bg_summit=$2
bed=${summit/.bed/_200bp.bed}	# peaks summit bed
bg_bed=${bg_summit/.bed/_200bp.bed}
echo "awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-100,int(($3+$2)/2)+100}' $summit >$bed"
awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-100,int(($3+$2)/2)+100}' $summit >$bed
echo "awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-100,int(($3+$2)/2)+100}' $summit >$bed"
awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-100,int(($3+$2)/2)+100}' $bg_summit >$bg_bed
genome="/home/leipinji/genomeIndex_lei/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa"
fasta=${bed/.bed/.fasta}
bg_fasta=${bg_bed/.bed/.fasta}

# echo "fastaFromBed -fi $genome -bed $bed > $fasta"
fastaFromBed -fi $genome -bed $bed > $fasta
fastaFromBed -fi $genome -bed $bg_bed > $bg_fasta
meme_db="/home/leipinji/genomeIndex_lei/meme_motif/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme"

meme2alph $meme_db alphabet.txt
# fasta-shuffle-letters -alph alphabet.txt -kmer 2 -tag -dinuc -seed 1 $fasta ${fasta/.fasta/_shuffled.fasta}
ame --verbose 1 --oc ame-output-dir --control $bg_fasta --bgformat 1 --scoring avg --method ranksum --pvalue-report-threshold 0.05 $fasta $meme_db
