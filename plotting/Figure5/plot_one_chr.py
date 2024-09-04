import sys
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

plt.rcParams["figure.figsize"] = (15,5)
plt.rcParams.update({'font.size': 10})
sns.set_palette("magma")
chr_name = sys.argv[1]
window = int(sys.argv[3])
def make_heatmap(density_f,this_chr):
    values_all   = []
    starts = []
    for dfs in density_f:
        with open(dfs) as f:
            f.readline()
            for line in f:
                line  = line.rstrip().split("\t")
                name  = line[0]
                if name == this_chr:
                    start = int(line[1])-1
                    end   = int(line[2])
                    value = int(line[3])
                    if int(start)/1000000 in starts:
                        this_idx = starts.index(int(start)/1000000)
                        values_all[this_idx] += value
                    else:
                        values_all.append(value)
                        starts.append(int(start)/1000000)
    return values_all, starts
var = sys.argv[2]
samples_to_include = ["bc2072","Saet1371","bc2066","SC103",
        "bc2060","SID104435","bc2063","bc2073","SID104440","Sang8"]
#["bc2074","Saet1371","bc2066",
#        "SID104435","bc2060","bc2063","SID104440","SC103","Sang8"]
#["bc2074","bc2072","Saet1371","bc2066","SC103","SID104440",
#"SID104435","bc2060","bc2073","bc2063","Sang8","Sins1"]
renameme = {"bc2072":"PI441895","Saet1371":"PI441899","bc2066":"PI247828","SC103":" 804750187",
        "bc2060":"PI374695","SID104435":"PI666075","bc2063":"PI666076",
        "bc2073":"PI666078","SID104440":"804750136","Sang8":"Sang8"}
data = {}
for s in samples_to_include:
    files = []
    if var == "SV":
        files.append(s+"_files/"+s+"_sv_ins.density.count.w"+str(window)+".bed")
        files.append(s+"_files/"+s+"_sv_del.density.count.w"+str(window)+".bed")
        files.append(s+"_files/"+s+"_sv_inv.density.count.w"+str(window)+".bed")
    else:
        files.append(s+"_files/"+s+"_"+var+".density.count.bed")
    data[renameme[s]], starts = make_heatmap(files,chr_name)
print(starts)
#sns.set(font="Arial")
df = pd.DataFrame(data, index=starts)
df = df.T
g = sns.heatmap(df, cmap="ocean_r")
g.set_xticklabels(g.get_xticklabels(), rotation = 45, fontsize = 10)
g.set_yticklabels(g.get_yticklabels(), fontsize = 10)
plt.xlabel("Window start position (Mbp)")
#plt.xlim(0,900)
plt.title("SV density across " + chr_name)

#g.axvline([440], ls='--', c='grey')
#g.axvline([460], ls='--', c='grey')
#g.axes.axhline([440,460], ls='--', c='green')
#g.hlines([440, 460], *g.get_xlim())
#plt.tight_layout()
#plt.title(var + " density across " + chr_name)

plt.tight_layout()
plt.savefig(chr_name+"."+var+".heatmap.w"+str(window)+".v3.pdf")
plt.close()

