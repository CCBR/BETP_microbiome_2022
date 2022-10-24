. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Workflow
########################################
echo "########################################"
echo "### 04 DENOISE ###"
echo "########################################"

if [[ ! -f $features ]]; then
    echo "--qiime2 denoise"
    qiime dada2 denoise-paired \
        --i-demultiplexed-seqs $trimmed_qza \
        --o-table $features \
        --o-representative-sequences $sequences \
        --o-denoising-stats $stats_qza \
        --p-trim-left-f $trim_l_f \
        --p-trim-left-r $trim_l_r \
        --p-trunc-len-f $trun_len_f \
        --p-trunc-len-r $trun_len_r \
        --p-min-fold-parent-over-abundance $min_fold
fi

if [[ ! -f $stats_qzv ]]; then
    echo "--qiime2 denoise visualize"
    qiime metadata tabulate \
        --m-input-file $stats_qza \
        --o-visualization $stats_qzv
fi