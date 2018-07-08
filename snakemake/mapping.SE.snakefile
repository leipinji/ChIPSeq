configfile: "snakemake/config.yaml"

rule all:
	input:
		expand("mapped/rmdup/{dataset}.rmdup.bam",dataset=config['SAMPLE']),
		expand("mapped/sorted/{sample}.sorted.bam.bai",sample=config['SAMPLE'])

rule bowtie2_map_SE:
	params:
		index = config['index']
	input:
		fastq="raw_data/{sample}.fastq",
	output:
		"mapped/{sample}.bam"
	threads: 20

	shell:
		"bowtie2 -q --end-to-end --sensitive -x {params.index} {input.fastq} |samtools view -Sb - > {output}"


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

