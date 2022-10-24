. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Workflow
########################################
echo "########################################"
echo "### 06 TAXONOMIC CLASSIFICATION ###"
echo "########################################"
# Classify reads by taxon using a fitted classifier
# https://docs.qiime2.org/2021.4/plugins/available/feature-classifier/

if [[ ! -f $taxonomic_classification_qza ]]; then
    echo "--qiime2 taxonomic classification"
    qiime feature-classifier classify-sklearn \
        --i-classifier $refdb_classifier \
        --i-reads $seq_filt4_qza \
        --o-classification $taxonomic_classification_qza
fi

if [[ ! -f $taxonomic_classification_qzv ]]; then
    echo "--qiime2 taxonomic classification visual"
    qiime metadata tabulate \
        --m-input-file $taxonomic_classification_qza \
        --o-visualization $taxonomic_classification_qzv
fi

# Interactive barplot visualization of taxonomies
if [[ ! -f $taxonomic_bar_plots ]]; then
    echo "--qiime2 taxonomic classification barplots"
    qiime taxa barplot \
        --i-table $feat_filt4_qza \
        --i-taxonomy $taxonomic_classification_qza \
        --m-metadata-file $metadata_txt \
        --o-visualization $taxonomic_bar_plots
fi

# output all seven levels of taxonomy
if [[ ! -f $taxonmic_data_files/level-7.csv ]]; then
    echo "--qiime2 taxonomic classification export raw data"
    qiime tools export \
        --input-path $taxonomic_classification_qza \
        --output-path $taxonmic_data_files
fi

# Remove taxa with non bacterial sequences and bacteria with unannotated phyla
if [[ ! -f $taxonomic_classification_seq ]]; then
    echo "--qiime2 taxonomic classification cleanup seqs"
    qiime taxa filter-table \
            --i-table $feat_filt4_qza \
            --i-taxonomy $taxonomic_classification_qza \
            --p-include "D_0__Bacteria;D_1,k__Bacteria; p__" \
            --o-filtered-table $taxonomic_classification_seq
fi

# Remove taxa with non bacterial features and bacteria with unannotated phyla
if [[ ! -f $taxonomic_classification_feat ]]; then
    echo "--qiime2 taxonomic classification cleanup feats"
    qiime taxa filter-table \
        --i-table $feat_filt4_qza \
        --i-taxonomy $taxonomic_classification_qza \
        --p-mode exact \
        --p-exclude "k__Bacteria; p__" \
        --o-filtered-table $taxonomic_classification_feat
fi