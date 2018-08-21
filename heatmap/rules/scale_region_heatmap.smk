#def get_bigwig(wildcard):
#    return samples.loc[:,'bigwig'].dropna()
#
#def get_samples(wildcard):
#    sample_series = samples.loc[:,"sample"].dropna()
#    sample_list = sample_series.tolist()
#    return sample_list
#
#
#def get_peaks(wildcard):
#    return peaks.loc[:,"peaks"].dropna()


#scale_region_matrix = "results/scale_region_matrix.gz"
#reference_point_matrix = "results/reference_point_matrix.gz"

rule scale_region:
	input: 
		bigwig = get_bigwig,
		peaks = get_peaks
	output:
		"results/{prefix}_matrix.gz"

	params:
		upStream = config['upStream'],
		downStream = config['downStream'],
		binSize = config['binSize'],
		extra = "--sortRegions descend --sortUsing mean --sortUsingSamples 1 --missingDataAsZero -m 10000",
		label = get_samples

	log:
		"log/{prefix}_scale_region.log"
	shell:
		"computeMatrix scale-regions {params.extra} --upstream {params.upStream} --downstream {params.downStream} --binSize {params.binSize} --samplesLabel {params.label} -R {input.peaks} -S {input.bigwig} --outFileName {output}"


#rule reference_point:
#	input:
#		bigwig = get_bigwig,
#		peaks = get_peaks
#
#	output:
#		"results/reference_point_matrix.gz"
#
#	params:
#		upStream = config['upStream'],
#		downStream = config['downStream'],
#		binSize = config['binSize'],
#		extra = "--referencePoint center --sortRegions descend --sortUsing mean --sortUsingSamples 1 --missingDataAsZero",
#		label = get_samples
#
#	log:
#		"log/reference_point.log"
#	shell:
#		"computeMatrix reference-point {params.extra} --upstream {params.upStream} --downstream {params.downStream} --binSize {params.binSize} --samplesLabel {params.label} -R {input.peaks} -S {input.bigwig} --outFileName {output}"
#
#
#rule test:
#	input:
#		bigwig = "{sample}.bigwig"
#	output:
#		"test.txt"
#	shell:
#		"ls -l {input.bigwig} > {output}"

# plot enrichment heatmap at gene-locus

rule plot_heatmap:
	input:
		"results/{prefix}_matrix.gz",
	output:
		"results/{prefix}_heatmap.svg",
	params:
		color = get_color,
#		yMin = config['get_yMin'],
#		yMax = config['get_yMax'],
#		zMin = config['get_zMin'],
#		zMax = config['get_zMax'],
		yMin = get_yMin,
		yMax = get_yMax,
		zMin = get_zMin,
		zMax = get_zMax,
		heatmapWidth = config['heatmapWidth'],
		extra = "--plotFileFormat svg --dpi 300 --averageTypeSummaryPlot mean --missingDataColor white --whatToShow 'heatmap and colorbar'"
	log:
		"log/{prefix}_plot_heatmap.log"
	shell:
		"plotHeatmap {params.extra} --matrixFile {input} --outFileName {output} --colorMap {params.color} --zMin {params.zMin} --zMax {params.zMax} --heatmapWidth {params.heatmapWidth}"

# plot enrichment profile at gene-locus

rule plot_profile:
	input:
		"results/{prefix}_matrix.gz"
	output:
		"results/{prefix}_profile.svg"
	params:
		color = get_profile_color,
		extra = "--averageType mean --plotType lines --dpi 300 --plotFileFormat svg --numPlotsPerRow 1 --perGroup"
	shell:
		"plotProfile -m {input} -out {output} --colors {params.color} {params.extra}"
