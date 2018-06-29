#!/usr/bin/python
import sys
import re

gff = sys.argv[1]
file = open(gff,'r')
#print "\t".join(("Chr","start","end","geneSymbol",".","strand"))

for line in file.readlines():
	line = line.strip("\n")
	line_match = re.match(r"^#",line)
	if line_match:
		continue
	line_col = line.split("\t")
	if line_col[2] == 'gene':
		# attribute column
		attr = line_col[8]
		attr_list = attr.split(";")
		gene_name = attr_list[3]
		
		#gene_id = attr_list[1]
		# split gene_id and gene_name value
		gene_name_list = gene_name.split("=")
		
		#gene_id_list = transcript_id.split("=")
		# gene_id and gene_name
		gene_name_value = gene_name_list[1]
		#gene_name_value_match = re.match(r"\"(.*)\"",gene_name_value)


		#gene_id_value = gene_id_list[2]
		#gene_id_value_match = re.match(r"\"(.*)\"",gene_id_value)

		#print "\t".join((gene_id_value,gene_name_value,gene_type_value,gene_status_value))
		chromosome = line_col[0]
		start = line_col[3]
		end = line_col[4]
		geneSymbol = gene_name_value
		score = "."
		strand = line_col[6]

		print "\t".join((geneSymbol,chromosome,start,end,geneSymbol,score,strand))

	




