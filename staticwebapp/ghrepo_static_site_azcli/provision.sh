#!/usr/bin/env bash

set -e

github_repo_url="https://github.com/mrolli/books"
branch="main"
app_path="/Bibliothek"
custom_url="cloud-books.rollis.ch"

service="books-azcli"
location="westeurope"
environment="test"
tags="environment=$environment division=id subDivision=idci managedBy=azcli"
#randsuffix=$(LC_ALL=C tr -dc "a-z0-9" </dev/urandom | head -c 3)
sku_stapp="Free"

# Resource names
resource_group_name=$(printf "rg-%s-%s" "$service" "$environment")
static_webapp_name=$(printf "stapp-%s-%s" "$service" "$environment")

if [ "$1" == "-d" ]; then
  az group delete \
    --name "$resource_group_name" \
    --yes --no-wait
  exit 0
fi

# Create resource group
if ! az group show --name "$resource_group_name" &>/dev/null; then
  az group create \
    --name "$resource_group_name" \
    --location "$location" \
    --tags $tags \
    --query "name"
fi

# Create static web app
if ! az staticwebapp show -n "$static_webapp_name" -g "$resource_group_name" &>/dev/null; then
  az staticwebapp create \
    --name "$static_webapp_name" \
    --resource-group "$resource_group_name" \
    --location "$location" \
    --source "$github_repo_url" \
    --branch "$branch" \
    --app-location "$app_path" \
    --login-with-github \
    --sku "$sku_stapp" \
    --query "defaultHostname"
  # --token $github_token
fi

if ! az staticwebapp hostname show -n "$static_webapp_name" -g "$resource_group_name" \
  --hostname "$custom_url" &>/dev/null; then
  az staticwebapp hostname set \
    --name "$static_webapp_name" \
    --hostname "$custom_url" \
    --no-wait
else
  az staticwebapp hostname show \
    --name "$static_webapp_name" \
    --resource-group "$resource_group_name" \
    --hostname "$custom_url" \
    --query "{name:name,status:status}"
fi
