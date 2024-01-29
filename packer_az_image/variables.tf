variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "resource_group_name" {
  description = "Azure Terraform Backend Resource Group Name"
  type        = string
  default     = "rg-sysimagefactory-terraform-dev"
}

variable "storage_account_name" {
  description = "Azure Storage Account Name"
  type        = string
  default     = "stsysimagefactorytf"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "service_display_name" {
  description = "Azure Service Display Name"
  type        = string
  default     = "UniBE - System Image Factory"
}

variable "service_name" {
  description = "Azure Service Name"
  type        = string
  default     = "sysimagefactory"
}

variable "stage" {
  description = "Staging area"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.stage)
    error_message = "Valid values for var: stage are \"dev\" or \"prod\""
  }
}

variable "azlocation" {
  description = "Azure region where Terraform will create resources"
  type        = string
  default     = "switzerlandnorth"

  validation {
    # condition     = contains(["switzerlandnorth", "switzerlandwest"], var.azlocation)
    condition     = contains(["switzerlandnorth"], var.azlocation)
    error_message = "Valid value for var: azlocation is \"switzerlandnorth\""
  }
}

variable "azproject_tags" {
  description = "Standard Azure tags to apply to resources"
  type        = map(string)
}
