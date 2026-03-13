#!/bin/bash

# ------------------------------------------------------------
# Author: Amber Fedynak
#
# Description:
# This script runs a SARS-CoV-2 genomic analysis pipeline using
# the nf-core/viralrecon workflow. It performs alignment,
# variant calling, and lineage/mutation detection from
# sequencing BAM files.
#
# Tools used:
# - Nextflow / nf-core viralrecon
# - Samtools (coverage calculation)
# - ALCOV (lineage and mutation detection)
#
# Inputs:
# - samplesheet.csv (sample metadata for viralrecon)
# - BAM files produced by the pipeline
# - sequences.txt (list of sample IDs)
# - mutations.txt (list of mutations of interest)
#
# Outputs:
# - Variant calls and lineage predictions
# - Coverage statistics
# - Mutation frequency reports
# ------------------------------------------------------------


# Directory containing BAM files and pipeline input files
BAM_DIR='/Users/afedynak/Covid-19/pipeline/'


# ------------------------------------------------------------
# Run nf-core/viralrecon pipeline
# ------------------------------------------------------------

# Execute the viralrecon workflow using Nextflow.

NXF_VER=23.10.1 nextflow run nf-core/viralrecon \
--input ${BAM_DIR}/samplesheet.csv \      # Sample metadata sheet
--platform illumina \                     # Sequencing platform
--protocol amplicon \                     # Amplicon sequencing protocol
--primer_set artic \                      # ARTIC primer scheme
--primer_set_version 5.3.2 \              # Version of ARTIC primers used
--genome 'MN908947.3' \                   # SARS-CoV-2 reference genome accession
--fasta ref_genome/MN908947.3.fa \        # Reference genome FASTA file
--skip_assembly \                         # Skip genome assembly step
--skip_markduplicates \                   # Skip duplicate marking
--skip_fastp \                            # Skip read trimming with fastp
--variant_caller ivar \                   # Use iVar for variant calling
-profile docker \                         # Run pipeline using Docker containers
--max_cpus 24 \                           # Maximum CPUs allowed for workflow
--max_memory 200GB \                      # Maximum memory allocated
--schema_ignore_params 'genomes,primer_set_version' \  # Ignore schema validation issues
-r 2.5                                    # Viralrecon pipeline version


# ------------------------------------------------------------
# Calculate sequencing coverage using samtools
# ------------------------------------------------------------

# Compute per-base depth of coverage for all BAM files listed
# in bam_files.txt. Output is written to samtools_depth.tsv.

samtools depth -a -H \
-o ${BAM_DIR}/samtools_depth.tsv \
--reference MN908947.3. \
-f bam_files.txt


# ------------------------------------------------------------
# Predict SARS-CoV-2 lineages using ALCOV
# ------------------------------------------------------------

# Loop through each sample listed in sequences.txt
# and identify lineage composition based on variant data.

for i in $(cat sequences.txt); do
    alcov find_lineages ${BAM_DIR}/${i}.ivar_trim.sorted.bam alcov_lineages.txt
done


# ------------------------------------------------------------
# Identify mutations of interest
# ------------------------------------------------------------

# For each mutation listed in mutations.txt, scan all BAM files
# to detect the presence and frequency of that mutation.

for i in $(cat mutations.txt); do
    for j in $(cat sequences.txt); do
        alcov find_mutants ${BAM_DIR}/${j}.ivar_trim.sorted.bam ${i}.txt
    done
done

