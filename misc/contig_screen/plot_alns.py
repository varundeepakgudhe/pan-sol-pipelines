import sys
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

sns.set_palette('viridis',3)
plt.rcParams["figure.figsize"] = (20,20)

#Read in the alignment file 
aln_f   = sys.argv[1]
busco_f = sys.argv[2]
busco_no_dups_f = sys.argv[3]

dup_contigs = []
with open(busco_f, "r") as f:
    line = f.readline()
    while line:
        tmp = line.strip().split('\t')
        dup_contigs.append(tmp[0])
        line = f.readline()

no_dup_contigs = []
with open(busco_no_dups_f, "r") as f:
    line = f.readline()
    while line:
        tmp = line.strip().split('\t')
        no_dup_contigs.append(tmp[0])
        line = f.readline()

all_covs  = []
all_lens  = []
dup_covs  = []
dup_lens  = []
ctgs      = []
ctg_names = []
dup_added = []

with open(aln_f, "r") as f:
    line = f.readline()
    while line:
        tmp = line.strip().split('\t')
        good = 0
        if tmp[5].count("ctg") > 0 and tmp[0].count("chr") > 0 and line.count("tp:A:P")>0:
            this_name = tmp[5]
            this_len = int(tmp[6])
            this_cov = int(tmp[9])
            good = 1
        elif tmp[0].count("ctg") > 0 and tmp[5].count("chr") > 0 and line.count("tp:A:P")>0:
            good = 1
            this_name = tmp[0]
            this_len = int(tmp[1])
            this_cov = int(tmp[9])
        if good == 1:
            if this_name in ctg_names: #It has already been reported 
                
                this_idx = ctg_names.index(this_name)
                all_covs[this_idx] += (this_cov/this_len*100)
                if this_name in dup_contigs:
                    dup_idx = dup_added.index(this_name)
                    dup_covs[dup_idx] += (this_cov/this_len*100)
            else:
                
                ctg_names.append(this_name)
                all_covs.append(this_cov/this_len*100)
                all_lens.append(this_len)
                if this_name in dup_contigs:
                    ctgs.append("Only duplicated buscos")
                    dup_covs.append(this_cov/this_len*100)
                    dup_lens.append(this_len)
                    dup_added.append(this_name)
                elif this_name in no_dup_contigs:
                    ctgs.append("Single buscos")
                else:
                    ctgs.append("Others")

        line = f.readline()
d = {"Length": all_lens, "Coverage": all_covs, "Contigs": ctgs, "Name":ctg_names}
df = pd.DataFrame(d)


#tmp_df = df[df["Contigs"]=="Only duplicated buscos"]
#tmp_df_2 = tmp_df[tmp_df["Length"]> ]

tmp = df[df["Contigs"]=="Only duplicated buscos"]#["Name"]
tmp_2 = list(tmp[tmp["Length"]<100000]["Name"])
for t in tmp_2:
    print(t)
tmp_2 = list(tmp[tmp["Coverage"]>80]["Name"])
for t in tmp_2:
    print(t)

df_tmp = df[df["Contigs"]!="Only duplicated buscos"]#df[df["Coverage"]>100]
#print(df_tmp)
df_tmp_2 = df_tmp[df_tmp["Length"]<50000]
#print(df_tmp_2)
tmp = list(df_tmp_2[df_tmp_2["Coverage"]>95]["Name"])

#print(tmp)
for t in tmp:
    print(t)
#print(len(ctg_names))

ax = sns.jointplot(data=df, x="Length", y="Coverage", hue="Contigs", kind="scatter",  height=10)
#h.figure.tight_layout() 
ax.set_axis_labels("Length of contig","% of contig mapping to chromosome",fontsize=16) #, ylabel="% of contig mapping to chromosome")
#fig.ylabel("% of contig mapping to chromosome")
ax.ax_marg_x.set_xlim(0, max(all_lens)+10)
ax.ax_marg_y.set_ylim(0, 101)
#ax.ax_joint.set_xscale('log')
#ax.ax_joint.set_yscale('log')
ax.ax_joint.axvline(x = 50000)
#for a in (ax.ax_joint, ax.ax_marg_x):
#    a.axvline(x = 50000,    # Line on x = 2
#           ymin = 95, # Bottom of the plot
#           ymax = max(df["Coverage"])
#           )
ax.ax_joint.axhline(y = 95,    # Line on x = 2
           xmin = 0, # Bottom of the plot
           xmax = 50000
           )
