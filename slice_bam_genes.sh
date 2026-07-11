#!/bin/bash
# Usage: ./slice_bam_genes.sh <UUID> <output_bam>

token=$(<gdc-user-token.txt)

regions="region=chr1:113905326-113914086&region=chr4:163128669-163166890&region=chr5:1253167-1295068&region=chr5:151771954-151812785&region=chr6:57090188-57170305&region=chr7:124822386-124929825&region=chr8:73008864-73048123&region=chr10:103877569-103918184&region=chr11:108223067-108369102&region=chr14:24239643-24242623&region=chr16:14435701-14630260&region=chr17:8224815-8248056&region=chr17:61679139-61863528&region=chr20:36890229-36951708&region=chr20:63658312-63696245"

UUID=$1
OUTPUT=$2

curl --header "X-Auth-Token: $token" "https://api.gdc.cancer.gov/slicing/view/${UUID}?${regions}" --output "$OUTPUT"
