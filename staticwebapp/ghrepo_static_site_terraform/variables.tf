variable "location" {
  type        = string
  description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uksouth')"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.location))
    error_message = "The location must only contain lowercase letters, numbers, and hyphens"
  }
  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or less"
  }
}

variable "resource_name_location_short" {
  type        = string
  description = "The short name segment for the location"
  default     = ""
  validation {
    condition     = length(var.resource_name_location_short) == 0 || can(regex("^[a-z]+$", var.resource_name_location_short))
    error_message = "The short name segment for the location must only contain lowercase letters"
  }
  validation {
    condition     = length(var.resource_name_location_short) <= 3
    error_message = "The short name segment for the location must be 3 characters or less"
  }
}

variable "resource_name_workload" {
  type        = string
  description = "The name segment for the workload"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.resource_name_workload))
    error_message = "The name segment for the workload must only contain lowercase letters, numbers and dashes"
  }
  validation {
    condition     = length(var.resource_name_workload) <= 16
    error_message = "The name segment for the workload must be 4 characters or less"
  }
}

variable "github_organisation" {
  type        = string
  description = "The GitHub organisation where the repository is located."
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.github_organisation))
    error_message = "The GitHub organisation must only contain letters, numbers and dashes"
  }
  validation {
    condition     = length(var.github_organisation) <= 39
    error_message = "The GitHub organisation must be 39 characters or less"
  }
}

variable "repository_name" {
  type        = string
  description = "The name of the repo without the organisation."
}

variable "repository_branch" {
  type        = string
  description = "The default branch to use."
  default     = "main"
}

variable "app_config" {
  type = object({
    app_location    = optional(string, "")
    api_location    = optional(string, "")
    output_location = optional(string, "")
  })
  description = "Path to the static contents"
}

variable "custom_domain" {
  type        = string
  description = "The custom domain to use for the static web app. If not set, no custom domain will be configured."
  nullable    = true
  default     = null
  validation {
    condition     = length(var.custom_domain) > 0 || var.custom_domain == null
    error_message = "The custom domain must not be empty"
  }
}

variable "resource_name_environment" {
  type        = string
  description = "The name segment for the environment"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_environment))
    error_message = "The name segment for the environment must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.resource_name_environment) <= 4
    error_message = "The name segment for the environment must be 4 characters or less"
  }
}

variable "resource_name_templates" {
  type        = map(string)
  description = "A map of resource names to use"
  default = {
    resource_group_name = "rg-$${workload}-$${environment}"
    staticwebapp_name   = "stapp-$${workload}-$${environment}"
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Flag to enable/disable telemetry"
}
