import upsetplot
import os
import json
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime

IMGDIR = "/exports/sascstudent/samvank/images"
TRUVARIDIR = "/exports/sascstudent/samvank/output/HG002/truvariOut"

os.chdir(TRUVARIDIR)
dirs = os.listdir(os.curdir)
dirs.sort(key=lambda dir: len(dir))
inputData = [[],[],[],[],[]]
# dirs = os.listdir(TRUVARIDIR)
for file in dirs:
    fileModified = file.rstrip("_merged").replace(".vcf", "").split("-")
    summary = json.load(open(f"{file}/summary.json"))
    inputData[0].append(fileModified)
    inputData[1].append(summary["precision"])
    inputData[2].append(summary["recall"])
    inputData[3].append(summary["f1"])
    inputData[4].append(str(summary["comp cnt"]))


rowSet = set()
for combination in inputData[0]:
    for item in combination:
        rowSet.add(item)
amountOfRows = len(rowSet)

attributes = ("precision", "recall")
x = np.arange(len(inputData[0]))
width = 0.2
multiplier = 0
fig, ax = plt.subplots(layout="constrained")
for i in range(2):
    offset = width * multiplier
    rects = ax.bar(x + offset, inputData[i+1], width, label = attributes[i])
    # ax.bar_label(rects, padding=3)
    multiplier += 1
name =  IMGDIR + "/1"
fig.sc(5)
plt.savefig(name, dpi=300)

# precision_plot = upsetplot.from_memberships(inputData[0], data=inputData[1])
# upsetplot.plot(precision_plot, facecolor="blue",sort_by="input", sort_categories_by="input")
# name =  IMGDIR + "/1"
# plt.ylabel("precision-score")
# plt.savefig(name, dpi=300)


# recall_plot = upsetplot.from_memberships(inputData[0], data=inputData[2])
# upsetplot.plot(recall_plot, facecolor="red", sort_by="input", sort_categories_by="input")
# name =  IMGDIR + "/2"
# plt.ylabel("recall-score")
# plt.savefig(name, dpi=300)


f1_plot = upsetplot.from_memberships(inputData[0], data=inputData[3])
upsetplot.plot(f1_plot, sort_by="input", sort_categories_by="input")
name =  IMGDIR + "/2"
plt.ylabel("f1-score")
plt.savefig(name, dpi=300)


images = [Image.open(x) for x in [f"{IMGDIR}/1.png", f"{IMGDIR}/2.png"]]

# Crop the graphs at the top and bottom, to remove the redundant upset-plot stuff from the upper graphs
# IMPORTANT: We're cropping the intersection graphs here. If the datapoints are not sorted by input...
# ...these bars might be in different orders and you won't even be able to tell. 
# '- (amountOfRows*140)' is pretty ugly: one row of the intersection graph is about 140 pixels high at 300dpi
# So we're calculating how much to crop from the height, but this only works at the current dpi. 
for i in range(len(images)):
    if i < len(images)-1:
        pass
        # images[i] = images[i].crop((0,150,images[i].size[0], images[i].size[1]))
    else:
        images[i] = images[i].crop((0,150,images[i].size[0], images[i].size[1]))

widths, heights = zip(*(i.size for i in images))

max_width = max(widths)
total_height = sum(heights)

new_im = Image.new(f'RGB', (max_width, total_height), color=(255,255,255))

y_offset = 0
for im in images:
    x_offset = max_width - im.size[0]
    new_im.paste(im, (x_offset, y_offset))
    y_offset += im.size[1]

now = datetime.now()
filename = "upsetplot"
name =  IMGDIR + "/" + filename + ".png"
# name =  IMGDIR + "/" + filename +  now.strftime("_%m-%d_%H:%M") + ".png"
new_im.save(name)
# os.system(f"rm {IMGDIR}/1.png")
os.system(f"rm {IMGDIR}/2.png")
# os.system(f"rm {IMGDIR}/3.png")