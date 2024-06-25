#!/usr/bin/env bash

# The following commands are used to install the Azure CLI and the latest Container Apps extension
#
# az upgrade
# az extension add --name containerapp --upgrade --allow-preview true
# az provider register --namespace Microsoft.App
# az provider register --namespace Microsoft.OperationalInsights

if [ ! -d snappass ]; then
  git clone https://github.com/id-unibe-ch/snappass
fi

service="snappass-cli-redis"
environment="dev"
resource_group="rg-$service-$environment"
location="switzerlandnorth"
log_analytics_workspace="log-$service-$environment"
redis_cache="redis-$service-$environment"
ca_name="ca-$service-$environment"
ca_environment="cae-$service-$environment"
tags="environment=$environment division=id subDivision=idsys managedBy=azcli"

az group create \
  --name $resource_group \
  --location $location \
  --tags $tags

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

# Create a Basic C0 (256 MB) Redis Cache
sku="basic"
size="C0"
echo "Creating $redis_cache"
az redis create \
  --name $redis_cache \
  --resource-group $resource_group \
  --location "$location" \
  --sku $sku \
  --vm-size $size

# Get details of an Azure Cache for Redis
echo "Showing details of $redis_cache"
az redis show --name "$redis_cache" --resource-group $resource_group

# Retrieve the hostname and ports for an Azure Redis Cache instance
redis=(
  $(az redis show \
    --name "$redis_cache" \
    --resource-group $resource_group \
    --query "[hostName,enableNonSslPort,port,sslPort]" \
    --output tsv)
  )

# Retrieve the keys for an Azure Redis Cache instance
redis_keys=(
  $(az redis list-keys \
    --name "$redis_cache" \
    --resource-group $resource_group \
    --query "[primaryKey,secondaryKey]" \
    --output tsv)
  )

# Display the retrieved hostname, keys, and ports
echo "Hostname:" ${redis[0]}
echo "Non SSL Port:" ${redis[2]}
echo "Non SSL Port Enabled:" ${redis[1]}
echo "SSL Port:" ${redis[3]}
echo "Primary Key:" ${redis_keys[0]}
echo "Secondary Key:" ${redis_keys[1]}

redis_url="rediss://:${redis_keys[0]}@${redis[0]}:${redis[3]}"
echo "Redis URL: $redis_url"

az containerapp env create \
  --name $ca_environment \
  --resource-group $resource_group \
  --logs-workspace-id "$workspace_customerid" \
  --logs-workspace-key "$workspace_key" \
  --location $location

# Total CPU and memory for all containers defined in a Container App must add up to one of the following CPU
# Memory combinations:
# [cpu: 0.25, memory: 0.5Gi]
# [cpu: 0.5, memory: 1.0Gi]
# [cpu: 0.75, memory: 1.5Gi]
# [cpu: 1.0, memory: 2.0Gi]
# [cpu: 1.25, memory: 2.5Gi]
# [cpu: 1.5, memory: 3.0Gi]
# [cpu: 1.75, memory: 3.5Gi]
# [cpu: 2.0, memory: 4.0Gi]
# [cpu: 2.25, memory: 4.5Gi]
# [cpu: 2.5, memory: 5.0Gi]
# [cpu: 2.75, memory: 5.5Gi]
# [cpu: 3, memory: 6.0Gi]
# [cpu: 3.25, memory: 6.5Gi]
# [cpu: 3.5, memory: 7Gi]
# [cpu: 3.75, memory: 7.5Gi]
# [cpu: 4, memory: 8Gi]
  # --bind $redis_cache:${redis_cache//-/_} \
# az containerapp create \
#   --name $ca_name \
#   --resource-group $resource_group \
#   --environment $ca_environment \
#   --min-replicas 1 \
#   --max-replicas 1 \
#   --ingress external \
#   --target-port 5000 \
#   --cpu 0.5 \
#   --memory 1.0Gi \
#   --image "ghcr.io/pinterest/snappass/snappass:4acef097e8ad64933e53c17ca5f1144bacc4859f" \
#   --env-vars "REDIS_URL=$redis_url"

az containerapp up \
  --name $ca_name \
  --resource-group $resource_group \
  --environment $ca_environment \
  --env-vars "REDIS_URL=$redis_url" \
  --source="./snappass/" \
  --location $location

