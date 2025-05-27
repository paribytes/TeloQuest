#!/bin/bash


# Read the GDC token from file
token=$(<gdc-user-token.2024-05-20T20_39_17.254Z.txt)

# Define the coordinates of the genes you want to look at
regions="region=chr1:113905326-113914086&region=chr4:163128669-163166890&region=chr5:1253167-1295068&region=chr5:151771954-151812785&region=chr6:57090188-57170305&region=chr7:124822386-124929825&region=chr8:73008864-73048123&region=chr10:103877569-103918184&region=chr11:108223067-108369102&region=chr14:24239643-24242623&region=chr16:14435701-14630260&region=chr17:8224815-8248056&region=chr17:61679139-61863528&region=chr20:36890229-36951708&region=chr20:63658312-63696245"

# Read the input TSV file line by line

while IFS=$'\t' read -r UUID FileName DataCategory DataType ProjectID CaseID SampleID SampleType; do
    # Perform the curl request
    curl --header "X-Auth-Token: $token" "https://api.gdc.cancer.gov/slicing/view/$UUID?$regions" --output "${ProjectID}_${CaseID}_${SampleType}.bam"
done < Brain_TCGA_GBM_curl.tsv
