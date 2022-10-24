. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Workflow
########################################
echo "########################################"
echo "### 03 TRIM ADAPTORS ###"
echo "########################################"
#https://docs.qiime2.org/2021.4/plugins/available/cutadapt/trim-paired/

if [[ ! -f $trimmed_qza ]]; then
    echo "--qime2 trim"
    qiime cutadapt trim-paired \
        --i-demultiplexed-sequences $import_qza \
        --p-front-f $forward_adaptor \
        --p-front-r $reverse_adaptor \
        --p-error-rate 0 \
        --o-trimmed-sequences $trimmed_qza \
        --verbose
fi 

if [[ ! -f $trimmed_qzv ]]; then
    echo "--qime2 trim visual"
    qiime demux summarize \
        --i-data $trimmed_qza \
        --o-visualization  $trimmed_qzv
fi