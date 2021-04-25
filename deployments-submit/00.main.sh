#!/bin/bash
set -euo pipefail

. ../exports.sh
. ../exports-private.sh

mkdir -p .files

export LOCAL_BLOB_FILE=".files/storage-blob-random-suffix"

if ! test -f "$LOCAL_BLOB_FILE"; then 
    echo $(random) > $LOCAL_BLOB_FILE
fi

export BLOB_NUMBER=$(cat $LOCAL_BLOB_FILE)


echo "
###########################################################################
#### Test infrastructure management deployments setup
###########################################################################"
bash 02.make.terraform.tfvars.sh
bash 02.setup.azure.blob.terraform-tfstate.sh
bash 03.test.local.docker-compose.sh
bash 03.test.local.terraform.sh

git add --all
git commit -m "Lazy update at $(date)."
git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)