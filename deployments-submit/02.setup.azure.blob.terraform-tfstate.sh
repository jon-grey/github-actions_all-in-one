#!/bin/bash
set -euo pipefail


az account set --subscription $AZURE_SUBSCRIPTION_ID

echo "
###########################################################################
#### Setup Terraform on Azure
###########################################################################"

echo "Create storage container for terraform state"

az storage container exists \
    --account-name ${AZURE_STORAGE_ACCOUNT_OPS} \
    --name ${AZURE_STORAGE_BLOB_TFSTATE} -o tsv \
| grep -qi true \
|| az storage container create \
    -n ${AZURE_STORAGE_BLOB_TFSTATE} \
    --account-name ${AZURE_STORAGE_ACCOUNT_OPS}

