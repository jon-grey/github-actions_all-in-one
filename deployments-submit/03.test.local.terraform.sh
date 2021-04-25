#!/bin/bash
set -euo pipefail

dqt='"'

export TF_WARN_OUTPUT_ERRORS=1

echo "
###########################################################################
#### Create service principal and save to $HOME/rbac.json
###########################################################################"

. ../exports-private.sh

az account set --subscription $AZURE_SUBSCRIPTION_ID

(
    cd ../deployments/terraform

    echo "Format terraform files..."
    terraform fmt
    echo "... with RC ==> $?"

    echo "Init terraform..."
    terraform init 
    echo "... with RC ==> $?"

    echo "Validate terraform confif files..."
    terraform validate
    echo "... with RC ==> $?"

    echo "Plan terraform..."
    terraform plan
    echo "... with RC ==> $?"
)


