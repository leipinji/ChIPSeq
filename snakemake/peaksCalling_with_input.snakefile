configfile: "snakemake/config_peakscalling_with_input.yaml"

SAMPLE = config['Sample']
HISTONE = config['Histone']
REP = config['Rep']

rule all:
	input:
		expand("peaks/{histone}/{histone}-{sample}-R{rep}/",sample=SAMPLE,histone=HISTONE,rep=REP)

rule macs_peaks:
	params:
		org=config['mm']
	input:
		treat= "mapped/rmdup/{histone}/{sample}-R{rep}.rmdup.bam",
		control= "mapped/rmdup/Input/{sample}-R{rep}.rmdup.bam"
	output:
		"peaks/{histone}/{histone}-{sample}-R{rep}/"
	shell:
		"macs14 -t {input.treat} -c {input.control} -f BAM -n peaks/{wildcards.histone}/{wildcards.histone}-{wildcards.sample}-R{wildcards.rep}/{wildcards.histone}-{wildcards.sample}-R{wildcards.rep} -g {params.org} -p 1e-8"


