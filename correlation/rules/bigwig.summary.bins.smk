rule Bigwig_summary_bins:
	input:
		bigwig = get_bigwig
	output:
		"results/bigwig.summary.npz"
	params:
		#labels = config['labels'],
		binSize = config['binSize'],
		labels = get_labels

	threads:
		10
	shell:
		"multiBigwigSummary bins --bwfiles {input.bigwig} --outFileName {output} --binSize {params.binSize} --labels {params.labels} -p {threads}"
