#!/usr/bin/perl
########################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	ChIPSeq-mapping.pm
##>>	Created Time:	2014-01-12 13-25-18
##>>	Mail:	LPJ@whu.edu.cn
########################################################


######################## mapping ChIPSeq reads using BWA ###########################

my $BwaIndex = "/home/whu5003data/genome_index/hg19/hg19BwaIdx";

##### MEM algorithmn single end reads #####

sub bwa_mem_se { # $file $output
	# this function will use BWA MEM algorithmn align single end fastq file 
	# to reference genome as indicate
	my ($file,$output) = @_;
	my $threads = 5;
	system ("bwa mem -t $threads $BwaIndex $file > $output 2> bwa_mem_run_log");
	}

##### MEM algorithmn paired end reads #####

sub bwa_mem_pe { # $first $second $output 
	# this function will use BWA MEM algorithmn align paired end fastq file
	# to reference genome as indicate
	my ($first,$second,$output) = @_;
	my $threads = 5;
	system ("bwa mem -t $threads $BwaIndex $first $second > $output");
	}

##### back-track algorithmn single end reads #####

sub bwa_aln_se { # $file $output
	# this function will use BWA back-track algorithmn aligh single end fatsq file
	# to reference genome as indicate
	my ($file,$output) = @_;
	my $threads = 5;
	system ("bwa aln -t $threads $BwaIndex $file > tmp.sai");
	system ("bwa samse -n 1 $BwaIndex tmp.sai $file > $output");
	unlink ("tmp.sai");
	}

##### back-track algorithmn paired end reads #####

sub bwa_aln_pe { # $first $second $output
	# this function will use BWA back-track algorithmn align paired end fastq file
	# to reference genome as indicate
	my ($first,$second,$output) = @_;
	my $threads = 5 ;
	system ("bwa aln -t $threads $BwaIndex $first > tmp1.sai");
	system ("bwa aln -t $threads $BwaIndex $second > tmp2.sai");
	system ("bwa sampe -o 20 -P -n 1 $BwaIndex tmp1.sai tmp2.sai $first $second > $output");
	unlink("tmp1.sai");
	unlink("tmp2.sai");
	}


############################ mapping ChIPSeq reads using bowtie2 ###############################

my $Bowtie2Index = "/home/whu5003data/genome_index/hg19/bowtie2_index/hg19.bowtie2";

##### bowtie2 single end mapping #####
# bowtie2 [options] -x <index> <fq> -S <SAM>

sub bowtie2_se {# $file $output
	# this function will use bowtie2 align single end sequence fatsq file
	# to reference genome as indicate
	my ($file,$output) = @_;
	my $input = '-q --phred33';
	my $alignment = '-N 0 -L 22 --end-to-end';
	my $report = '-k 1';
	my $threads = '-p 5';
	system ("bowtie2 $input $alignment $report $threads -x $Bowtie2Index $file -S $output");
}

##### bowtie2 paired end mapping #####
# bowtie2 [options] -x <index> -1 <.fq> -2 <.fq> -S <SAM>

sub bowtie2_pe {# $first $second $output
	# this function will use bowtie2 align paired end sequence fastq file
	# to reference genome as indicate
	my ($first,$second,$output) = @_;
	my $input = '-q --phred33';
	my $alignment = '-N 0 -L 22 --end-to-end';
	my $report = '-k 1';
	my $threads = '-p 5';
	my $paired = '--fr --no-mixed --no-discordant';
	system ("bowtie2 $input $alignment $report $threads $paired -x $Bowtie2Index -1 $first -2 $second -S $output");
}


 
	








	



 
		
	
