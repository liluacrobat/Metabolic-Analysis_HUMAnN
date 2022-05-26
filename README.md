# Metabolic-Analysis using HUMAnN
Install database
##  Install HUMAnN
```
#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --time=71:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name="humann"
#SBATCH --output=humann.log

eval "$(/util/common/python/py38/anaconda-2020.07/bin/conda shell.bash hook)"
conda activate /projects/academic/pidiazmo/projectsoftwares/metaphlan3

humann_databases --download chocophlan full /projects/academic/pidiazmo/projectsoftwares/HUMAnN_database --update-config yes
humann_databases --download uniref uniref90_diamond /projects/academic/pidiazmo/projectsoftwares/HUMAnN_database --update-config yes
humann_databases --download utility_mapping full /projects/academic/pidiazmo/projectsoftwares/HUMAnN_database --update-config yes
```
## Run HUMAnN with Sequences Processed by Kneaddata
```
#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --time=71:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=60000
#SBATCH --job-name="H-__SAMPLE_ID__"
#SBATCH --output=H-__SAMPLE_ID__.log

eval "$(/util/common/python/py38/anaconda-2020.07/bin/conda shell.bash hook)"
conda activate /projects/academic/pidiazmo/projectsoftwares/metaphlan3

echo '--------------------'
echo 'Star ...'
cat __SAMPLE_ID___R1_001_kneaddata_paired_1.fastq __SAMPLE_ID___R1_001_kneaddata_paired_2.fastq > __SAMPLE_ID__merged_sample.fastq
humann --input __SAMPLE_ID__merged_sample.fastq --output __SAMPLE_ID___humann_result --threads 12 --search-mode uniref90

echo 'Succeed'
echo '--------------------'

```

## Post-processing
### Collect Table
```
mkdir tsv_table_raw
mkdir tsv_table_raw/genefamilies
mkdir tsv_table_raw/pathabundance
mkdir tsv_table_raw/pathcoverage
for x in *_humann_result; do cp $x/*_genefamilies.tsv tsv_table_raw/genefamilies/.;done
for x in *_humann_result; do cp $x/*_pathabundance.tsv tsv_table_raw/pathabundance/.;done
for x in *_humann_result; do cp $x/*_pathcoverage.tsv tsv_table_raw/pathcoverage/.;done
```
### Join Table
```
cd tsv_table_raw
humann_join_tables --input genefamilies --output genefamilies_joined.tsv
humann_join_tables --input pathabundance --output pathabundance_joined.tsv
humann_join_tables --input pathcoverage --output pathcoverage_joined.tsv
```
### Split Table
```
humann_split_stratified_table --input genefamilies_joined.tsv --output genefamilies_split_stratified
humann_split_stratified_table --input pathabundance_joined.tsv --output pathabundance_split_stratified
humann_split_stratified_table --input pathcoverage_joined.tsv --output pathcoverage_split_stratified
```
### Regroup Table
-g {uniref90_rxn,uniref50_rxn,uniref50_go,uniref90_go,uniref50_ko,uniref90_ko,uniref50_level4ec,uniref90_level4ec,uniref50_pfam,uniref90_pfam,uniref50_eggnog,uniref90_eggnog}, --groups {uniref90_rxn,uniref50_rxn,uniref50_go,uniref90_go,uniref50_ko,uniref90_ko,uniref50_level4ec,uniref90_level4ec,uniref50_pfam,uniref90_pfam,uniref50_eggnog,uniref90_eggnog}

```
cd genefamilies_split_stratified
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_GO.tsv -g uniref90_go
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_KO.tsv -g uniref90_ko
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_level4ec.tsv -g uniref90_level4ec
humann_regroup_table -i genefamilies_joined_unstratified.tsv -o genefamilies_joined_unstratified_MetaCyCreaction.tsv -g uniref90_rxn
humann_regroup_table -i genefamilies_joined_unstratified_level4ec.tsv -o genefamilies_joined_unstratified_KEGGpwy.tsv -c ec.to.pwy


humann_rename_table --i genefamilies_joined_unstratified_GO.tsv -n go -o genefamilies_joined_unstratified_GO_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified_KO.tsv -n kegg-orthology -o genefamilies_joined_unstratified_KO_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified_level4ec.tsv -n ec -o genefamilies_joined_unstratified_level4ec_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified_MetaCyCreaction.tsv -n metacyc-rxn -o genefamilies_joined_unstratified_MetaCyCreaction_w_anno.tsv
humann_rename_table --i genefamilies_joined_unstratified.tsv -n uniref90 -o genefamilies_joined_unstratified_UniRef90_w_anno.tsv 
```
