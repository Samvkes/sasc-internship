import os

selectionList = open("truvari_selection", "r").readlines()
selectionList = [x.strip() for x in selectionList]
for vcf in selectionList:
    vcfName = os.path.split(vcf)[1]
    vcfName = vcfName.split(".n.d")[0]
    print(vcfName)
    os.system(f"sbatch truvari.sh {vcf} {vcfName}")

print("finished batches")
