#!/bin/bash
# This is a sample script. 

# Read the GDC token from the file
token=$(<gdc-user-token.xyz.txt)

# Define the regions
regions="region=chr1:10001-12464&region=chr1:248943708-248946421&region=chr2:10001-12592&region=chr2:242146750-242148749&region=chr2:242181358-242183529&region=chr3:18323-20322&region=chr3:198233559-198235558&region=chr3:198170705-198176526&region=chr4:10001-12193&region=chr4:190120458-190123120&region=chr5:10001-13806&region=chr5:181476259-181478258&region=chr6:60001-62000&region=chr6:170743979-170745978&region=chr7:10001-12238&region=chr7:159333868-159335972&region=chr8:60001-62000&region=chr8:145076636-145078635&region=chr9:10001-12359&region=chr9:138260981-138262980&region=chr10:14061-16061&region=chr10:133785144-133787421&region=chr11:60001-62000&region=chr11:135074564-135076621&region=chr12:43740-45739&region=chr12:133262872-133265308&region=chr12:10001-12582&region=chr13:18445861-18447860&region=chr13:114342403-114344402&region=chr14:18243524-18245523&region=chr14:106879333-106881349&region=chr15:19794748-19796747&region=chr15:101978766-101981188&region=chr16:10001-12033&region=chr16:90226345-90228344&region=chr17:150208-152207&region=chr17:83245442-83247441&region=chr18:10001-12621&region=chr18:80256343-80259271&region=chr18:80258581-80258646&region=chr19:60001-62000&region=chr19:58605455-58607615&region=chr20:79360-81359&region=chr20:64332167-64334166&region=chr21:8522361-8524360&region=chr21:46697876-46699982&region=chr22:15926017-15927980&region=chr22:50804138-50806137&region=chrX:10001-12033&region=chrX:156028068-156030894&region=chrY:10001-12033&region=chrY:57214588-57217414"

# Read the input TSV file line by line

while IFS=$'\t' read -r UUID FileName DataCategory DataType ProjectID CaseID SampleID SampleType; do
    # Perform the curl request
    curl --header "X-Auth-Token: $token" "https://api.gdc.cancer.gov/slicing/view/$UUID?$regions" --output "${ProjectID}_${CaseID}_${SampleType}.bam"
done < Kidney_TCGA_KICH_curl.tsv
