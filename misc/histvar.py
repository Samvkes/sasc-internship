from cyvcf2 import VCF
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use("Agg")
import seaborn as sns
import numpy as np
import argparse


def isIncorrect(event_range: list, only_short: bool, all_variants: bool) -> str:
    if len(set(event_range)) < 2:
        return "range values should be distinct"
    elif event_range[1] < event_range[0]:
        return "max_value of range should be larger than min_value"
    elif not only_short and not all_variants and event_range[0] > -51 and event_range[1] < 51:
        return "Given range will only show short events from a set that contains none, use -s or -a instead" 
    elif only_short and event_range[0] < -50 and event_range[1] > 50:
        print("Warning: given range will have no effect when only looking at short events")
        return "" 
    else:
        return ""


def readVarWithRange(varfile: str, event_range: list, only_short: bool, all_variants: bool) -> tuple:
    lenList = []
    rest = 0
    restLabel = "<50bp events"
    if all_variants:
        for variant in VCF(varfile):
            reflen = len(variant.REF)
            altlen = len(variant.ALT[0])
            if reflen - altlen > 0 and reflen - altlen <= event_range[1]:
                lenList.append(reflen - altlen)
            elif reflen - altlen < 0 and reflen - altlen >= event_range[0]:
                lenList.append(reflen - altlen)
    elif only_short:
        for variant in VCF(varfile):
            reflen = len(variant.REF)
            altlen = len(variant.ALT[0])
            if abs(reflen - altlen) < 50:
                if reflen - altlen > 0 and reflen - altlen <= event_range[1]:
                    lenList.append(reflen - altlen)
                elif reflen - altlen < 0 and reflen - altlen >= event_range[0]:
                    lenList.append(reflen - altlen)
            else:
                rest+= 1
        restLabel = ">49bp events"
    else:
        for variant in VCF(varfile):
            reflen = len(variant.REF)
            altlen = len(variant.ALT[0])
            if abs(reflen - altlen) > 49:
                if reflen - altlen > 0 and reflen - altlen <= event_range[1]:
                    lenList.append(reflen - altlen)
                elif reflen - altlen < 0 and reflen - altlen >= event_range[0]:
                    lenList.append(reflen - altlen)
            else:
                rest+= 1
    return (lenList, rest, restLabel)


def readVar(varfile: str, only_short: bool, all_variants: bool) -> tuple:
    lenList = []
    rest = 0
    restLabel = "<50bp events"
    if all_variants:
        for variant in VCF(varfile):
            reflen = len(variant.REF)
            altlen = len(variant.ALT[0])
            lenList.append(reflen - altlen)
    elif only_short:
        for variant in VCF(varfile):
            reflen = len(variant.REF)
            altlen = len(variant.ALT[0])
            if abs(reflen - altlen) < 50:
                lenList.append(reflen - altlen)
            else:
                rest+= 1
        restLabel = ">49bp events"
    else:
        for variant in VCF(varfile):
            reflen = len(variant.REF)
            altlen = len(variant.ALT[0])
            if abs(reflen - altlen) > 49:
                lenList.append(reflen - altlen)
            else:
                rest+= 1
    return (lenList, rest, restLabel)


def parseConfig():
    parser = argparse.ArgumentParser(prog="histvar",
                                    description="""
                                    Plots histogram of indel-length of long (>49bp) events in a given vcf. 
                                    A horizontal bar shows the amount of events not otherwise plotted
                                    (the amount of shorter (>49bp) events in the default graph, 
                                    the amount of longer (<50bp) events when -s is supplied, 
                                    and none when -a is supplied)
                                    """)
    parser.add_argument("file")
    parser.add_argument("-n", "--nomarker", action="store_false",
                        help="don't display unplotted-event-number marker")
    parser.add_argument("-i", "--image", action="store", nargs="?", metavar=("NAME"), const="img.png", default="img.png",
                        help="save image (with optional supplied name) instead of displaying")
    parser.add_argument("-b", "--bins", action="store", nargs=1, type=int, default=[100],
                        help="amount of bins")
    parser.add_argument("-r", "--range", action="store", nargs=2, metavar=("MIN", "MAX"), type=int, default=[0,0],
                        help="range of event-lengths to look at, min max (inclusive)")
    parser.add_argument("-l", "--linear", action="store_true",
                        help="show linear y-axis instead of logarithmic")
    variant_types_group = parser.add_mutually_exclusive_group()
    variant_types_group.add_argument("-s", "--short", action="store_true",
                        help="plot histogram of short (<49bp) variants instead")
    variant_types_group.add_argument("-a", "--all", action="store_true",
                        help="plot histogram of all variants instead")
    args = parser.parse_args()
    return args


sns.set_theme()
args = parseConfig()

if args.range != [0,0]:
    if isIncorrect(args.range, args.short, args.all):
        print(isIncorrect(args.range, args.short, args.all))
        exit()
    else:
        lenList, rest, restLabel = readVarWithRange(args.file, args.range, args.short, args.all)
else:
    lenList, rest, restLabel = readVar(args.file, args.short, args.all)

if args.nomarker and not args.all:
    plt.axhline(rest, color=(0.8,0.2,0), alpha=0.7, label=f"amount of {restLabel}")
    plt.legend()

if not args.linear:
    plt.yscale("log")


ar = np.array(lenList)
plt.xlabel("indel Length (bp)")
plt.ylabel("amount of events")
sns.histplot(data=ar, bins=args.bins[0], )
plt.savefig(args.image, dpi=300)
print(f"Saved plot as {args.image}\n"
      f"Amount of plotted events: {len(lenList)} (largest in: {max(lenList)}bp, largest del: {min(lenList)}bp)\n"
      f"Amount of not-plotted events: {rest}")
