#!/bin/bash
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
################################
summit=$1	# peaks summit
bed=${summit/.bed/_100bp.bed}	# peaks summit bed
echo "awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-50,int(($3+$2)/2)+50}' $summit >$bed"
awk 'BEGIN{OF="\t";OFS="\t"}{print $1,int(($3+$2)/2)-50,int(($3+$2)/2)+50}' $summit >$bed
genome="/home/leipinji/genomeIndex_lei/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa"
fasta=${bed/.bed/.fasta}

echo "fastaFromBed -fi $genome -bed $bed > $fasta"
fastaFromBed -fi $genome -bed $bed > $fasta
meme_db="/home/leipinji/genomeIndex_lei/meme_motif/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme"
meme2alph $meme_db alphabet.txt
fasta-shuffle-letters -alph alphabet.txt -kmer 2 -tag -dinuc -seed 1 $fasta ${fasta/.fa/_shuffled.fa}
ame --verbose 1 --oc ame-output-dir-genome-background --control ${fasta/.fa/_shuffled.fa} --bgformat 1 --scoring avg --method ranksum --pvalue-report-threshold 0.05 $fasta $meme_db
