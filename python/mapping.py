#!/usr/bin/python
########################
#
#  mapping.py
#
#  Author: Lei Pinji
#
########################
import sys,os,time
import getopt
optlist,args = getopt.getopt(sys.argv[1:],'ho:',["help","single_end_bw1","single_end_bw2","paired_end_bw1","paired_end_bw2"])

########## subroutine ##########
# help_message()    print help message for this pipeline
def help_message():
            print '''##########
Usage:  %s     [options*]  <index> <.fastq>|[-1 <.R1.fastq>|-2 <.R2.fastq>]
Options:
-h|--help           print this help message
-o                  output file prefix
--single_end_bw1        single end sequence mapping by Bowtie1
--single_end_bw2        single end sequence mapping by Bowtie2
--paired_end_bw1        paired end sequence mapping by Bowtie1
--paired_end_bw2        paired end sequence mapping by Bowtie2
##########''' % sys.argv[0]

# single_end ()
def single_end_bw2(x,q,o):
    index = '-x %s' % x
    output = '-S %s' % o
    fastq = q
    mapping_input = '-q --phred33'
    mapping_alignment = '--end-to-end --sensitive'
    mapping_report = '-k 1'
    mapping_thread = '-p 5'
    return "bowtie2 %s %s %s %s %s %s %s" % (mapping_input,mapping_alignment,mapping_report,mapping_thread,index,fastq,output)

def paired_end_bw2(x,left,right,o):
    index = '-x %s' % x
    left = '-1 %s' % left
    right = '-2 %s' % right
    output = '-S %s' % o
    mapping_input = '-q --phred33'
    mapping_alignment = '--end-to-end --sensitive'
    mapping_report = '-k 1'
    mapping_thread = '-p 5'
    mapping_ruler = '--fr --no-mixed --no-discordant'
    mapping_insert = '-X 1000'
    return "bowtie2 %s %s %s %s %s %s %s %s %s %s" % (mapping_input,mapping_alignment,mapping_report,mapping_thread,mapping_ruler,mapping_insert,index,left,right,output)

def single_end_bw1 (x,q,o):
    index = x
    output = o
    fastq = q
    mapping_input = '-q --phred33'
    mapping_alignment = '-v 2 -k 1 -m 1 -S'
    mapping_al = '--al align'
    mapping_un = '--un unalign'
    mapping_multiple = '--max mutiple_align'
    mapping_thread = '-p 5'
    return 'bowtie %s %s %s %s %s %s %s %s %s' % (mapping_input,mapping_alignment,mapping_al,mapping_un,mapping_multiple,mapping_thread,index,fastq,output)
    
def paired_end_bw1 (x,left,right,o):
    index = x
    left = "-1 %s" % left
    right = '-2 %s' % right
    output = o
    mapping_input = '-q --phred33'
    mapping_alignment = '-v 2 -k 1 -m 1 -X 1000 -S'
    mapping_thread = '-p 5'
    return 'bowtie %s %s %s %s %s %s %s' % (mapping_input,mapping_alignment,mapping_thread,index,left,right,output)
########## main ##########
# mapping
###
output = ''
for opt,value in optlist:
    if opt in ('-h'):
        help_message()
        sys.exit(0)

    if opt in ('-o'):
        output = value
        sam = output+'.sam'

    if opt in ('--single_end_bw1'):
        cmd = single_end_bw1(args[0],args[1],sam)
        print cmd
        print "Start mapping by bowtie......."
        print time.strftime("%Y-%m-%d %H:%M:%S")
        os.system(cmd)
        print "Mapping End"
        print time.strftime("%Y-%m-%d %H:%M:%S")

    if opt in ('--paired_end_bw1'):
        cmd = paired_end_bw1(args[0],args[1],args[2],sam)
        print cmd
        print "Start mapping by bowtie......."
        print time.strftime("%Y-%m-%d %H:%M:%S")
        os.system(cmd)
        print "Mapping End"
        print time.strftime("%Y-%m-%d %H:%M:%S")

    if opt in ('--single_end_bw2'):
        cmd = single_end_bw2(args[0],args[1],sam)
        print cmd
        print "Start mapping by bowtie2......."
        print time.strftime("%Y-%m-%d %H:%M:%S")
        os.system(cmd)
        print "Mapping End"
        print time.strftime("%Y-%m-%d %H:%M:%S")

    if opt in ('--paired_end_bw2'):
        cmd = paired_end_bw2(args[0],args[1],args[2],sam)
        print cmd
        print "Start mapping by bowtie2......."
        print time.strftime("%Y-%m-%d %H:%M:%S")
        os.system(cmd)
        print "Mapping End"
        print time.strftime("%Y-%m-%d %H:%M:%S")

###
# SAM to BAM
cmd = 'samtools view -Sh -b %s > %s.bam' % (sam,output)
print cmd
print "Start SAM format convert to BAM"
print time.strftime("%Y-%m-%d %H:%M:%S")
os.system(cmd)
print "SAM to BAM end"
print time.strftime("%Y-%m-%d %H:%M:%S")
os.remove(sam)

   
###
# SAM to BAM
#cmd = 'samtools view -S -b %s > %s.bam' % (sam,output)
#print cmd
#print "Start SAM format convert to BAM"
#print time.strftime("%Y-%m-%d %H:%M:%S")
#os.system(cmd)
#print "SAM to BAM end"
#print time.strftime("%Y-%m-%d %H:%M:%S")

# BAM sort
cmd = 'samtools sort -n %s -o %s' % (output+'.bam',output+'.srt.bam')
print cmd
print "Start sort BAM"
print time.strftime("%Y-%m-%d %H:%M:%S")
os.system(cmd)
print "sort BAM end"
print time.strftime('%Y-%m-%d %H:%M:%S')

# remove duplicated reads
cmd = 'samtools rmdup -S %s %s' % (output+".srt.bam",output+".srt.rmdup.bam")
print cmd
print "Start remove duplicated reads"
print time.strftime("%Y-%m-%d %H:%M:%S")
os.system(cmd)
print "remove duplicated reads end"
print time.strftime("%Y-%m-%d %H:%M:%S")

# BAM to BED
cmd = 'bamToBed -i %s > %s' % (output+".srt.rmdup.bam",output+".bed")
print cmd
print "Start BAM to BED conversion"
print time.strftime("%Y-%m-%d %H:%M:%S")
os.system(cmd)
print "BAM to BED end"
print time.strftime('%Y-%m-%d %H:%M:%S')

# remove tmp file
srt_bam = output+'.srt.bam'
srt_bam_rmdup = output+'.srt.rmdup.bam'
os.remove(srt_bam)
os.remove(srt_bam_rmdup)
