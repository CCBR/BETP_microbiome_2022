. ./config.sh


########################################
# modules
########################################
module load qiime/2-2021.4

########################################
# Preparing the Directories
########################################
dirs=("raw_data" "logs/download" "manifests" "output/02_import" "output/03_trim" "output/04_denoise"
        "output/05_feature_tables" "output/05_sequence_tables" "output/06_taxonomic_classification/rawdata"
        "output/07_phylogenetics" "output/09_biom")
for pd in ${dirs[@]}; do if [[ ! -d $working_dir/$pd ]]; then mkdir -p $working_dir/$pd; fi; done

########################################
# Workflow
########################################
echo "########################################"
echo "### 01 PREP ###"
echo "########################################"

# create the import manifest
echo "sample-id,absolute-filepath,direction" > $q2_manifest

# read in the SRA file
## for each SRA sample, determine if the fastq has been downloaded
### if it hasn't, creating an SBATCH job and submit to the cluster
### if it has, skip
## add the sample to the Q2 manifest for import
sflag="N"
sbatch_file="$log_dir/download/sra_download_221024.sh"
while IFS=',' read -a sra_id; do
    
    # set file names
    fastq="$raw_data_dir/${sra_id}_1.fastq.gz"
    
    # create sbatch files to submit to download SRA's
    # https://hpc.nih.gov/apps/sratoolkit.html
    if [[ ! -f $sbatch_file ]]; then                
        echo "#!/bin/sh"  > $sbatch_file
        echo "module load sratoolkit" >> $sbatch_file
        echo "tmp_dir=\"/lscratch/\${SLURM_JOB_ID}\"" >> $sbatch_file
    fi
    if [[ ! -f $fastq ]]; then        
        echo "fasterq-dump -p -t \$tmp_dir -O $raw_data_dir $sra_id" >> $sbatch_file            
        echo "gzip $raw_data_dir/${sra_id}_1.fastq" >> $sbatch_file
        echo "gzip $raw_data_dir/${sra_id}_2.fastq" >> $sbatch_file
        sflag="Y"
    else
        echo "--$sra_id FASTQ files are already downloaded"
    fi
    
    # create manifest for importing
    echo "$sra_id,$raw_data_dir/${sra_id}_1.fastq.gz,forward" >> $q2_manifest
    echo "$sra_id,$raw_data_dir/${sra_id}_2.fastq.gz,reverse" >> $q2_manifest
done < $sra_list

# if any samples were missing, submit sbatch file to download SRA's
if [[ $sflag == "Y" ]]; then
    echo "--submitting SBATCH"
    #cat $sbatch_file
    sbatch --cpus-per-task=12 --verbose --output=$log_dir/%j.out --mem=200g --gres=lscratch:450 --time 10:00:00 --error=$log_dir/%j.err $sbatch_file
fi

# train the classifier
# silva downloaded: https://www.arb-silva.de/download/archive/qiime/
### rep_set/rep_set/16S_only/99/
### taxonomy/16S_only/99/raw_taxonomy
# https://docs.qiime2.org/2019.1/tutorials/feature-classifier/
if [[ ! -f $refdb_seq ]]; then
    # FeatureSequence
    # Create the reference database to be used for taxonomic_classification used unaligned reads for this - creates ''FeatureData[Sequence]''
    echo "--classifer seq"
    qiime tools import \
        --type 'FeatureData[Sequence]' \
        --input-path $ref_fna \
        --output-path $refdb_seq
fi

if [[ ! -f $refdb_tax ]]; then
    echo "--classifer taxonomy"
    #FeatureTaxonomy
    # Create the reference database to be used for taxonomic_classification used unaligned reads for this - creates ''FeatureData[Taxonomy]''
    qiime tools import \
        --input-format HeaderlessTSVTaxonomyFormat \
        --type 'FeatureData[Taxonomy]' \
        --input-path $ref_txt \
        --output-path $refdb_tax
fi

if [[ ! -f $refdb_classifier ]]; then
    echo "--classifier train submitted"
    #train classifier
    # Creates TaxonomicClassifier
    echo "#!/bin/sh
    
    module load qiime/2-2021.4
    
    qiime feature-classifier fit-classifier-naive-bayes \
        --i-reference-reads $refdb_seq \
        --i-reference-taxonomy $refdb_tax \
        --o-classifier $refdb_classifier" > $log_dir/classifier_sb.sh
    
    sbatch --cpus-per-task=12 --verbose \
        --output=$log_dir/%j.out \
        --mem=200g --gres=lscratch:450 --time 2-00:00:00 \
        --error=$log_dir/%j.err \
        $log_dir/classifier_sb.sh
fi