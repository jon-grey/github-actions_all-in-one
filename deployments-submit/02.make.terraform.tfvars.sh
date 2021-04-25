#!/bin/bash
set -euo pipefail

az account set --subscription $AZURE_SUBSCRIPTION_ID

# Generate Azure client id and secret.
if test -f "$RBAC_JSON"; then
	RBAC="$(cat $RBAC_JSON)"
else
	echo "[ERROR] no RBAC file"
    exit 1
fi

echo "
###########################################################################
#### Read variables from RBAC dict
###########################################################################"

ARM_TENANT_ID=$(rdict     "$RBAC" "tenant")
ARM_CLIENT_ID=$(rdict     "$RBAC" "appId")
ARM_CLIENT_SECRET=$(rdict "$RBAC" "password")

echo "
###########################################################################
#### Populate terraform variables file
###########################################################################"

TFVARS="../deployments/terraform.tfvars"

echo "
az_location                 = ${DQT}${AZURE_LOCATION}${DQT}
az_storage_tfstate          = ${DQT}${AZURE_STORAGE_BLOB_TFSTATE_LOCAL}${DQT}
az_storage_account_ops      = ${DQT}${AZURE_STORAGE_ACCOUNT_OPS}${DQT}
az_storage_account_devs     = ${DQT}${AZURE_STORAGE_ACCOUNT_DEVS}${DQT}
az_resource_group_name_devs = ${DQT}${AZURE_RESOURCE_GROUP_DEVS}${DQT}
az_resource_group_name_ops  = ${DQT}${AZURE_RESOURCE_GROUP_OPS}${DQT}
date                        = ${DQT}$(date)${DQT}
" > $TFVARS
cat $TFVARS

echo "
###########################################################################
#### Populate terraform provider file
###########################################################################"

echo "

terraform {
  backend ${DQT}azurerm${DQT} {
    resource_group_name  = ${DQT}${AZURE_RESOURCE_GROUP_OPS}${DQT}
    storage_account_name = ${DQT}${AZURE_STORAGE_ACCOUNT_OPS}${DQT}
    container_name       = ${DQT}${AZURE_STORAGE_BLOB_TFSTATE_LOCAL}${DQT}
    key                  = ${DQT}terraform.tfstate${DQT}
  }
}

" > "../deployments/provider.tf"

echo "
###########################################################################
#### Populate .github/workflows env vars
###########################################################################"

for fp in ../.github/workflows/*.yml; do

sed \
  -i "s/AZURE_STORAGE_BLOB_TFSTATE:\s.*/AZURE_STORAGE_BLOB_TFSTATE: ${AZURE_STORAGE_BLOB_TFSTATE_LOCAL}/" \
  $fp

sed \
  -i "s/AZURE_STORAGE_ACCOUNT_OPS:\s.*/AZURE_STORAGE_ACCOUNT_OPS: ${AZURE_STORAGE_ACCOUNT_OPS}/" \
  $fp

done



