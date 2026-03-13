# SARS-CoV-2 Variant Processing Pipeline

## Overview

This pipeline processes SARS-CoV-2 variant data from raw sequencing files to the final report. It leverages various tools and steps for quality control, alignment, variant calling, lineage prediction, and coverage assessment. The pipeline provides valuable insights into viral variants, including VOC (Variants of Concern) detection, mutation frequencies, depth of coverage, and more.

DOI: https://doi.org/10.1038/s41598-024-76925-6

## Key Steps in the Pipeline

1. **Data Preparation and File Organization**
   - Organizes raw sequencing data (FASTQ files) and metadata.
   - Converts FASTQ data into a samplesheet for downstream processing.

2. **ViralRecon for Alignment**
   - Aligns sequencing data against the SARS-CoV-2 reference genome using ViralRecon.
   - Produces aligned BAM files for downstream variant calling.

3. **VCFParser for Variant Analysis**
   - Identifies and characterizes mutations in the aligned data.
   - Detects VOCs (Variants of Concern) and other mutations of interest.

4. **Samtools for Coverage Analysis**
   - Calculates the depth and breadth of coverage across the SARS-CoV-2 genome using Samtools.
   - Provides insights into the quality and reliability of sequencing data.

5. **ALCOV for Lineage and Mutation Prediction**
   - Predicts SARS-CoV-2 lineages and distinguishing mutations.
   - Outputs information on the relative abundance of mutations in each sample.

6. **Final Data Integration and Summary**
   - Combines data from multiple sources (Nextclade, summary variants, lineage predictions) into a comprehensive report.
   - Produces a summary file with detailed information on mutations, VOCs, depth of coverage, and lineages.

## Requirements

To run this pipeline, ensure you have the following software installed:

- **Nextflow**: For orchestrating the pipeline workflow.
- **ViralRecon**: For aligning sequencing reads to the reference genome.
- **VCFParser**: For analyzing and parsing variant call format (VCF) files.
- **Samtools**: For working with BAM files and analyzing coverage.
- **ALCOV**: For predicting SARS-CoV-2 lineages and mutations.

Additionally, the following Python libraries are be required:

- `pandas`
- `numpy`
- `matplotlib`
- `seaborn`

## Outputs
After the pipeline runs successfully, the following output files will be generated:

final_report.tsv: Comprehensive report containing all the processed data, including mutation frequencies, lineage predictions, coverage statistics.

aligned_bam_files/: Directory containing the aligned BAM files from ViralRecon.

vcf_files/: Directory containing the VCF files with identified variants.

coverage_reports/: Samtools coverage analysis reports.

lineages_report/: ALCOV lineage prediction results.

## Contact Information
This pipeline aims to track the prevalence and spread of SARS-CoV-2 variants through wastewater samples. For more information or inquiries related to the pipeline, please open a GihHub issue.


We encourage collaboration and welcome any feedback or contributions to improve the pipeline. If you have any questions regarding the usage or adaptation of the pipeline for specific projects, feel free to reach out.
<br>
<br>
