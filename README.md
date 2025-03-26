# TeloQuest

## TeloQuest is a machine learning pipeline on a mission to uncover tumor status by analyzing telomere content variation.

This repository contains scripts and instructions for downloading BAM files for all TCGA projects from the GDC data portal, analyzing telomere content using qmotif, saving output files with telomere data, extracting variant information for 15 telomere related genes and building a machine learning model using all these features. Each step in the pipeline is outlined below, along with requirements and execution instructions.

We utilized the [GDC Data Portal](https://portal.gdc.cancer.gov/) to access the BAM files for all the TCGA projects. 

## Table of Contents
* Requirements
* File Descriptions
* Usage
* Detailed Steps
* Outputs
* Contact

## Requirements
To run this pipeline, you'll need:
1. **Controlled-data Access Authorization**: Follow the steps on [GDC](https://gdc.cancer.gov/access-data/obtaining-access-controlled-data) to get access to the controlled data (aka the BAM files).

2. **GDC Download Token**: Required to download the controlled access data. To download controlled-access data, ensure that the authentication token is stored in the same folder as the scripts. The token is valid for **30 days** from the date of download and can only be used once. For instance, if you use a token to download BAM files for the **TCGA-ACC** project, you will need a new token to download BAM files for the **TCGA-GBM** project. Additionally, you can only download files for **one project at a time**—requesting a new token will immediately invalidate the previous one. However, if multiple team members have access to the portal, each person can generate and use their own individual tokens at the same time.

3. **samtools**: Required to generate BAM Index (BAI) files for the corresponding BAM files 
4. **qmotif**: Download and install qmotif ([Documentation here](https://adamajava.readthedocs.io/en/latest/qmotif/qmotif_1_0/)).
5. **Java**: Required to run qmotif
6. **bcftools**: Required to obtain variants 
7. **Anaconda for Jupyter notebook**: Required to build the machine learning model

*  **Additional things to prepare:** 
*  If you're only interested in certain chromosomal coordinates from the BAM file, get the specific coordinates using [UCSC's Genome Browser](https://genome.ucsc.edu/cgi-bin/hgGateway). TCGA data on the GDC Portal has been harmonized and mapped to the GRCh38 human reference genome build, so please be aware of this when you get the coordinates and ensure they are from the correct build. 
* Refer to sample script `Kidney_TCGA_KICH_loop.sh` which utilizes the BAM files for UUIDs mentioned in the TSV file - `Kidney_TCGA_KICH_curl.tsv`
* Generate a similar TSV file using "Cohort Builder" on the GDC Data Portal.
* Reference Genome FASTA (GRCh38.d1.vd1.fa) and FASTA index files (GRCh38.d1.vd1.fa.fai) were obtained from [NCI's website](https://gdc.cancer.gov/about-data/gdc-data-processing/gdc-reference-files) 
* More information on BAM slicing using GDC Data Portal is available [here](https://docs.gdc.cancer.gov/Data_Portal/Users_Guide/BAMslicing/)


## File Descriptions
* **`Kidney_TCGA_KICH_curl.tsv`**: TSV file that contains all the UUIDs for the project you want the BAM files for. 
* **`Kidney_TCGA_KICH_loop.sh`**: Bash script that performs a curl request and slices the BAM files according to the genomic regions provided.
* **`bamindex.sh`**: Bash script that uses samtools to generate BAI files for the corresponding BAM files
* **`Kidney_TCGA_KICH.py`**: Python script to run qmotif on BAM files to analyze telomere content.





* **Note**: The GDC Portal only lets you download BAM files for one project at a time. If you download two tokens at a time, it will automatically outdate/expire the second last token without even being used. Also, once you download the files with one token, that token will expire. So, every time you download something new you'll have to obtain a new token. 

## Usage
## Sequence of Execution
To use the pipeline, run the scripts in the following order:
1. `Kidney_TCGA_KICH_loop.sh` (requires: `Kidney_TCGA_KICH_curl.tsv`)
2. `bamindex.sh` (requires: BAM files, generates: BAI files)
3. `Kidney_TCGA_KICH.py` (requires: BAM and BAI files, generates: `log.txt` and `output.txt` files)
4. 



* **Download Recommendations** : For optimal performance when downloading these files, we recommend using a Linux-based system or macOS. Due to the large file sizes, these operating systems tend to handle extensive downloads more reliably and efficiently than some alternatives. Additionally, we suggest ensuring a stable internet connection to minimize interruptions during the download process.

* **Note** : When working with long-running processes, such as data analysis scripts or large data transfers, it’s often helpful to use tools like `tmux` and `nohup` to keep the process running even if your session disconnects. Documentation on [tmux](https://github.com/tmux/tmux/wiki) and [nohup](https://phoenixnap.com/kb/linux-nohup) available here.

## Detailed Steps
1. **Download BAM and BAI files**
* Run `download_files.sh` to download the BAM and BAI files from NCBI’s 1000 Genomes Project server. Make sure to:
* Include URLs for BAM and BAI files in `files_list.txt` and that both `download_files.sh` and `files_list.txt` are in the same folder.

```
chmod +x download_files.sh
```

```
./download_files.sh
```
**OR**

```
bash download_files.sh
```

2. **Run qmotif with runqmotif.py**
* Before running runqmotif.py, ensure qmotif is installed, and the path to qmotif and your BAM and BAI input files is set.

```
python3 runqmotif.py
```

3. **Parse qmotif Log Files**
* Use `stage2.py` to parse log files created by `runqmotif.py`. This script will output telomere read counts for each chromosome in a file named `{sequence_name}_stage2_coverage.txt`.

```
python3 stage2.py
```

4. **Generate Chromosome-Level Tally of Telomeric reads**
* Run `realcoverage.sh` to tally telomeric reads for each chromosome. This script uses the `chrnames` file, so make sure it’s in the same folder. 
* **Note** : The `chrnames` file only has chromosome numbers for autosomes, sex chromosomes are not included.

```
bash realcoverage.sh
```

5. **Extract Scaled Telomeric Reads for all the samples**
*  Run `scaledgenomic.sh` file to extract scaled telomeric reads data from output files created by `runqmotif.py`. This generates a file named `ScaledGenomicOutput.txt`.

```
bash scaledgenomic.sh
```

## Outputs

* `{sequence_name}_stage2_coverage.txt`: Chromosome-specific telomeric read counts (output of `stage2.py`)
* `stage2coverage`: Combined telomeric read counts for each chromosome across all sequences (output of `realcoverage.sh`)
* `ScaledGenomicOutput.txt`: Scaled telomeric reads for all the sequences
* `output_coverage_filenames`: This file lists all files ending with `_coverage.txt`(output of `realcoverage.sh`)
*  Example output files generated by the **qmotif** tool are included in the `supplementary_data` directory. These files serve as reference outputs to understand the results produced by the qmotif analysis process.


## Contact
* If you’d like to discuss this project or get in touch for other inquiries, please email me at priyanshishah213@gmail.com or connect with me on [LinkedIn](https://www.linkedin.com/in/priyanshi-p-shah/).
