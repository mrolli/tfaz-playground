variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "azure_region" {
  description = "Azure Region where Terraform will create resources"
  type        = string
  default     = "switzerlandnorth"
}

variable "azure_application_name" {
  description = "Azure Application Name"
  type        = string
  default     = "UniBE - IDSYS - Packer Images"
}

variable "azure_resource_group" {
  description = "Azure Resource Grolup name where Terraform will create infrastructure"
  type        = string
}

variable "azure_image_gallery_name" {
  description = "Azure Image Gallery name where packer will create images"
  type        = string
}

variable "azure_tags" {
  description = "Standard Azure tags to apply to resources"
  type        = map(string)
}
