# Azure Dev Environment using Terraform

## Prerequisites

* Azure CLI
* Terraform

See [this page](getting_started.md#installing-requirements) for installation
instructions for macOS and additional deep links to the documentation for other
platforms.

## Authenticating to Azure

For this playground, authenticating to Azure using the Azure CLI is the way to
go. For a production environment using CI/CD, other mean like using a service
principal and a client certificate is surely more appropriate. See the [official
documentation on this topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
for more information.

Firstly, login to the Azure CLI using:

    az login

Once logged in - it's possible to list the Subscriptions associated with the
account via:

    az account list

Should you have more than one Subscription, you can specify the Subscription to
use via the following command:

    az account set --subscription="SUBSCRIPTION_ID"
