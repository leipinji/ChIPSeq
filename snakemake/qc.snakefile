configfile: "snakemake/config.yaml"

sample = config['Sample']
histone = config['Histone']
rep = config['Rep']

rule all:
	input:
		expand("qc/clean/{histone}/{sample}/{rep}/",histone=histone,sample=sample,rep=rep), 
		expand("qc/clean/{histone}/{sample}/{rep}/R2",histone=histone,sample=sample,rep=rep),
		expand("qc/raw/{histone}/{sample}/{rep}/R1",histone=histone,sample=sample,rep=rep),
		expand("qc/raw/{histone}/{sample}/{rep}/R2",histone=histone,sample=sample,rep=rep)


rule clean_qc:
	input:
		R1 = "clean/{histone}/{sample}-R{rep}_clean_R1.fastq.gz",
		R2 = "clean/{histone}/{sample}-R{rep}_clean_R2.fastq.gz"
	output:
		R1 = "qc/clean/{histone}/{sample}/{rep}/R1/",
		R2 = "qc/clean/{histone}/{sample}/{rep}/R2/"

	shell:
		"fastqc -o {output.R1}" 
