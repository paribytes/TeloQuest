# TeloQuest

## TeloQuest is a machine learning pipeline on a mission to uncover tumor status by analyzing telomere content variation!

* This repository contains scripts and instructions for downloading BAM files for all TCGA projects from the GDC data portal, analyzing telomere content using qmotif, saving output files with telomere data, extracting variant information for 15 telomere related genes and building a machine learning model using all these features. 
* Each step in the pipeline is outlined below, along with requirements and execution instructions.

We utilized the [GDC Data Portal](https://portal.gdc.cancer.gov/) to access the BAM files for all the TCGA projects. 

## Table of Contents
* Requirements
* Additional Things to Prepare
* File Descriptions
* Usage
* Detailed Steps
* Outputs
* Contact

## Requirements
To run this pipeline, you'll need:
1. **Controlled-data Access Authorization**: Follow the steps on [GDC](https://gdc.cancer.gov/access-data/obtaining-access-controlled-data) to get access to the controlled data (aka the BAM files).

2. **GDC Download Token**: The token is required to download the controlled access data. To download controlled-access data, ensure that the authentication token is stored in the same folder as the scripts. The token is valid for **30 days** from the date of download and can only be used once. For instance, if you use a token to download BAM files for the **TCGA-ACC** project, you will need a new token to download BAM files for the **TCGA-GBM** project. Additionally, you can only download controlled-access files for **one project at a time**—requesting a new token will immediately invalidate the previous one. However, if multiple team members have access to the portal, each person can generate and use their own individual tokens at the same time. **Please be responsible with the tokens and do not share them with anyone, as this is controlled-access data**.

3. **samtools**: Required to generate BAM Index (BAI) files for the corresponding BAM files
 
4. **qmotif**: Download and install qmotif ([Documentation here](https://adamajava.readthedocs.io/en/latest/qmotif/qmotif_1_0/)).

5. **Java**: Required to run qmotif

6. **bcftools**: Required to obtain variants for the 15 telomere related genes

7. **Anaconda for Jupyter notebook**: Required to build the machine learning model

## **Additional Things to Prepare:** 
* I.) If you're only interested in certain chromosomal coordinates from the BAM file, get the specific coordinates using [UCSC's Genome Browser](https://genome.ucsc.edu/cgi-bin/hgGateway). TCGA data on the GDC Portal has been harmonized and mapped to the GRCh38 human reference genome build, so please be aware of this when you get the coordinates and ensure they are from the correct build. 

* II.) Refer to sample script `Kidney_TCGA_KICH_loop.sh` which utilizes the BAM files for UUIDs mentioned in the TSV file - `Kidney_TCGA_KICH_curl.tsv`

* III.) Generate a similar TSV file using "Cohort Builder" and "Repository" on the GDC Data Portal. 

///  **Steps to Download a Sample Sheet with UUIDs from the GDC Portal:**  
1. **Open the Cohort Builder**  
   - Click on **Cohort Builder** and select the program (e.g., **TCGA**).  
   - Choose the project (e.g., **TCGA-KICH**).  

2. **Select Features for Your Cohort**  
   - Customize your cohort by selecting relevant features such as:  
     - **Disease type**  
     - **Primary diagnosis**  
     - **Primary site**  
     - **Tissue or organ of origin**  
     - **Gender, race, ethnicity**  
     - **Vital status**  
     - **Site of biopsy**  
     - **Prior malignancy**  
     - **Tissue type**  
     - **Data format, etc.**  

3. **Save Your Cohort**  
   - Once all features are selected, click **Save the Cohort** and assign it a name.  

4. **Access the Repository**  
   - Now, navigate to the **Repository** and refine your selection by specifying:  
     - **Experimental strategy**  
     - **Data type**  
     - **Data format**  
     - **Type of access**  
     - **Tissue type**  
     - **Specimen type**  

5. **Download the Sample Sheet**  
   - Click the **Download Sample Sheet** button to generate a file containing the **UUIDs** for all selected files from your chosen project.  

6. **Verify the Sample Sheet**  
   - Review the downloaded file to ensure it includes all the selected features.  
   - If working on multiple projects, give each sample sheet a **unique name** for better organization.  

* IV.) Reference Genome FASTA (GRCh38.d1.vd1.fa) and FASTA index files (GRCh38.d1.vd1.fa.fai) were obtained from [NCI's website](https://gdc.cancer.gov/about-data/gdc-data-processing/gdc-reference-files). 
* v.) More information on BAM slicing using GDC Data Portal is available [here](https://docs.gdc.cancer.gov/Data_Portal/Users_Guide/BAMslicing/).


## File Descriptions
* **`Kidney_TCGA_KICH_curl.tsv`**: A TSV file containing all the UUIDs for the TCGA project of interest. This file specifically includes UUIDs for both normal and tumor BAM files from the TCGA-KICH project.
* **`Kidney_TCGA_KICH_loop.sh`**: A Bash script that performs curl requests to download and slice BAM files based on specified genomic regions. The regions used here are telomeric coordinates obtained using UCSC's LiftOver tool.
* **`bamindex.sh`**: A Bash script that uses samtools to generate corresponding BAI index files for the downloaded BAM files.
* **`Kidney_TCGA_KICH.py`**: A Python script that runs qmotif on the BAM and BAI files to analyze telomere content.





* **Note**: The GDC Portal allows you to download **BAM files and other controlled-access files for only one project at a time**. If you generate multiple tokens simultaneously, the system will automatically invalidate the second-to-last token, even if it has not been used. Additionally, once a token has been used to download files, it will immediately expire. Therefore, every time you need to download new files, you must obtain a **new token**.

## Usage
## Sequence of Execution
To use the pipeline, run the scripts in the following order:
1. `Kidney_TCGA_KICH_loop.sh` (requires: `Kidney_TCGA_KICH_curl.tsv`)
2. `bamindex.sh` (requires: samtools, BAM files, generates: BAI files)
3. `Kidney_TCGA_KICH.py` (requires: qmotif, BAM and BAI files, generates: `log.txt` and `output.txt` files)
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
