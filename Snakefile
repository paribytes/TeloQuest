import csv

samples = {}
with open("Kidney_TCGA_KICH_curl.tsv") as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        samples[row["SampleID"]] = row["UUID"]

SAMPLES = list(samples.keys())

rule all:
    input:
        expand("results/{sample}_output.txt", sample=SAMPLES),
        "results/mutation_summary.csv"

rule slice_bam_telomere_regions:
    output:
        "data/{sample}_telomere.bam"
    params:
        uuid=lambda wildcards: samples[wildcards.sample]
    shell:
        "bash slice_bam_telomere.sh {params.uuid} {output}"

rule index_bam_telomere:
    input:
        "data/{sample}_telomere.bam"
    output:
        "data/{sample}_telomere.bam.bai"
    shell:
        "/opt/anaconda3/envs/samtools_1_12_env/bin/samtools index {input} {output}"

rule run_qmotif:
    input:
        bam="data/{sample}_telomere.bam",
        bai="data/{sample}_telomere.bam.bai"
    output:
        log="results/{sample}_log.txt",
        out="results/{sample}_output.txt",
        bam="results/{sample}_output.bam",
        terminal="results/{sample}_terminal_output.txt"
    shell:
        "/opt/anaconda3/envs/teloquest_env/bin/python3 run_qmotif.py {input.bam} {input.bai} {output.log} {output.out} {output.bam} {output.terminal}"

rule slice_bam_gene_regions:
    output:
        "data/{sample}_genes.bam"
    params:
        uuid=lambda wildcards: samples[wildcards.sample]
    shell:
        "bash slice_bam_genes.sh {params.uuid} {output}"

rule index_bam_genes:
    input:
        "data/{sample}_genes.bam"
    output:
        "data/{sample}_genes.bam.bai"
    shell:
        "/opt/anaconda3/envs/samtools_1_12_env/bin/samtools index {input} {output}"

rule call_variants:
    input:
        bam="data/{sample}_genes.bam",
        bai="data/{sample}_genes.bam.bai",
        ref="GRCh38.d1.vd1.fa"
    output:
        "vcf/{sample}_variants.vcf.gz"
    shell:
        "bash run_bcftools.sh {input.ref} {input.bam} {output}"

rule vcf_to_txt:
    input:
        "vcf/{sample}_variants.vcf.gz"
    output:
        "txt/{sample}_variants.txt"
    shell:
        "bash variants_to_txt.sh {input} {output}"

rule aggregate_genotypes:
    input:
        expand("txt/{sample}_variants.txt", sample=SAMPLES)
    output:
        "results/mutation_summary.csv"
    shell:
        "/opt/anaconda3/envs/teloquest_env/bin/python3 aggregate_genotypes.py {input} {output}"
