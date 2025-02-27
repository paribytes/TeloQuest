import pandas as pd
import os

# Path to the folder containing your TXT files
folder_path = "/Users/pshah4374/Documents/Chapter2_Genes/CHOL_vcfs"

# List to store summary statistics for each file
summary_list = []

# Loop through each TXT file in the folder
for filename in os.listdir(folder_path):
    if filename.endswith(".txt"):
        # Full path to the file
        file_path = os.path.join(folder_path, filename)

        # Load the file with specified column names
        df = pd.read_csv(file_path, sep="\t", header=None, names=["Chromosome", "Position", "Ref", "Alt", "Genotype"])

        # Define the mapping for genotype encoding
        genotype_map = {"0/0": 0, "0/1": 1, "1/1": 2, "./.": None}  # None for missing data

        # Apply the encoding
        df["Genotype"] = df["Genotype"].map(genotype_map)

        # Calculate summary statistics
        total_heterozygous = (df["Genotype"] == 1).sum()
        total_homozygous_alternate = (df["Genotype"] == 2).sum()
        total_mutations = total_heterozygous + total_homozygous_alternate

        # Append results to summary list
        summary_list.append({
            "File": filename,
            "Total_Heterozygous_Mutations": total_heterozygous,
            "Total_Homozygous_Alternate_Mutations": total_homozygous_alternate,
            "Total_Mutations": total_mutations
        })

# Convert summary list to a DataFrame
summary_df = pd.DataFrame(summary_list)

# Save the summary to a CSV file
summary_df.to_csv("CHOL_mutation_summary.csv", index=False)

# Display the summary
print(summary_df)
