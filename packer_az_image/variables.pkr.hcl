variable "region" {
  description = "The Azure region where the Resource Group exists."
  type        = string
  default     = "switzerlandnorth"
}

variable "resource_group" {
  description = "An existing Azure Resource Group where the build will take place and images will be stored."
  type        = string
}

variable "image_gallery" {
  description = "An existing Azure Compute Gallery (FKA Shared Image Gallery). The image definition must also exist."
  type        = string
}

variable "subscription_id" {
  description = "Your Azure Subscription ID (required)."
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Your Azure service principal's id to use."
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Your Azure service principals shared secret to use."
  type        = string
  sensitive   = true
}

variable "project_tags" {
  description = "A set of project tags."
  type        = map(string)
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
