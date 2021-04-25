#!/bin/bash
set -euo pipefail

echo "
###########################################################################
#### Setup infrastructure management deployments
###########################################################################"
bash 01.deploy.azure.rbac.sh
bash 01.setup.local.terraform.sh
bash 02.setup.azure.terraform.sh

