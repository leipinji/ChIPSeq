configfile: "snakemake/config.yaml"

sample = config['Sample']
histone = config['Histone']
rep = config['Rep']

rule all:
	input:
		expand('clean/{histone}/{sample}-R{rep}_clean_R1.fastq.gz',sample=sample,histone=histone,rep=rep),
		expand('clean/{histone}/{sample}-R{rep}_clean_R2.fastq.gz',sample=sample,histone=histone,rep=rep)

rule qc:
	input:
		fastq_R1 = "raw_data/{sample}-{rep}-{histone}_combined_R1.fastq.gz",
		fastq_R2 = "raw_data/{sample}-{rep}-{histone}_combined_R2.fastq.gz"
	output:
		clean_R1 = "clean/{histone}/{sample}-R{rep}_clean_R1.fastq.gz",
		clean_R2 = "clean/{histone}/{sample}-R{rep}_clean_R2.fastq.gz",
		log = "clean/{histone}/{sample}-R{rep}_cutadapt.log"
	shell:
		"cutadapt_PE.sh {input.fastq_R1} {input.fastq_R2} {output.clean_R1} {output.clean_R2} > {output.log} 2>&1"
