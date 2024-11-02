#!/bin/bash
# Assuming all BAM files are located in the same directory
bam_dir="/home/priyanshi/Documents/TCGA_data/Kidney_TCGA_KICH_BAM"
output_dir="/home/priyanshi/Documents/TCGA_data/Kidney_TCGA_KICH_BAM"
# Initialize an empty array to store the names of generated BAI files
bai_files=()
# Iterate over each BAM file in the directory
for bam_file in "$bam_dir"/*.bam; do
    # Extract file name without extension
    filename=$(basename "$bam_file" .bam)
    # Generate BAI file
    samtools index "$bam_file" "${output_dir}/${filename}.bai"
    # Add the name of the generated BAI file to the array
    bai_files+=("${filename}.bai")
done
# Print the names of all generated BAI files
echo "Generated BAI files:"
for bai_file in "${bai_files[@]}"; do
    echo "\"$bai_file\","
done
