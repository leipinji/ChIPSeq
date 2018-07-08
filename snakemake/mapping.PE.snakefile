configfile: "snakemake/config.yaml"
SAMPLE = config['Sample']
HISTONE = config['Histone']
REP = config['Rep']


rule all:
	input:
		expand("mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam",histone=HISTONE,sample=SAMPLE,rep=REP),
		expand("mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam.bai",sample=SAMPLE,histone=HISTONE,rep=REP),
		expand("mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam.bai",sample=SAMPLE,histone=HISTONE,rep=REP)

rule bowtie2_map:
	params:
		index = config['mm10_bowtie2_index']
	input:
		fastq_R1 = "clean/{histone}/{sample}-R{rep}_clean_R1.fastq.gz",
		fastq_R2 = "clean/{histone}/{sample}-R{rep}_clean_R2.fastq.gz"
	output:
		"mapped/mapped/{histone}/{sample}-R{rep}.bam"

	shell:
		"bowtie2 -q -p 20 --end-to-end --sensitive -x {params.index} -1 {input.fastq_R1} -2 {input.fastq_R2} |samtools view -Sb - > {output}"

rule bam_sort:
	input:
		"mapped/mapped/{histone}/{sample}-R{rep}.bam"
	output:
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam"
	shell:
		"samtools sort -T mapped/sorted/{wildcards.histone}/{wildcards.sample} -O bam {input} > {output}"


rule bam_index:
	input:
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam"
	output:
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam.bai"
	shell:
		"samtools index {input}"

rule bam_rmdup:
	input:
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam"
	output:
		"mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam"
	shell:
		"samtools rmdup {input} {output}"

rule bam_rmdup_index:
	input:
		"mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam"
	output:
		"mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam.bai"
	shell:
		"samtools index {input}"
	
