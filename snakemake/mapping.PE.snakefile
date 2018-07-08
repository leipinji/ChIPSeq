configfile: "snakemake/config.yaml"

rule all:
	input:
		expand("mapped/rmdup/{dataset}.rmdup.bam",dataset=config['SAMPLE']),
		expand("mapped/sorted/{sample}.sorted.bam.bai",sample=config['SAMPLE']),
		expand("mapped/rmdup/{sample}.rmdup.bam.bai",sample=config['SAMPLE'])

rule bowtie2_map:
	params:
		index = config['index']
	input:
		fastq_R1 = "clean/{sample}_clean_R1.fastq.gz",
		fastq_R2 = "clean/{sample}_clean_R2.fastq.gz"
	output:
		"mapped/{sample}.bam"

	shell:
		"bowtie2 -q -p 20 --end-to-end --sensitive -x {params.index} -1 {input.fastq_R1} -2 {input.fastq_R2} |samtools view -Sb - > {output}"

rule bam_sort:
	input:
		"mapped/{sample}.bam"
	output:
		"mapped/sorted/{sample}.sorted.bam"
	shell:
		"samtools sort -T data/mapped/sorted/{wildcards.sample} -O bam {input} > {output}"


rule bam_index:
	input:
		"mapped/sorted/{sample}.sorted.bam"
	output:
		"mapped/sorted/{sample}.sorted.bam.bai"
	shell:
		"samtools index {input}"

rule bam_rmdup:
	input:
		"mapped/sorted/{sample}.sorted.bam"
	output:
		"mapped/rmdup/{sample}.rmdup.bam"
	shell:
		"samtools rmdup {input} {output}"

rule bam_rmdup_index:
	input:
		"mapped/rmdup/{sample}.rmdup.bam"
	output:
		"mapped/rmdup/{sample}.rmdup.bam.bai"
	shell:
		"samtools index {input}"
	
