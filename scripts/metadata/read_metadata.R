# Load required libraries for data manipulation and string processing
library(dplyr)
library(stringr)

# Set working directory where all input files are located
setwd("/Users/amber/SARS-CoV-2/trials")

# ---------------------------
# Load template metadata
# ---------------------------

# Read template metadata file containing sample information
df1 <- read.csv('template.csv', sep = ",", check.names = FALSE)

# Standardize primer set naming by adding ARTIC prefix if missing
df1$`Primer set` <- gsub("^V5.3.2", "Artic V5.3.2", df1$`Primer set`)

# Replace empty comment fields with 'None' for consistency
df1$Comments[df1$Comments == ''] <- 'None'

# ---------------------------
# Process Nextclade results
# ---------------------------

# Load Nextclade output file containing lineage and mutation information
df2 <- read.csv('nextclade.tsv', sep = "\t", check.names = FALSE)

# Clean sample IDs by removing sequencing suffix (e.g., "_S1", "_S2")
df2$Site <- gsub("_S.*$", "", df2$Site)

# ---------------------------
# Process variant metrics
# ---------------------------

# Load variant summary metrics produced by MultiQC
df3 <- read.csv('summary_variants_metrics_mqc.csv', sep = ",", check.names = FALSE)

# Remove technical replicate samples (_1, _2) from dataset
df3 <- df3 %>% filter(!str_detect(Sample, '_1|_2'))

# ---------------------------
# Process lineage frequency data
# ---------------------------

# Load lineage abundance predictions from ALCOV 
df4 <- read.csv('input_lineages.csv', sep = ",", check.names = FALSE)

# Remove lineage columns with zero abundance across all samples
df4 <- df4[, colSums(df4) != 0]

# Filter lineage columns with very low abundance (<1%)
df4 <- df4[, colSums(df4) >= 0.01]

# ---------------------------
# Process mutation heatmap data
# ---------------------------

# Load mutation frequency data used for heatmap visualization
df5 <- read.csv('heatmap_data2plot.csv', sep = ",", check.names = FALSE)

# Convert to matrix for numerical operations
df5 <- as.matrix(df5)

# Remove mutation columns with zero counts
df5 <- df5[, colSums(df5) != 0]

# Transpose matrix so mutations become rows
df5 <- as.data.frame(t(df5))

# Calculate total mutation frequency per sample
df5$total <- round(rowSums(df5, na.rm = TRUE), 0)

# ---------------------------
# Process sequencing coverage metrics
# ---------------------------

# Load samtools coverage output
df6 <- read.csv('samtools.tsv', sep = "\t", check.names = FALSE)

# Convert to matrix for numerical calculations
df6 <- as.matrix(df6)

# Transpose matrix so coverage metrics align with sample rows
df6 <- as.data.frame(t(df6))

# Calculate average coverage per sample
df6$avg <- rowMeans(df6, na.rm = TRUE)

# ---------------------------
# Merge all datasets
# ---------------------------

# Combine metadata with all processed datasets using Site ID as key
df7 <- df1 %>%
  left_join(df2, by = "Site ID") %>%
  left_join(df3, by = "Site ID") %>%
  left_join(df4, by = "Site ID") %>%
  left_join(df5, by = "Site ID") %>%
  left_join(df6, by = "Site ID") 

# ---------------------------
# Export final metadata report
# ---------------------------

# Write combined dataset to tab-separated metadata file
write.table(df7, file = "metadata.tsv", sep = "\t", row.names = FALSE)

