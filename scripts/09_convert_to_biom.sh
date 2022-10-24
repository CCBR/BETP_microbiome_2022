
. ./config.sh

########################################
# modules
########################################
module load qiime/2-2021.4 biom-format/2.1.12

########################################
# workflow
########################################
if [[ ! -f $feature_table ]]; then
    #Convert feature table to biom format well as feature data to tsv
    qiime tools export --input-path $feat_filt4_qza --output-path $biom_output_feat
    qiime tools export --input-path $seq_filt4_qza --output-path $biom_output_seq

    biom convert -i $biom_output_feat/feature-table.biom -o $feature_table --to-tsv
fi