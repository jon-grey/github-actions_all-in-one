#!/bin/bash
set -euo pipefail


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


