variable "project" {
  type        = string
  default     = ""
  description = "Project name: eng/saas"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment: pro/stg/dev"
}

variable "workload" {
  type        = string
  default     = ""
  description = "Solution name: system/zync/backend/keycloak/apicast/apicurio"
}

variable "type" {
  type        = string
  default     = ""
  description = "Abreviated resource type: i, sg, vpc, rt, s3, rds, es, ec ..."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tf_config" {
  type        = string
  default     = ""
  description = "The Terraform Config that owns the resource"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = "Additional tags for appending to each tag map"
}

variable "context" {
  type = object({
    environment = string
    project     = string
    workload    = string
    type        = string

    enabled             = bool
    delimiter           = string
    tf_config           = string
    attributes          = list(string)
    label_order         = list(string)
    tags                = map(string)
    additional_tag_map  = map(string)
    regex_replace_chars = string
  })
  default = {
    environment = ""
    project     = ""
    workload    = ""
    type        = ""

    enabled             = true
    delimiter           = ""
    tf_config           = ""
    attributes          = []
    label_order         = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = ""
  }
  description = "Default context to use for passing state between label invocations"
}

variable "label_order" {
  type        = list(string)
  default     = []
  description = "The naming order of the id output and Name tag"
}

variable "regex_replace_chars" {
  type        = string
  default     = "/[^a-zA-Z0-9-.]/"
  description = "Regex to replace chars with empty string in `project`, `environment` and `workload`. By default only hyphens, letters and digits are allowed, all other chars are removed"
}

