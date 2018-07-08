configfile: "snakemake/config.yaml"

sample = config['Sample']
histone = config['Histone']
rep = config['Rep']

include: "snakemake/qc.snakefile"
