########################################
# BETP Microbiome Class
########################################

########################################
# Class Info
########################################
# Class Dates:
# Instructors:

########################################
# Background info
########################################
# Source paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9051480/
# Source data: https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=803155
# qiime viewer: https://view.qiime2.org/

########################################
# Paths
########################################
working_dir="/data/sevillas2/microbiome_class"
output_dir="$working_dir/output"
log_dir="$working_dir/logs"
raw_data_dir="$working_dir/raw_data"
ref_dir="$working_dir/refs"

########################################
# Manifest
########################################
# To create an SRA list
# go to: https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=803155
# select "Send to Run Selector"
sra_list="$working_dir/manifests/SRR_Acc_List.txt"
#sra_list="$working_dir/manifests/SRR_Acc_List_test.txt"

# set qiime2 manifest name, to be used for import
q2_manifest="$working_dir/manifests/q2_manifest.txt"

# set the metadata name
metadata_txt="$working_dir/manifests/metadata.txt"

########################################
# Output Files
########################################
## 01
ref_fna="$ref_dir/silva_132_99.fna"
ref_txt="$ref_dir/silva_taxonomy.txt"
refdb_seq="$ref_dir/refdb_seq_silva99.qza"
refdb_tax="$ref_dir/refdb_tax_silva99.qza"
refdb_classifier="$ref_dir/refdb_classifier_silva99.qza"

## 02
import_qza="$output_dir/02_import/run1.qza"
import_qzv="$output_dir/02_import/run1.qzv"
## 03
trimmed_qza="$output_dir/03_trim/run1.qza"
trimmed_qzv="$output_dir/03_trim/run1.qzv"

## 04
features="$output_dir/04_denoise/feature_tables_run1.qza"
sequences="$output_dir/04_denoise/sequence_tables_run1.qza"
stats_qza="$output_dir/04_denoise/stats_run1.qza"
stats_qzv="$output_dir/04_denoise/stats_run1.qzv"

## 05
feat_filt1_qza="$output_dir/05_feature_tables/05_remove_samples_with_low_read_count.qza"
feat_filt2_qza="$output_dir/05_feature_tables/05_remove_features_with_low_read_count.qza"
feat_filt3_qza="$output_dir/05_feature_tables/05_remove_features_with_low_sample_count.qza"
feat_filt4_qza="$output_dir/05_feature_tables/05_remove_samples_with_low_feature_count.qza"

feat_filt1_qzv="$output_dir/05_feature_tables/05_remove_samples_with_low_read_count.qzv"
feat_filt2_qzv="$output_dir/05_feature_tables/05_remove_features_with_low_read_count.qzv"
feat_filt3_qzv="$output_dir/05_feature_tables/05_remove_features_with_low_sample_count.qzv"
feat_filt4_qzv="$output_dir/05_feature_tables/05_remove_samples_with_low_feature_count.qzv"

seq_filt1_qza="$output_dir/05_sequence_tables/05_remove_samples_with_low_read_count.qza"
seq_filt2_qza="$output_dir/05_sequence_tables/05_remove_features_with_low_read_count.qza"
seq_filt3_qza="$output_dir/05_sequence_tables/05_remove_features_with_low_sample_count.qza"
seq_filt4_qza="$output_dir/05_sequence_tables/05_remove_samples_with_low_feature_count.qza"

seq_filt1_qzv="$output_dir/05_sequence_tables/05_remove_samples_with_low_read_count.qzv"
seq_filt2_qzv="$output_dir/05_sequence_tables/05_remove_features_with_low_read_count.qzv"
seq_filt3_qzv="$output_dir/05_sequence_tables/05_remove_features_with_low_sample_count.qzv"
seq_filt4_qzv="$output_dir/05_sequence_tables/05_remove_samples_with_low_feature_count.qzv"

## 06
taxonomic_classification_qza="$output_dir/06_taxonomic_classification/06_taxonomic_classification.qza"
taxonomic_classification_qzv="$output_dir/06_taxonomic_classification/06_taxonomic_classification.qzv"
taxonomic_bar_plots="$output_dir/06_taxonomic_classification/06_taxonomic_barplots.qzv"
taxonmic_data_files="$output_dir/06_taxonomic_classification/rawdata"
taxonomic_classification_seq="$output_dir/06_taxonomic_classification/06_taxonomic_classification_seq.qza"
taxonomic_classification_feat="$output_dir/06_taxonomic_classification/06_taxonomic_classification_feat.qza"

## 07
msa="$output_dir/07_phylogenetics/msa.qza"
masked_msa="$output_dir/07_phylogenetics/masked_msa.qza"
unrooted_tree="$output_dir/07_phylogenetics/unrooted_tree.qza"
rooted_tree="$output_dir/07_phylogenetics/rooted_tree.qza"

## 08
alpha_diversity_dir="$output_dir/08_alpha_beta_diversity"
alpha_diversity_qzv="$alpha_diversity_dir/alpha_diversity_metadata.qzv"
alpha_rarefaction="$alpha_diversity_dir/rarefaction.qzv"

## 09
biom_output_feat="$output_dir/09_biom/feature_tables"
biom_output_seq="$output_dir/09_biom/sequence_tables"
feature_table="$biom_output_feat/feature-table.from_biom.txt"

########################################
# Params
########################################
forward_adaptor="ACTCCTACGGGAGGCAGCAGT"
reverse_adaptor="CGGACTAC"
trim_l_f="0"
trim_l_r="0"
trun_len_f="0"
trun_len_r="0"
min_fold="2.0"
min_num_reads_per_sample="1"
min_num_reads_per_feature="1"
min_num_samples_per_feature="1"
min_num_features_per_sample="1"
sampling_depth="10000"
max_depth="54000"