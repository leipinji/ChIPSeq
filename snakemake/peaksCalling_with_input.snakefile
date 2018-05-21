configfile: "./config_peakscalling_with_input.yaml"

rule all:
	input:
		expand("data/peaks/{sample}/{sample}",sample=config['SAMPLE'])

rule macs_peaks:
	params:
		org=config['org']
	input:
		treat=expand("data/mapped/rmdup/{sample}.rmdup.bam",sample=config['SAMPLE']),
		control=expand("data/mapped/rmdup/{sample}.rmdup.bam",sample=config['input'])
	output:
		"data/peaks/{sample}/{sample}"
	shell:
		"macs14 -t {input.treat} -c {input.control} -f BAM -n data/peaks/{wildcards.sample}/{wildcards.sample} -g {params.org} -p 1e-8"


