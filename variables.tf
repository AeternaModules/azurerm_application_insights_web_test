variable "application_insights_web_tests" {
  description = <<EOT
Map of application_insights_web_tests, attributes below
Required:
    - application_insights_id
    - configuration
    - geo_locations
    - kind
    - location
    - name
    - resource_group_name
Optional:
    - description
    - enabled
    - frequency
    - retry_enabled
    - tags
    - timeout
EOT

  type = map(object({
    application_insights_id = string
    configuration           = string
    geo_locations           = list(string)
    kind                    = string
    location                = string
    name                    = string
    resource_group_name     = string
    description             = optional(string)
    enabled                 = optional(bool)
    frequency               = optional(number)
    retry_enabled           = optional(bool)
    tags                    = optional(map(string))
    timeout                 = optional(number)
  }))
  validation {
    condition = alltrue([
      for k, v in var.application_insights_web_tests : (
        length(v.resource_group_name) <= 90
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) > 90]"
  }
  validation {
    condition = alltrue([
      for k, v in var.application_insights_web_tests : (
        !endswith(v.resource_group_name, ".")
      )
    ])
    error_message = "[from resourcegroups.ValidateName: must not end with \".\"]"
  }
  validation {
    condition = alltrue([
      for k, v in var.application_insights_web_tests : (
        length(v.resource_group_name) != 0
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) == 0]"
  }
  validation {
    condition = alltrue([
      for k, v in var.application_insights_web_tests : (
        v.frequency == null || (contains([300, 600, 900], v.frequency))
      )
    ])
    error_message = "must be one of: 300, 600, 900"
  }
  validation {
    condition = alltrue([
      for k, v in var.application_insights_web_tests : (
        alltrue([for x in v.geo_locations : length(x) > 0])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.application_insights_web_tests : (
        v.tags == null || (length(v.tags) <= 50)
      )
    ])
    error_message = "[from tags.Validate: invalid when len(value) > 50]"
  }
  # Note: 9 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

