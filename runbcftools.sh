#!/bin/bash

#export PATH=$PATH:/opt/anaconda3/envs/samtools/bin/bcftools
#export PATH=$PATH:/Users/pshah4374/bcftools

# Define the path to the reference genome
reference="/Users/pshah4374/Documents/Chapter2_Genes/ReferenceGenome/GRCh38.d1.vd1.fa"

# Define the directory containing the BAM files
bam_dir="/Users/pshah4374/Documents/Chapter2_Genes"

# Define the output directory for VCF files
output_dir="/Users/pshah4374/Documents/Chapter2_Genes/output_TCGA_CHOL_vcfs"
mkdir -p "$output_dir"  # Create output directory if it doesn't exist

# Define the path to bcftools
#bcftools_path="/Users/pshah4374/bcftools"

# Loop over each BAM file in the specified directory
for bam_file in "$bam_dir"/*.bam; do
    # Extract the base name of the BAM file (removes directory path and .bam extension)
    base_name=$(basename "$bam_file" .bam)
    
    # Define the output VCF file name
    output_vcf="${output_dir}/${base_name}_variants.vcf.gz"
    
    # Run bcftools mpileup and call for each BAM file
    bcftools mpileup -f "$reference" "$bam_file" | bcftools call -mv -Oz -o "$output_vcf"
    
    # Print message indicating completion for each file
    echo "Processed $bam_file and saved output to $output_vcf"
done
