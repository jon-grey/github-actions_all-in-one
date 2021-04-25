#!/bin/bash
set -euo pipefail

dqt='"'


. ../exports-private.sh

az account set --subscription $AZURE_SUBSCRIPTION_ID

echo "
###########################################################################
#### Setup Terraform on Azure
###########################################################################"

echo "Create az group"
az group show -g ${AZURE_RESOURCE_GROUP_OPS} \
|| az group create -g ${AZURE_RESOURCE_GROUP_OPS} -l ${AZURE_LOCATION}

echo "Create storage account"
az storage account show -n ${AZURE_STORAGE_ACCOUNT_OPS} \
|| az storage account create -n ${AZURE_STORAGE_ACCOUNT_OPS} -g ${AZURE_RESOURCE_GROUP_OPS} -l ${AZURE_LOCATION} --sku Standard_LRS

echo "Create storage container for terraform state"

az storage container exists \
    --account-name ${AZURE_STORAGE_ACCOUNT_OPS} \
    --name ${AZURE_STORAGE_TFSTATE} -o tsv \
| grep -qi true \
|| az storage container create \
    -n ${AZURE_STORAGE_TFSTATE} \
    --account-name ${AZURE_STORAGE_ACCOUNT_OPS}

