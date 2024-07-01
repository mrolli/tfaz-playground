#!/usr/bin/env bash

if [ ! -d snappass ]; then
  git clone https://github.com/id-unibe-ch/snappass
fi

service="snappass-webapp-redis"
environment="dev"
resource_group="rg-$service-$environment"
location="switzerlandnorth"
log_analytics_workspace="log-$service-$environment"
appservice_plan_name="asp-$service-$environment"
appservice_name="app-$service-$environment"
redis_cache="redis-$service-$environment"
tags="environment=$environment division=id subDivision=idsys managedBy=azcli"

# Let all the following commands run from the snappass code directory
cd snappass/snappass || exit
# Rename the main module to app as gunucorn
# will look for application.py or app.py only.
git mv main.py app.py
# Copy the requirements.txt file to the code directory
cp ../requirements.txt .

# Create venv and feth dependencies
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
# Now we are ready to deploy to Azure

az group create \
  --name $resource_group \
  --location $location \
  --tags $tags

az monitor log-analytics workspace create \
  --resource-group $resource_group \
  --workspace-name $log_analytics_workspace \
  --location $location

workspace_id=$(az monitor log-analytics workspace show \
  --resource-group $resource_group \
  --workspace-name $log_analytics_workspace \
  --query id \
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

echo "Create an Appservice plan"
az appservice plan create \
  --name "$appservice_plan_name" \
  --resource-group "$resource_group" \
  --sku "B1" \
  --is-linux \
  --location $location

echo "Create the snappass-webapp"
az webapp up \
  --resource-group $resource_group \
  --name $appservice_name \
  --runtime "PYTHON:3.11" \
  --plan "$appservice_plan_name" \
  --location $location

# az webapp create \
#   --resource-group $resource_group \
#   --name $appservice_name \
#   --runtime "PYTHON:3.11" \
#   --plan "$appservice_plan_name" \
#   --startup-file "startup.sh"

webapp_id=$(az webapp show \
  --resource-group $resource_group \
  --name $appservice_name \
  --query id \
  --output tsv)

if [ -z "$webapp_id" ]; then
  echo "Webapp not found"-
  exit 1
fi

echo "Bind log-analytics workspace to webapp"
az monitor diagnostic-settings create --resource "$webapp_id" \
 --workspace "$workspace_id" \
 --name "myMonitorLogs" \
 --logs '[{"category": "AppServiceConsoleLogs", "enabled": true},
  {"category": "AppServiceHTTPLogs", "enabled": true}]'

echo "Set App Settings like REDIS_URL"
az webapp config appsettings set \
  --resource-group $resource_group \
  --name $appservice_name \
  --settings REDIS_URL="$redis_url" SCM_DO_BUILD_DURING_DEPLOYMENT=1

# echo "Starting the webapp"
# az webapp start \
#   --resource-group $resource_group \
#   --name $appservice_name

# echo "Setting up logging"
# az webapp log config \
#     --web-server-logging filesystem \
#     --name $appservice_name \
#     --resource-group $resource_group

# az webapp config set \
#   --resource-group $resource_group \
#   --name $appservice_name \
#   --startup-file "startup.sh"
#
# az webapp log tail \
#     --resource-group $resource_group \
#     --name $appservice_name
#
# az webapp ssh \
#   --resource-group $resource_group \
#   --name $appservice_name
