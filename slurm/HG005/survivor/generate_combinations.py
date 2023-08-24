import os
import argparse
import itertools

MINIMUM_SIZE = 2


def generate_combinations(vcfListFile: str, minimumSize) -> list:
    vcfList = open(vcfListFile, "r").readlines()
    vcfList = [x.strip() for x in vcfList]
    combinationList = []
    for length in range(minimumSize, len(vcfList)+1):
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
os.system("rm -r -f /exports/sascstudent/samvank/output/HG005/SURVIVOROut/")
os.system("mkdir /exports/sascstudent/samvank/output/HG005/SURVIVOROut/")
combinations = generate_combinations(args.vcfList, MINIMUM_SIZE)
print(combinations)
for combination in combinations:
    combinationName = "-".join(combination)
    fl = open(f"{workFolder}/combinationFiles/{combinationName}", "w")
    print(combinationName)
    toWrite = "" 
    for vcf in combination:
        toWrite += vcf + "\n"
    # toWrite = toWrite.strip("\n")
    fl.write(toWrite)
    fl.close()
    os.system(f"sbatch combine_given.sh {workFolder} {combinationName}")
print("succesfully batched")

