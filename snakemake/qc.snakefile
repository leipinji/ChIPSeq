configfile: "./config.yaml"

rule qc:
	input:
		fastq=expand("data/samples/{sample}.fastq",sample=config['SAMPLE'])
	output:
		"data/qc/"
	shell:
		"fastqc {input} -o {output} " 


