def get_bigwig(wildcard):
    sample_dataframe = sample.loc[:,["bigwig1","bigwig2"]].dropna()
    output = []
    for i in range(len(sample)):
        wig = sample_dataframe.loc[i].values.tolist()
        output.extend(wig)
    return output

def get_labels(wildcard):
    labels_series = sample.loc[:,["labels1","labels2"]].dropna()
    output = []
    for i in range(len(sample)):
        labs = sample.loc[i].values.tolist()
	labels = " ".join(labs)
	output.append(labels)
    return output

def get_bed(wildcard):
    bed_series = sample.loc[:,("bed")].dropna()
    bed_list = bed_series.tolist()
    return bed_list

def get_line(wildcard):
	line = sample.loc[:,["labels1","labels2","bed"]].dropna()
	output = []
	for i in range(len(sample)):
		file = line.loc[i].tolist()
		output.append(file)
	return output

	
