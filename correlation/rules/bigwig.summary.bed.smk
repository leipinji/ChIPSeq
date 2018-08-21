rule Bigwig_summary_BED:
	input:
	 bigwig1 = bigwig1,
	 bigwig2 = bigwig2
	output:
	 "results/"
	params:
	 labels1 = labels1,
	 labels2 = labels2,
	 bed = bed,
	 extra = "--corMethod pearson --whatToPlot scatterplot --log1p --plotFileFormat svg",
	 title = config['title']
	run:
		for i in range(len(input.bigwig1)):
			bigwig1 = input.bigwig1[i]
			bigwig2 = input.bigwig2[i]
			labels1 = params.labels1[i]
			labels2 = params.labels2[i]
			bed = params.bed[i]
			outputFile = "results/" + labels1 + "-" + labels2 + ".npz"
			outputPlot = "results/" + labels1 + "-" + labels2 + ".svg"

			shell("multiBigwigSummary BED-file --bwfiles {} {} --outFileName {} --BED {} --labels {} {} -p 10".format(bigwig1,bigwig2,outputFile,bed,labels1,labels2))
			shell("plotCorrelation --corData {} --plotFile {} --labels {} {} --plotTitle {} {}".format(outputFile,outputPlot,labels1,labels2,params.title,params.extra))
