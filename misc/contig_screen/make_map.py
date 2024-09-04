import sys

in_fai_file = sys.argv[1]
in_remove_f = sys.argv[2]

fai = []
with open(in_fai_file, "r") as f:
    line = f.readline()
    while line:
        fai.append(line.strip().split('\t')[0])
        line = f.readline()

new_sample_names = []
removed = []
with open(in_remove_f, "r") as f:
    line = f.readline()
    while line:
        removed.append(line.strip())
        line = f.readline()

old_ctg_cntr = 0
new_ctg_cntr = 0
for f in fai:
    if f.count("chr") > 0:
        print(f + "\t"+ f)
    elif f.count("scf") > 0: 
        print(f + "\t" + f)
    elif f in removed:
        print(f + "\t")
    else:
        new_name = "ctg"
        #ctg00000075
        num_zeros = 8 - len(str(new_ctg_cntr))
        for i in range(0,num_zeros):
            new_name += "0"
        new_name += str(new_ctg_cntr)
        new_ctg_cntr += 1
        print(f + "\t" +  new_name)
