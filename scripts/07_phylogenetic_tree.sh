. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Workflow
########################################
echo "########################################"
echo "### 07 PHYLOGENY ###"
echo "########################################"

if [[ ! -f $rooted_tree ]]; then
    echo "--qiime2 phylogeny"

    # note that phylogenetics are done with original taxa, including non-bacterial and phylum-unclassified taxa
    # Starts by creating a sequence alignment using MAFFT, remove any phylogenetically uninformative or ambiguously aligned reads, infer a phylogenetic tree
    # and then root at its midpoint.
    qiime phylogeny align-to-tree-mafft-fasttree \
        --i-sequences $seq_filt4_qza \
        --o-alignment $msa \
        --o-masked-alignment $masked_msa \
        --o-tree $unrooted_tree \
        --o-rooted-tree $rooted_tree
fi