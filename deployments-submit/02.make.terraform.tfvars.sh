#!/bin/bash
set -euo pipefail

dqt='"'




. ../exports-private.sh

az account set --subscription $AZURE_SUBSCRIPTION_ID

# Generate Azure client id and secret.
export RBAC_JSON="$HOME/rbac.json"

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

function rdict {
	python3 -c "print($1[${dqt}$2${dqt}])"
}

ARM_TENANT_ID=$(rdict     "$RBAC" "tenant")
ARM_CLIENT_ID=$(rdict     "$RBAC" "appId")
ARM_CLIENT_SECRET=$(rdict "$RBAC" "password")

echo "
###########################################################################
#### Populate terraform variables file
###########################################################################"

TFVARS="../deployments/terraform.tfvars"

echo "
az_location                 = ${dqt}${AZURE_LOCATION}${dqt}
az_storage_tfstate          = ${dqt}${AZURE_STORAGE_TFSTATE}${dqt}
az_storage_account_ops      = ${dqt}${AZURE_STORAGE_ACCOUNT_OPS}${dqt}
az_storage_account_devs     = ${dqt}${AZURE_STORAGE_ACCOUNT_DEVS}${dqt}
az_resource_group_name_devs = ${dqt}${AZURE_RESOURCE_GROUP_DEVS}${dqt}
az_resource_group_name_ops  = ${dqt}${AZURE_RESOURCE_GROUP_OPS}${dqt}
date                        = ${dqt}$(date)${dqt}
" > $TFVARS
cat $TFVARS

echo "
###########################################################################
#### Populate terraform provider file
###########################################################################"

echo "

terraform {
  backend ${dqt}azurerm${dqt} {
    resource_group_name  = ${dqt}${AZURE_RESOURCE_GROUP_OPS}${dqt}
    storage_account_name = ${dqt}${AZURE_STORAGE_ACCOUNT_OPS}${dqt}
    container_name       = ${dqt}${AZURE_STORAGE_TFSTATE}${dqt}
    key                  = ${dqt}terraform.tfstate${dqt}
  }
}

" > "../deployments/provider.tf"

echo "
###########################################################################
#### Populate .github/workflows env vars
###########################################################################"

for fp in ../.github/workflows/*.yml; do

sed \
  -i "s/AZURE_STORAGE_TFSTATE:\s.*/AZURE_STORAGE_TFSTATE: ${AZURE_STORAGE_TFSTATE}/" \
  $fp

sed \
  -i "s/AZURE_STORAGE_ACCOUNT_OPS:\s.*/AZURE_STORAGE_ACCOUNT_OPS: ${AZURE_STORAGE_ACCOUNT_OPS}/" \
  $fp

done



