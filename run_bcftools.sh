#!/bin/bash
# Usage: ./run_bcftools.sh <reference_fasta> <bam_file> <output_vcf>
reference=$1
bam_file=$2
output_vcf=$3

BCFTOOLS=/opt/anaconda3/envs/bcftools_1_21_env/bin/bcftools

$BCFTOOLS mpileup -f "$reference" "$bam_file" | $BCFTOOLS call -mv -Oz -o "$output_vcf"