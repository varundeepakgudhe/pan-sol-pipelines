import sys
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
import matplotlib.colors as mc
from matplotlib.cm import ScalarMappable
from matplotlib.colors import ListedColormap
import matplotlib
plt.rcParams["figure.figsize"] = (10,3)
plt.rcParams.update({'font.size': 10})
sns.set_palette("magma")
#chr_name = sys.argv[1]
window = int(sys.argv[2])
chrs = {}
def make_heatmap(density_f,s):
    values_all   = []
    starts = []
    chroms = []
    samples = []
    full_names = []
    for dfs in density_f:
        #print(dfs)
        with open(dfs) as f:
            line = f.readline()
            #for line in f:
            while line:
                tmp = line.rstrip().split("\t")
                #line  = line.rstrip().split("\t")
                name  = tmp[0]
                if name.count("chr") > 0 and name.count("chrM_") == 0 and name.count("chrC_") == 0:
                    #print(name)
                    if name not in chrs.keys():
                        chrs[name] = len(values_all)
                    start = int(tmp[1])-1
                    end   = int(tmp[2])
                    value = int(tmp[3])
                    this_name = name+str(int(start)/1000000)
                    if this_name in full_names:
                        #print(this_name)
                        #print(full_names)
                        #print(full_names.index(this_name))
                        #print(starts)
                        this_idx = int(full_names.index(this_name)/10)
                        #print(this_idx)
                        #this_idx = starts.index(int(start)/1000000)
                        values_all[this_idx] += value

                    else:
                        values_all.append(value)
                        starts.append(int(start)/1000000)
                        samples.append(s)
                        chroms.append(name)
                        full_names.append(this_name)
                        full_names.append(name+str((int(start)+window)/1000000))
                        full_names.append(name+str((int(start)+(window*2))/1000000))
                        full_names.append(name+str((int(start)+(window*3))/1000000))
                        full_names.append(name+str((int(start)+(window*4))/1000000))
                        full_names.append(name+str((int(start)+(window*5))/1000000))
                        full_names.append(name+str((int(start)+(window*6))/1000000))
                        full_names.append(name+str((int(start)+(window*7))/1000000))
                        full_names.append(name+str((int(start)+(window*8))/1000000))
                        full_names.append(name+str((int(start)+(window*9))/1000000))
                line = f.readline()
    #print(chroms)
    return samples, values_all, starts, chroms
var = sys.argv[1]
samples_to_include = ["Sang8","SID104440","bc2073","bc2063","SID104435","bc2060",
        "SC103","bc2066","Saet1371" ,"bc2072"]

    #["bc2072" ,"Saet1371" ,"bc2066","SC103",
    #    "bc2060","SID104435","bc2063","bc2073","SID104440","Sang8"]
#["bc2074","Saet1371","bc2066",
#        "SID104435","bc2060","bc2063","SID104440","SC103","Sang8"]
#["bc2074","bc2072","Saet1371","bc2066","SC103","SID104440",
#"SID104435","bc2060","bc2073","bc2063","Sang8","Sins1"]
data = {}
all_samples, all_values, all_starts, all_chroms = [], [], [], []
for s in samples_to_include:
    files = []
    if var == "SV":
        files.append(s+"_files/"+s+"_sv_ins.density.count.w"+str(window)+".bed")
        files.append(s+"_files/"+s+"_sv_del.density.count.w"+str(window)+".bed")
        files.append(s+"_files/"+s+"_sv_inv.density.count.w"+str(window)+".bed")
    else:
        files.append(s+"_files/"+s+"_"+var+".density.count.bed")
    
    samples, values, starts, chroms = make_heatmap(files,s)
    for i in range(0,len(samples)):
        all_samples.append(samples[i])
        all_values.append(values[i])
        all_starts.append(starts[i])
        all_chroms.append(chroms[i])

d = {"Sample":all_samples,"Position":all_starts,"Value":all_values,"Chrom":all_chroms}
df = pd.DataFrame(d)
print(df)
fig, axes = plt.subplots(1, 1, figsize=(24, 10))
Cmap = matplotlib.colors.LinearSegmentedColormap.from_list("", ["#edf2fb","#62b6cb","#0081a7","#390099","#0b132b"])
def single_plot(ax,chr_name):
    ncols = int(len(df["Position"])/len(samples_to_include))
    nrows = len(samples_to_include)
    Z = np.array(df["Value"].tolist()).reshape(nrows, ncols) #np.arange(df[df["Chrom"]=="chr1"]["Value"].tolist()).reshape(nrows, ncols)
    y = np.arange(len(samples_to_include) + 1)
    x = np.arange(ncols + 1)
    g = ax.pcolormesh(x, y, Z, shading='flat', vmin=Z.min(), vmax=Z.max(),cmap=Cmap,linewidth=0)
    #ax.pcolormesh(df[df["Chrom"]=="chr1"]["Position"],df[df["Chrom"]=="chr1"]["Sample"],df[df["Chrom"]=="chr1"]["Value"])
    ax.set_frame_on(False)
    return g

g = single_plot(axes,"chr1")
#And now we go through and add the chromosome breakpoints 
for c in chrs.keys():
    axes.axvline(x=chrs[c],color='white',lw=8)
for i in range(0,len(samples_to_include)):
    axes.axhline(y=i,color='white',lw=1)
axes.set_yticklabels(samples_to_include)
fig.colorbar(g)
#single_plot(axes[1],"chr2")
#single_plot(axes[2],"chr3")
#single_plot(axes[3],"chr4")
#single_plot(axes[4],"chr5")
#single_plot(axes[5],"chr6")
#single_plot(axes[6],"chr7")
#single_plot(axes[7],"chr8")
#single_plot(axes[8],"chr9")
#single_plot(axes[9],"chr10")
#single_plot(axes[10],"chr11")
#single_plot(axes[11],"chr12")
plt.savefig("linear."+var+".heatmap.w"+str(window)+".v3.pdf")
plt.close()

