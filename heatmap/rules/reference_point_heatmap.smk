#def get_color(wildcard):
#    color = samples.loc[:,"color"].dropna()
#    return color.tolist()

#def get_yMin(wildcard):
#    yMin = samples.loc[:,"yMin"].dropna()
#    return yMin.tolist()
#
#def get_yMax(wildcard):
#    yMax = samples.loc[:,"yMax"].dropna()
#    return yMax.tolist()
#
#def get_zMin(wildcard):
#    zMin = samples.loc[:,"zMin"].dropna()
#
#def get_zMax(wildcard):
#    zMax = samples.loc[:,"zMax"].dropna()


rule reference_point:
	input:
		bigwig = get_bigwig,
		peaks = get_peaks

	output:
		"results/{prefix}_matrix.gz"

	params:
		upStream = config['upStream'],
		downStream = config['downStream'],
		binSize = config['binSize'],
		extra = "--referencePoint center --sortRegions descend --sortUsing mean --sortUsingSamples 1 --missingDataAsZero",
		label = get_samples

	log:
		"log/{prefix}_reference_point.log"
	shell:
		"computeMatrix reference-point {params.extra} --upstream {params.upStream} --downstream {params.downStream} --binSize {params.binSize} --samplesLabel {params.label} -R {input.peaks} -S {input.bigwig} --outFileName {output}"

# plot enrichment heatmap at peaks center
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


# plot enrichment profile at peaks center
rule plot_profile:
	input:
		"results/{prefix}_matrix.gz"
	output:
		"results/{prefix}_profile.svg"
	params:
		color = get_profile_color,
		extra = "--averageType mean --plotType lines --dpi 300 --plotFileFormat svg --numPlotsPerRow 1 --refPointLabel center --perGroup"
	shell:
		"plotProfile -m {input} -out {output} --color {params.color} {params.extra}"
