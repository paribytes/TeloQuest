import pandas as pd
import sys

input_files = sys.argv[1:-1]
output_csv = sys.argv[-1]

genotype_map = {"0/0": 0, "0/1": 1, "1/1": 2, "./.": None}
summary_list = []

for file_path in input_files:
    filename = file_path.split("/")[-1]
    df = pd.read_csv(file_path, sep="\t", header=None, names=["Chromosome", "Position", "Ref", "Alt", "Genotype"])
    df["Genotype"] = df["Genotype"].map(genotype_map)

    total_heterozygous = (df["Genotype"] == 1).sum()
    total_homozygous_alternate = (df["Genotype"] == 2).sum()
    total_mutations = total_heterozygous + total_homozygous_alternate

    summary_list.append({
        "File": filename,
        "Total_Heterozygous_Mutations": total_heterozygous,
        "Total_Homozygous_Alternate_Mutations": total_homozygous_alternate,
        "Total_Mutations": total_mutations
    })

summary_df = pd.DataFrame(summary_list)
summary_df.to_csv(output_csv, index=False)
print(summary_df)
