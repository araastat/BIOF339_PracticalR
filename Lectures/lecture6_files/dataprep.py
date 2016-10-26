import pandas as pd
import zipfile
import re

### Set path to the data set
dataset_path = "77_cancer_proteomes_CPTAC_itraq.csv"
clinical_info = "clinical_data_breast_cancer.csv"
pam50_proteins = "PAM50_proteins.csv"

zipfilepath = '../lecture6_data/breastcancerproteomes.zip'

z = zipfile.ZipFile(zipfilepath)

## Load data
data = pd.read_csv(z.open(dataset_path),header=0,index_col=0)
clinical = pd.read_csv(z.open(clinical_info),header=0,index_col=0)## holds clinical information about each patient/sample

## Drop unused information columns
data.drop(['gene_symbol','gene_name'],axis=1,inplace=True)


## Change the protein data sample names to a format matching the clinical data set
data.rename(columns=lambda x: "TCGA-%s" % (re.split('[_|-|.]',x)[0]) if bool(re.search("TCGA",x)) is True else x,inplace=True)

## Transpose data for the clustering algorithm since we want to divide patient samples, not proteins
data = data.transpose()
data.to_csv('../lecture6_data/BreastCancer_Expression_full.csv', index=True, index_label='TCGA_ID')
## Reduce the data

data = data.iloc[:,:10]

## Drop clinical entries for samples not in our protein data set
clinical = clinical.loc[[x for x in clinical.index.tolist() if x in data.index],:]

data.to_csv('../lecture6_data/BreastCancer_Expression.csv', index=True, index_label = "TCGA_ID")
data.to_excel('../lecture6_data/BreastCancer_Expression.xlsx', index_label = "TCGA_ID")

clinical.to_csv('../lecture6_data/BreastCancer_Clinical.csv', index=True)
clinical.to_excel
