rule correlation:
	input:
		"results/{labels1}-{labels2}.npz"
	output:
		"ScatterPlot/"
	params:
		title = config['title'],
		extra = "--corMethod pearson --whatToPlot scatterplot --log1p --plotFileFormat svg",
		file = "ScatterPlot/{labels1}-{labels2}.scatterPlot.svg"

	run:
		shell("plotCorrelation --corData {} --plotFile {} --labels {} {} --plotTitle {} {}".format(input,params.file,{wildcards.labels1},{wildcards.labels2},params.title,params.extra))

