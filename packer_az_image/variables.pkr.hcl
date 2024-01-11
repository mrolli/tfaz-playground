variable "az_region" {
  description = "The Azure region where the Resource Group exists."
  type        = string
  default     = "switzerlandnorth"
}

variable "az_resource_group" {
  description = "An existing Azure Resource Group where the build will take place and images will be stored."
  type        = string
}

variable "az_image_gallery" {
  description = "An existing Azure Compute Gallery (FKA Shared Image Gallery). The image definition must also exist."
  type        = string
}

variable "az_subscription_id" {
  description = "Your Azure Subscription ID (required)."
  type        = string
  sensitive   = true
}

variable "az_tenant_id" {
  description = "Your Azure Tenant ID (if not specified it is looked up with the subscription_id)."
  type        = string
  sensitive   = true
}

variable "az_client_id" {
  description = "Your Azure service principal's id to use."
  type        = string
  sensitive   = true
}

variable "az_client_secret" {
  description = "Your Azure service principals shared secret to use."
  type        = string
  sensitive   = true
}


variable "division" {
  description = "A value for the \"division\" tag."
  type        = string
}

variable "subDivision" {
  description = "A value for the \"subDivision\" tag."
  type        = string
}

variable "owner" {
  description = "A value for the \"owner\" tag."
  type        = string
  default     = "image.engineer"
}

variable "prefix" {
  description = "This prefix will be included in the name of most resources."
  type        = string
  default     = "id"
}
