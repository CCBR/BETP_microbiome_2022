. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Workflow
########################################
echo "########################################"
echo "### 08 ALPHA/BETA DIVERSITY ###"
echo "########################################"
# https://docs.qiime2.org/2021.4/plugins/available/diversity/core-metrics-phylogenetic/

if [[ ! -f $alpha_diversity_dir/weighted_unifrac_emperor.qzv ]]; then
    echo "--qiime2 alpha/beta diversity"
    # note that alpha and beta diversity are done with filtered taxa, which excludes non-bacterial and phylum-unclassified taxa
    # - Vector of Faith PD values by sample
    # - Vector of Observed OTUs values by sample
    # - Vector of Shannon diversity values by sample
    # - Vector of Pielou's evenness values by sample
    # - Matrices of unweighted and weighted UniFrac distances, Jaccard distances,
    #     and Bray-Curtis distances between pairs of samples.
    # - PCoA matrix computed from unweighted and weighted UniFrac distances, Jaccard distances,
    #     and Bray-Curtis distances between samples.
    # - Emperor plot of the PCoA matrix computed from unweighted and weighted UniFrac, Jaccard,
    #     and Bray-Curtis.
    
    qiime diversity core-metrics-phylogenetic \
        --i-phylogeny $rooted_tree \
        --i-table $feat_filt4_qza \
        --p-sampling-depth $sampling_depth \
        --m-metadata-file $metadata_txt \
        --output-dir $alpha_diversity_dir
fi

if [[ ! -f $alpha_diversity_qzv ]]; then
    #This generates a tabular view of the metadata in a human viewable format merged with select alpha 
    #diversity metrics
    echo "--qiime2 alpha/beta tabular"
    qiime metadata tabulate \
        --m-input-file $alpha_diversity_dir/observed_features_vector.qza \
        --m-input-file $alpha_diversity_dir/shannon_vector.qza \
        --m-input-file $alpha_diversity_dir/evenness_vector.qza \
        --m-input-file $alpha_diversity_dir/faith_pd_vector.qza \
        --o-visualization $alpha_diversity_qzv
fi

if [[ ! -f $alpha_rarefaction ]]; then
    #Generates interactive rarefaction curves.
    echo "--qiime2 rarefaction"
    qiime diversity alpha-rarefaction \
        --i-table $feat_filt4_qza \
        --i-phylogeny $rooted_tree \
        --p-max-depth $max_depth \
        --m-metadata-file $metadata_txt \
        --o-visualization $alpha_rarefaction
fi