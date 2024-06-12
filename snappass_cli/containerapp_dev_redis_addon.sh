#!/usr/bin/env bash

# The following commands are used to install the Azure CLI and the latest Container Apps extension
#
# az upgrade
# az extension add --name containerapp --upgrade --allow-preview true
# az provider register --namespace Microsoft.App
# az provider register --namespace Microsoft.OperationalInsights

if [ ! -d snappass ]; then
  git clone https://github.com/id-unibe-ch/snappass
  git -C snappass checkout 369-envvar-redis-password
fi

service="snappass-cli"
environment="dev"
resource_group="rg-$service-$environment"
location="switzerlandnorth"
log_analytics_workspace="log-$service-$environment"
ca_name="ca-$service-$environment"
ca_environment="cae-$service-$environment"
ca_addon_redis="caa-${service}-redis-${environment}"

az group create \
  --name $resource_group \
  --location $location

az monitor log-analytics workspace create \
  --resource-group $resource_group \
  --workspace-name $log_analytics_workspace \
  --location $location

workspace_customerid=$(az monitor log-analytics workspace show \
  --resource-group $resource_group \
  --workspace-name $log_analytics_workspace \
  --query customerId \
  --output tsv)

workspace_key=$(az monitor log-analytics workspace get-shared-keys \
  --resource-group $resource_group \
  --workspace-name $log_analytics_workspace \
  --query primarySharedKey \
  --output tsv)

az containerapp env create \
  --name $ca_environment \
  --resource-group $resource_group \
  --logs-workspace-id "$workspace_customerid" \
  --logs-workspace-key "$workspace_key" \
  --location $location

az containerapp add-on redis create \
  --resource-group $resource_group \
  --name $ca_addon_redis \
  --environment $ca_environment

az containerapp up \
  --name $ca_name \
  --resource-group $resource_group \
  --environment $ca_environment \
  --source="./snappass/" \
  --location $location \
  --browse

# The binding name of container add-ons is limited alphanum and undscores
# therefore set replace the dashes with underscore for the explicit
# binding name to be able to have a service name with dashes.
az containerapp update \
  --name $ca_name \
  --bind "$ca_addon_redis:${ca_addon_redis//-/_}" \
  --resource-group $resource_group
