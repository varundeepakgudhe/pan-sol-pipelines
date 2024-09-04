import sys

in_file = sys.argv[1]
in_fai = sys.argv[2]

bins = int(sys.argv[3])

data = {}
with open(in_fai, "r") as f:
    line = f.readline()
    while line:
        tmp = line.strip().split('\t')
        chrom = tmp[0]
        chr_len = int(tmp[1])
        data[chrom] = []
        cntr = 0
        while cntr < chr_len:
            data[chrom].append(0)
            cntr += bins
        line = f.readline()


with open(in_file, "r") as f:
    line = f.readline()
    while line:
        tmp = line.strip().split('\t')
        chrom = tmp[0]
        start = int(tmp[1])
        stop = int(tmp[2])
        #for i in range(start,stop):

        index = int(start/bins)
        data[chrom][index] += 1
        line = f.readline()

for d in data.keys():
    cntr = 0
    for b in data[d]:
        print(d+"\t"+str(cntr+1)+"\t"+str(cntr+bins) +"\t"+str(b))
        cntr += bins

