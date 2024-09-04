import sys
import matplotlib.pyplot as plt
import seaborn as sns
import pycircos
import collections

plt.rcParams["figure.figsize"] = (35,35)

colors = {
        "chr1":"#fbf8cc",#"#6b0079ff",
        "chr2":"#fde4cf",#"#9e0059ff",
        "chr3":"#ffcfd2",#"#ce0056ff",
        "chr4":"#f1c0e8",#"#ff0054ff",
        "chr5":"#cfbaf0",#"#ff5e2aff",
        "chr6":"#a3c4f3",#"#ffbd00ff",
        "chr7":"#90dbf4",#"#7fbe59ff",
        "chr8":"#8eecf5",#"#00bfb3ff",
        "chr9":"#98f5e1",#"#00a7b0ff",
        "chr10":"#b9fbc0",#"#0091adff",
        "chr11":"#b0f2b4",#"#2179cdff",
        "chr12":"#74c69d"
        }

Garc    = pycircos.Garc
Gcircle = pycircos.Gcircle

circle = Gcircle(figsize=(55,55))
l_sum = 0
with open("general.saet3.txt") as f:
    f.readline()
    for line in f:
        line   = line.rstrip().split(",")
        name   = line[0]
        #print(name)
        length = int(line[-1])
        arc    = Garc(arc_id=name, size=length, interspace=-2, raxis_range=(900,935), labelposition=50, label_visible=True, labelsize=75, facecolor=colors[name])
        circle.add_garc(arc)
        l_sum += length
#arc    = Garc(arc_id="highlight", size=l_sum, interspace=0, raxis_range=(285,385), label_visible=False)
#circle.add_garc(arc)
circle.set_garcs(270,88) 
for arc_id in circle.garc_dict:
    circle.tickplot(arc_id, raxis_range=(945,935), tickinterval=20000000, ticklabels=None)

arc    = Garc(arc_id="highlight", size=l_sum, interspace=-2, raxis_range=(285,375), label_visible=False)
circle.add_garc(arc)
#circle.tickplot("highlight", raxis_range=(935,945), tickinterval=20000000, ticklabels=None)

#heatmap
def make_heatmap(loc1,loc2,density_f):
    values_all   = [] 
    arcdata_dict = collections.defaultdict(dict)
    for df in density_f:
        with open(df) as f:
            f.readline()
            for line in f:
                line  = line.rstrip().split("\t")
                name  = line[0]
                if name in colors.keys():
                         
                    start = int(line[1])-1
                    end   = int(line[2]) 
                    width = end-start 
                    if name not in arcdata_dict:
                        arcdata_dict[name]["positions"] = []
                        arcdata_dict[name]["widths"]    = [] 
                        arcdata_dict[name]["values"]    = [] 
                    if start in arcdata_dict[name]["positions"]: 
                        this_idx = arcdata_dict[name]["positions"].index(start)
                        arcdata_dict[name]["values"][this_idx] += float(line[-1])
                        values_all[this_idx] += float(line[-1])
                    else:
                        arcdata_dict[name]["positions"].append(start) 
                        arcdata_dict[name]["widths"].append(width)
                        arcdata_dict[name]["values"].append(float(line[-1]))
                        values_all.append(float(line[-1]))

    vmin, vmax = min(values_all), max(values_all) 
    for key in arcdata_dict:
        print(key)
        circle.heatmap(key, data=arcdata_dict[key]["values"], positions=arcdata_dict[key]["positions"],
                   width=arcdata_dict[key]["widths"], 
                   raxis_range=[loc1,loc2], 
                   vmin=vmin, vmax=vmax, 
                   #labelsize=10,
                   cmap=plt.cm.ocean_r)

sample = sys.argv[1]
samples_to_include = ["bc2072","Saet1371","bc2066","SC103",
        "bc2060","SID104435","bc2063","bc2073","SID104440","Sang8"]
        #"SID104440","SID104435","bc2060","bc2063","SC103","Sang8","Sins1"]
circ_z1 = 880
circ_z2 = 835
for s in samples_to_include:
    files = []
    if sample == "SV":
        files.append(s+"_files/"+s+"_sv_ins.density.count.bed")
        files.append(s+"_files/"+s+"_sv_del.density.count.bed")
        files.append(s+"_files/"+s+"_sv_inv.density.count.bed")
    else:
        files.append(s+"_files/"+s+"_"+sample+".density.count.bed")
    make_heatmap(circ_z2,circ_z1,files)
    print(s)
    print(str(circ_z1) + "\t" + str(circ_z2))
    print()
    circ_z1 -= 55
    circ_z2 -= 55
#s = "Sang8"
#make_heatmap(325,365,s+"_files/"+s+"_"+sample+".density.bed")
#s = "Sins1"
#make_heatmap(265,305,s+"_files/"+s+"_"+sample+".density.bed")

#make_heatmap(835,875,"bc2060_files/bc2060_"+sample+".density.bed")#"Saet3_files/LTR_retrotransposon.density.bed")#helitron.density.bed")
#make_heatmap(775,815,"bc2066_files/bc2066_"+sample+".density.bed")#"Saet3_files/Gypsy_LTR_retrotransposon.density.bed")
#make_heatmap(715,755,"bc2073_files/bc2073_"+sample+".density.bed")#"Saet3_files/Mutator_TIR_transposon.density.bed")
#make_heatmap(655,695,"bc2063_files/bc2063_"+sample+".density.bed")
#make_heatmap(595,635,"bc2072_files/bc2072_"+sample+".density.bed")
#make_heatmap(535,575,"bc2074_files/bc2074_"+sample+".density.bed")

#make_heatmap(475,515,"SC103_files/SC103_"+sample+".density.bed")
#make_heatmap(415,455,"Saet1371_files/Saet1371_"+sample+".density.bed")
#make_heatmap(355,395,"SID104440_files/SID104440_"+sample+".density.bed")
#make_heatmap(295,335,"SID104435_files/SID104435_"+sample+".density.bed")
#make_heatmap(655,695,)#"Saet3_files/helitron.density.bed")
#make_heatmap(595,635,)#"Saet3_files/CACTA_TIR_transposon.density.bed")#Copia_LTR_retrotransposon.density.bed")
#make_heatmap(535,575,)#"Saet3_files/Copia_LTR_retrotransposon.density.bed")

circle.figure.savefig("circ."+sample+".180.pdf")


