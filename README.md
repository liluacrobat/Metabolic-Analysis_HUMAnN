# Metabolic-Analysis using HUMAnN
Install database
## 
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
