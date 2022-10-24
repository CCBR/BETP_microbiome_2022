. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Workflow
########################################
echo "########################################"
echo "### 02 IMPORT ###"
echo "########################################"

if [[ ! -f $import_qza ]]; then
    echo "--qiime2 import"
    qiime tools import \
        --type 'SampleData[PairedEndSequencesWithQuality]' \
        --input-path $q2_manifest \
        --output-path $import_qza \
        --input-format PairedEndFastqManifestPhred33
fi

if [[ ! -f $import_qzv ]]; then
    echo "--qime2 import visual"
    qiime demux summarize \
        --i-data $import_qza \
        --o-visualization $import_qzv
fi