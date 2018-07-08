configfile: "snakemake/config.yaml"
<<<<<<< HEAD

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
=======
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
>>>>>>> df81e3b27a1071dfac022b513b61aa0638448b6f

	shell:
		"bowtie2 -q -p 20 --end-to-end --sensitive -x {params.index} -1 {input.fastq_R1} -2 {input.fastq_R2} |samtools view -Sb - > {output}"

rule bam_sort:
	input:
<<<<<<< HEAD
		"mapped/{sample}.bam"
	output:
		"mapped/sorted/{sample}.sorted.bam"
	shell:
		"samtools sort -T data/mapped/sorted/{wildcards.sample} -O bam {input} > {output}"
=======
		"mapped/mapped/{histone}/{sample}-R{rep}.bam"
	output:
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam"
	shell:
		"samtools sort -T mapped/sorted/{wildcards.histone}/{wildcards.sample} -O bam {input} > {output}"
>>>>>>> df81e3b27a1071dfac022b513b61aa0638448b6f


rule bam_index:
	input:
<<<<<<< HEAD
		"mapped/sorted/{sample}.sorted.bam"
	output:
		"mapped/sorted/{sample}.sorted.bam.bai"
=======
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam"
	output:
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam.bai"
>>>>>>> df81e3b27a1071dfac022b513b61aa0638448b6f
	shell:
		"samtools index {input}"

rule bam_rmdup:
	input:
<<<<<<< HEAD
		"mapped/sorted/{sample}.sorted.bam"
	output:
		"mapped/rmdup/{sample}.rmdup.bam"
=======
		"mapped/sorted/{histone}/{sample}-R{rep}.sorted.bam"
	output:
		"mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam"
>>>>>>> df81e3b27a1071dfac022b513b61aa0638448b6f
	shell:
		"samtools rmdup {input} {output}"

rule bam_rmdup_index:
	input:
<<<<<<< HEAD
		"mapped/rmdup/{sample}.rmdup.bam"
	output:
		"mapped/rmdup/{sample}.rmdup.bam.bai"
=======
		"mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam"
	output:
		"mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam.bai"
>>>>>>> df81e3b27a1071dfac022b513b61aa0638448b6f
	shell:
		"samtools index {input}"
	
