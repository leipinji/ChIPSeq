rule test:
	input:
	 bigwig1 = bigwig1,
	 bigwig2 = bigwig2
	output:
	 "results/"
	params:
	 file1 = labels1,
	 file2 = labels2

	run:
		for i in range(len(input.bigwig1)):
			shell("cp {} {}".format(input.bigwig1[i],params.file1[i]))
			shell("cp {} {}".format(input.bigwig2[i],params.file2[i]))
			shell("mv {} results/".format(params.file1[i]))
			shell("mv {} results/".format(params.file2[i]))
	     
