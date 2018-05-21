configfile: "./config.yaml"

rule all:
	input:
		expand("data/mapped/rmdup/{dataset}.rmdup.bam",dataset=config['SAMPLE']),
		expand("data/mapped/sorted/{sample}.sorted.bam.bai",sample=config['SAMPLE'])

rule bowtie2_map:
	params:
		index = config['index']
	input:
		fastq="data/samples/{sample}.fastq",
	output:
		"data/mapped/{sample}.bam"
	threads: 20

	shell:
		"bowtie2 -q --end-to-end --sensitive -x {params.index} {input.fastq} |samtools view -Sb - > {output}"

rule bam_sort:
	input:
		"data/mapped/{sample}.bam"
	output:
		"data/mapped/sorted/{sample}.sorted.bam"
	shell:
		"samtools sort -T data/mapped/sorted/{wildcards.sample} -O bam {input} > {output}"


rule bam_index:
	input:
		"data/mapped/sorted/{sample}.sorted.bam"
	output:
		"data/mapped/sorted/{sample}.sorted.bam.bai"
	shell:
		"samtools index {input}"

rule bam_rmdup:
	input:
		"data/mapped/sorted/{sample}.sorted.bam"
	output:
		"data/mapped/rmdup/{sample}.rmdup.bam"
	shell:
		"samtools rmdup {input} {output}"

