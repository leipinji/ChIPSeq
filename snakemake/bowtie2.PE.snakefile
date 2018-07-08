rule bowtie2_map:
	params:
		index = config['bowtie2_index']
	input:
		R1 = "clean/{histone}/{sample}-{rep}_clean_R1.fastq.gz",
		R2 = "clean/{histone}

	output:

	shell:

