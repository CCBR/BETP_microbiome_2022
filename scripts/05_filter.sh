. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Workflow
########################################
echo "########################################"
echo "### 05 FILTER ###"
echo "########################################"
#https://docs.qiime2.org/2021.4/tutorials/filtering/


# For each block
## 1. Perform feature level filtering
## 2. Perform sequence level filtering
## 3. Visualize feature table
## 4. Visualize sequence table


# remove_samples_with_low_read_count
if [[ ! -f $feat_filt1_qza ]]; then
    echo "----filter1/4"
    qiime feature-table filter-samples \
        --i-table $features \
        --p-min-frequency $min_num_reads_per_sample \
        --o-filtered-table $feat_filt1_qza

    qiime feature-table filter-seqs \
        --i-data $sequences \
        --i-table $feat_filt1_qza \
        --o-filtered-data $seq_filt1_qza
        
    qiime feature-table summarize \
        --i-table $feat_filt1_qza \
        --o-visualization $feat_filt1_qzv \
        --m-sample-metadata-file $metadata_txt
    
    qiime feature-table tabulate-seqs \
        --i-data $seq_filt1_qza \
        --o-visualization $seq_filt1_qzv

fi
# remove_features_with_low_read_count
if [[ ! -f $feat_filt2_qza ]]; then
    echo "----filter2/4"
    qiime feature-table filter-features \
        --i-table $feat_filt1_qza \
        --p-min-frequency $min_num_reads_per_feature \
        --o-filtered-table $feat_filt2_qza
    
    qiime feature-table filter-seqs \
        --i-data $sequences \
        --i-table $feat_filt2_qza \
        --o-filtered-data $seq_filt2_qza

    qiime feature-table summarize \
        --i-table $feat_filt1_qza \
        --o-visualization $feat_filt2_qzv \
        --m-sample-metadata-file $metadata_txt

    qiime feature-table tabulate-seqs \
        --i-data $seq_filt2_qza \
        --o-visualization $seq_filt2_qzv
fi

# remove_features_with_low_sample_count
if [[ ! -f $feat_filt3_qza ]]; then
    echo "----filter3/4"
    qiime feature-table filter-features \
        --i-table $feat_filt2_qza \
        --p-min-samples $min_num_samples_per_feature \
        --o-filtered-table $feat_filt3_qza
    
    qiime feature-table filter-seqs \
        --i-data $sequences \
        --i-table $feat_filt3_qza \
        --o-filtered-data $seq_filt3_qza
        
   qiime feature-table summarize \
        --i-table $feat_filt2_qza \
        --o-visualization $feat_filt3_qzv \
        --m-sample-metadata-file $metadata_txt

    qiime feature-table tabulate-seqs \
        --i-data $seq_filt3_qza \
        --o-visualization $seq_filt2_qzv
fi

# remove_samples_with_low_feature_count
# Remove samples that have less than min # features; Min of at least 1 is necessary to remove 0 read samples
if [[ ! -f $feat_filt4_qza ]]; then
    echo "----filter4/4"
    qiime feature-table filter-samples \
        --i-table $feat_filt3_qza \
        --p-min-features $min_num_features_per_sample \
        --o-filtered-table $feat_filt4_qza
    
    qiime feature-table filter-seqs \
        --i-data $sequences \
        --i-table $feat_filt4_qza \
        --o-filtered-data $seq_filt4_qza

    qiime feature-table summarize \
        --i-table $feat_filt3_qza \
        --o-visualization $feat_filt4_qzv \
        --m-sample-metadata-file $metadata_txt
    
    qiime feature-table tabulate-seqs \
        --i-data $seq_filt4_qza \
        --o-visualization $seq_filt4_qzv
fi