#!/bin/bash
# Usage: ./variants_to_txt.sh <input_vcf> <output_txt>
input_vcf=$1
output_txt=$2

BCFTOOLS=/opt/anaconda3/envs/bcftools_1_21_env/bin/bcftools

$BCFTOOLS query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' "$input_vcf" > "$output_txt"