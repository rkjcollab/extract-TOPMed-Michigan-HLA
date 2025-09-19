#!/bin/bash


# Function to display help text

function display_help() {

   echo "Usage: $0 <plink2_path> <topmed_vcf_dir> <michigan_hla_vcf> <snp_file> <output_vcf_file>"

   echo

   echo "Description:"

   echo " This script performs VCF file processing for T1D GRS analysis. It includes the following steps:"

   echo

   echo "Options:"

   echo " <plink2_path>        Full path to the plink2 executable."

   echo " <topmed_vcf_dir>     Directory containing TOPMed VCF files (chr1.dose.vcf.gz, etc.)"

   echo " <michigan_hla_vcf>   Path to the Michigan HLA VCF file."

   echo " <snp_file>           Path to the SNP file containing variants of interest."

   echo " <output_vcf_file>    Desired path for the combined output VCF file."

   echo

   echo "Steps:"

   echo " 1. Extract relevant variants from TOPMed VCF files for each chromosome."

   echo " 2. Extract relevant variants from the Michigan HLA VCF file."

   echo " 3. Combine extracted VCF files into a single output VCF file."

}


# Check for --help or -h flag

if [[ "$1" == "--help" || "$1" == "-h" ]]; then

   display_help

   exit 0

fi


# Check for sufficient input parameters

if [ $# -lt 5 ]; then

   display_help # Display help if not enough parameters 

   exit 1 

fi


plink2=$1 

TOPMED_DIR=$2 

MICHIGAN_HLA=$3 

SNP_FILE=$4 

OUTPUT_VCF=$5


# Function for extracting TOPMed variants by chromosome

extract_topmed_variants() {

   chr=$1

   echo "Extracting TOPMed variants for chromosome ${chr}"

   ${plink2} --keep-allele-order --const-fid 0 --rm-dup retain-mismatch --recode vcf bgz --extract ${SNP_FILE}  --out chr${chr}_Topmed_r3  --vcf ${TOPMED_DIR}/chr${chr}.dose.vcf.gz

}


# Extract TOPMed variants

echo "Step 1: Extracting TOPMed variants"

dt=$(date '+%d/%m/%Y %H:%M:%S')

echo "$dt"


for chr in {1..22}; do

   extract_topmed_variants $chr

done


# Extract Michigan HLA variants

echo "Step 2: Extracting Michigan HLA variants"

${plink2} --extract ${SNP_FILE} --vcf ${MICHIGAN_HLA}/chr6.dose.vcf.gz --const-fid 0 --recode vcf bgz --out Michigan_HLA


# Combine VCF files

echo "Step 3: Combining VCF files"

header_file="chr1_Topmed_r3.vcf.gz"

gunzip -c "$header_file" | awk '/^#CHROM/ && !header_printed { print; header_printed=1 }' > ${OUTPUT_VCF}


for chr in {1..22}; do

   gunzip -c chr${chr}_Topmed_r3.vcf.gz | awk '!/^#/ { print }' >> ${OUTPUT_VCF}

done


gunzip -c Michigan_HLA.vcf.gz | awk '!/^#/ { print }' >> ${OUTPUT_VCF}


stopdt=$(date '+%d/%m/%Y %H:%M:%S')

echo "Start: $dt"

echo "Stop: $stopdt"