plt.tight_layout() 
plt.savefig("coverage.vs.length.w.dups.sum.asm20.png")
plt.close()


df_noothers = df[df['Contigs']!="Others"]
ax = sns.jointplot(data=df_noothers, x="Length", y="Coverage", hue="Contigs", kind="scatter", height=10)
ax.set_axis_labels("Length of contig","% of contig mapping to chromosome",fontsize=16) #, ylabel="% of contig mapping to chromosome")
#fig.ylabel("% of contig mapping to chromosome")
ax.ax_marg_x.set_xlim(0, max(all_lens)+10)
ax.ax_marg_y.set_ylim(0, 101)
ax.ax_joint.axvline(x = 50000)
#for a in (ax.ax_joint, ax.ax_marg_x):
#    a.axvline(x = 50000,    # Line on x = 2
#           ymin = 95, # Bottom of the plot
#           ymax = max(df["Coverage"])
#           )
ax.ax_joint.axhline(y = 95,    # Line on x = 2
           xmin = 0, # Bottom of the plot
           xmax = 50000
           )
#ax.ax_joint.set_xscale('log')
#ax.ax_joint.set_yscale('log')
#ax.set_xscale('log') 
plt.tight_layout()
plt.savefig("coverage.vs.length.w.dups.noothers.sum.asm20.png")
plt.close()

ax = sns.jointplot(x=dup_lens, y=dup_covs, kind="scatter", marginal_kws=dict(bins=50), height=10)
ax.set_axis_labels("Length of contig","% of contig mapping to chromosome",fontsize=16)
ax.ax_joint.axvline(x = 50000)
#for a in (ax.ax_joint, ax.ax_marg_x):
#    a.axvline(x = 50000,    # Line on x = 2
#           ymin = 95, # Bottom of the plot
#           ymax = max(df["Coverage"])
#           )
ax.ax_joint.axhline(y = 95,    # Line on x = 2
           xmin = 0, # Bottom of the plot
           xmax = 50000
           )
plt.tight_layout()
plt.savefig("coverage.vs.length.just.dups.sum.asm20.png")
plt.close()


ax = sns.jointplot(x=all_lens, y=all_covs, kind="scatter", marginal_kws=dict(bins=50), height=10)
ax.set_axis_labels("Length of contig","% of contig mapping to chromosome",fontsize=16)
#for a in (ax.ax_joint):
    #a.axvline(x = 50000,    # Line on x = 2
    #       ymin = 95, # Bottom of the plot
    #       ymax = max(df["Coverage"])
    #       )
ax.ax_joint.axhline(y = 95,    # Line on x = 2
           xmin = 0, # Bottom of the plot
           xmax = 50000
           )
#for a in (ax.ax_joint, ax.ax_marg_y):
ax.ax_joint.axvline(x = 50000) #,    # Line on x = 2
           #ymin = 95, # Bottom of the plot
           #ymax = max(df["Coverage"])
           #)
    #ax.ax_joint.set_xscale('log')
#ax.ax_joint.set_yscale('log')
plt.tight_layout()
plt.savefig("coverage.vs.length.all.sum.asm20.png")
plt.close()



#Plot the % of the contig that is aligned to a labeled chr (histogram)
#plt.hist(all_covs, bins=100, alpha=0.7)
#plt.xlabel("Percent of contig matching a chromosome")
#plt.savefig("coverage.hist.png")
#plt.close()
#Plot the % of the contig that is aligned to a labeled chr vs. length of contig 
#plt.scatter(all_lens, all_covs, alpha=0.7)
#plt.xlabel("Length of contig")
#plt.ylabel("% of contig mapping to chromosome")
#plt.savefig("coverage.vs.length.png")
#plt.close()


