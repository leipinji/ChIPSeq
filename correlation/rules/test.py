#!/data3/leipingji/anaconda2/envs/python3/bin/python
import pandas as pd

def get_bigwig(sampleSheet):
    sample = pd.read_table(sampleSheet,dtype=str)
    sample_dataframe = sample.loc[:,["bigwig1","bigwig2"]].dropna()
    output = []
    for i in range(len(sample)):
        wig = sample_dataframe.loc[i].tolist()
        filename = " ".join(wig)
        #output.extend(filename)
        output.append(filename)
    return output


bigwig = get_bigwig("../samples.tsv")
print (bigwig)

