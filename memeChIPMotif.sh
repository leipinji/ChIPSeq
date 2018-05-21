#!/bin/bash
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
################################
summit=$1	# peaks summit
bed=${summit/.bed/_200bp.bed}	# peaks summit bed
echo "awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-100,int(($3+$2)/2)+100}' $summit >$bed"
awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-100,int(($3+$2)/2)+100}' $summit >$bed
genome="/home/leipinji/genomeIndex_lei/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa"
fasta=${bed/.bed/.fasta}

echo "fastaFromBed -fi $genome -bed $bed > $fasta"
fastaFromBed -fi $genome -bed $bed > $fasta
meme_db="/opt/meme_db/HUMAN/HOCOMOCOv10_HUMAN_mono_meme_format.meme"

echo "meme-chip -oc . -index-name meme-chip.html -time 300 -order 1 -db $meme_db -meme-mod zoops -meme-minw 6 -meme-maxw 25 -meme-nmotifs 20 -meme-minsites 10 -dreme-e 0.05 -centrimo-score 5.0 -centrimo-ethresh 10.0 $fasta"
meme-chip -oc . -index-name meme-chip.html -time 300 -order 1 -db $meme_db -meme-mod zoops -meme-minw 6 -meme-maxw 25 -meme-nmotifs 20 -meme-minsites 10 -dreme-e 0.05 -centrimo-score 5.0 -centrimo-ethresh 10.0 $fasta

