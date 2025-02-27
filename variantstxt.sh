# Loop over each .vcf.gz file in the folder
for file in /Users/pshah4374/Documents/Chapter2_Genes/CHOL_vcfs *.vcf.gz
do
    # Extract the base name of the file (without extension) to name the output file
    basename=$(basename "$file" .vcf.gz)
    
    # Run bcftools query on each file and save the output
    bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' "$file" > "${basename}.txt"
done
