configfile: "snakemake/config.yaml"
<<<<<<< HEAD
SAMPLE = config['SAMPLE']

rule all:
	input:
		expand('clean/{sample}_clean_R1.fastq.gz',sample=SAMPLE),
		expand('clean/{sample}_clean_R2.fastq.gz',sample=SAMPLE)
=======
>>>>>>> df81e3b27a1071dfac022b513b61aa0638448b6f

sample = config['Sample']
histone = config['Histone']
rep = config['Rep']

rule all:
	input:
<<<<<<< HEAD
		fastq_R1 = "raw_data/{sample}_R1.fastq.gz",
		fastq_R2 = "raw_data/{sample}_R2.fastq.gz"
	output:
		clean_R1 = "clean/{sample}_clean_R1.fastq.gz",
		clean_R2 = "clean/{sample}_clean_R2.fastq.gz",
		log = "clean/{sample}_cutadapt.log"
	shell:
		"cutadapt_PE.sh {input.fastq_R1} {input.fastq_R2} {output.clean_R1} {output.clean_R2} > {output.log} 2>&1"

=======
		expand("qc/clean/{histone}/{sample}/{rep}/",histone=histone,sample=sample,rep=rep), 
		expand("qc/clean/{histone}/{sample}/{rep}/R2",histone=histone,sample=sample,rep=rep),
		expand("qc/raw/{histone}/{sample}/{rep}/R1",histone=histone,sample=sample,rep=rep),
		expand("qc/raw/{histone}/{sample}/{rep}/R2",histone=histone,sample=sample,rep=rep)
>>>>>>> df81e3b27a1071dfac022b513b61aa0638448b6f


rule clean_qc:
	input:
		R1 = "clean/{histone}/{sample}-R{rep}_clean_R1.fastq.gz",
		R2 = "clean/{histone}/{sample}-R{rep}_clean_R2.fastq.gz"
	output:
		R1 = "qc/clean/{histone}/{sample}/{rep}/R1/",
		R2 = "qc/clean/{histone}/{sample}/{rep}/R2/"

	shell:
		"fastqc -o {output.R1}" 
