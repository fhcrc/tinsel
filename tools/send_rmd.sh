#!/bin/bash

set -eu

document=$1
shiny_app_dir=$2
gxy_uid=$3

if [ ! -d "${shiny_app_dir}" ]; then
    echo "${shiny_app_dir} not found or not a directory" >&2
    exit 1
fi

deployed_rmd="${shiny_app_dir}/$(basename ${document} .dat).Rmd"

cp -a "${document}" "${deployed_rmd}"

echo "deployed to ${shiny_app_dir} as $(basename ${deployed_rmd})"
