import os
import argparse
import itertools

def generate_combinations(vcfListFile: str) -> list:
    vcfList = open(vcfListFile, "r").readlines()
    vcfList = [x.strip() for x in vcfList]
    combinationList = []
    for length in range(3, len(vcfList)+1):
        combinationList.extend(itertools.combinations(vcfList, length))
    return combinationList


def parseConfig():
    parser = argparse.ArgumentParser(prog="genCom",
                                    description="""
                                    Generate all possible combinations of a given list of vcf-files
                                    (Obviously excluding 0- or 1-length combinations)
                                    """)
    parser.add_argument("vcfList")
    args = parser.parse_args()
    return args


args = parseConfig()
workFolder = os.path.split(args.vcfList)[0]
os.system(f"rm -r {workFolder}/combinationFiles")
os.mkdir(f"{workFolder}/combinationFiles")
os.system("rm -r -f /exports/sascstudent/samvank/output/HG002/SURVIVOROut/")
os.system("mkdir /exports/sascstudent/samvank/output/HG002/SURVIVOROut/")
combinations = generate_combinations(args.vcfList)
print(combinations)
for combination in combinations:
    combinationName = "-".join(combination)
    fl = open(f"{workFolder}/combinationFiles/{combinationName}", "w")
    print(combinationName)
    toWrite = "" 
    for vcf in combination:
        toWrite += vcf + "\n"
    fl.write(toWrite.strip("\n"))
    fl.close()
    os.system(f"sbatch combine_given.sh {workFolder} {combinationName}")
print("succesfully batched")

