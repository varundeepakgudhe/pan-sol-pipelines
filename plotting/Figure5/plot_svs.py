import sys
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

plt.rcParams["figure.figsize"] = (35,25)
plt.rcParams.update({'font.size': 30})
sns.set_palette("viridis")

in_file = sys.argv[1]
samples = []
snv_snv, indel_ins, indel_del, sv_ins, sv_del, sv_inv = [], [], [], [], [], [],
good_samples = ["bc2063", "bc2060","bc2066","bc2072","bc2073","bc2074","SID104440","SID104435","Sang8","Sins1"]
with open(in_file, "r") as f:
    line = f.readline()
    while line:
        tmp = line.strip().split(":")
        if tmp[0]:
            samples.append(tmp[0])
            tmp2 = tmp[1].split(",")
            snv_snv.append(int(tmp2[0]))
            indel_ins.append(int(tmp2[1]))
            indel_del.append(int(tmp2[2]))
            sv_ins.append(int(tmp2[3]))
            sv_del.append(int(tmp2[4]))
            sv_inv.append(int(tmp2[5]))
        
        line = f.readline()

d = {"Sample":samples, #"Snv": snv_snv, 
        "indel_ins": indel_ins, "indel_del": indel_del, 
        "sv_ins":sv_ins, "sv_del":sv_del, "sv_inv":sv_inv}
df = pd.DataFrame(d)

df.set_index("Sample", inplace = True)
df_sorted = df.sort_values('sv_del')
df_sorted.plot.bar(stacked=True)
#plt.yscale('log')
plt.ylabel('Number of variants')
plt.xticks(rotation=45)
plt.savefig("variant_count.no.snvs.linear.png")

plt.close()

