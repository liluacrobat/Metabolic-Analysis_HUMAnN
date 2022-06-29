#!/bin/sh

mkdir tsv_table_raw
mkdir tsv_table_raw/genefamilies
mkdir tsv_table_raw/pathabundance
mkdir tsv_table_raw/pathcoverage
for x in *_humann_result; do cp $x/*_genefamilies.tsv tsv_table_raw/genefamilies/.;done
for x in *_humann_result; do cp $x/*_pathabundance.tsv tsv_table_raw/pathabundance/.;done
for x in *_humann_result; do cp $x/*_pathcoverage.tsv tsv_table_raw/pathcoverage/.;done

cd tsv_table_raw

eval "$(/util/common/python/py38/anaconda-2020.07/bin/conda shell.bash hook)"
conda activate /projects/academic/pidiazmo/projectsoftwares/metaphlan3

humann_join_tables --input genefamilies --output genefamilies_joined.tsv
humann_join_tables --input pathabundance --output pathabundance_joined.tsv
humann_join_tables --input pathcoverage --output pathcoverage_joined.tsv

humann_split_stratified_table --input genefamilies_joined.tsv --output genefamilies_split_stratified
humann_split_stratified_table --input pathabundance_joined.tsv --output pathabundance_split_stratified
humann_split_stratified_table --input pathcoverage_joined.tsv --output pathcoverage_split_stratified

cd genefamilies_split_stratified
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_GO.tsv -g uniref90_go
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_KO.tsv -g uniref90_ko
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_level4ec.tsv -g uniref90_level4ec
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_MetaCyCreaction.tsv -g uniref90_rxn
humann_regroup_table -i genefamilies_joined_unstratified_level4ec.tsv -o genefamilies_joined_unstratified_KEGGpwy.tsv -c ../../../reference_db/kegg/ec.to.pwy


humann_rename_table --i genefamilies_joined_unstratified_GO.tsv -n go -o genefamilies_joined_unstratified_GO_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified_KO.tsv -n kegg-orthology -o genefamilies_joined_unstratified_KO_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified_level4ec.tsv -n ec -o genefamilies_joined_unstratified_level4ec_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified_MetaCyCreaction.tsv -n metacyc-rxn -o genefamilies_joined_unstratified_MetaCyCreaction_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified.tsv -n uniref90 -o genefamilies_joined_unstratified_UniRef90_w_anno.tsv
